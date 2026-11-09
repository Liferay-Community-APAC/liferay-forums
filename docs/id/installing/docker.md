---
title: Liferay Self-Hosted (Docker)
parent: Instalasi
nav_order: 2
---

# Instalasi di Liferay Self-Hosted (Docker) {#installing-on-liferay-self-hosted-docker}
{: .no_toc }

Liferay dan PostgreSQL berjalan di dalam container, dan microservice forum berjalan di container ketiga yang berbagi jaringan dengan Liferay, sehingga Liferay menjangkaunya di `localhost:58081` seperti di server. Anda menyalin zip forum ke container Liferay yang sedang berjalan, dengan urutan yang sama seperti di server. Langkah-langkah ini telah diuji dengan image `liferay/dxp:2026.q1.4-lts`.

{: .important }
Anda memerlukan Docker. Jalankan perintah-perintah dari folder yang berisi tiga zip rilis, yang diunduh dari [rilis terbaru](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest).

1. TOC
{:toc}

## Langkah 1: Tambahkan Perbaikan Liferay {#step-1-add-the-liferay-fixes}

Buat folder bernama `patching` di samping zip-zip tersebut, dan letakkan hotfix dari Liferay Support di dalamnya. Liferay menginstalnya setiap kali container-nya dimulai. Tanpa hotfix, biarkan folder tersebut kosong, dan gunakan [solusi sementara](./#without-a-hotfix).

## Langkah 2: Mulai PostgreSQL dan Liferay {#step-2-start-postgresql-and-liferay}

1. Buat jaringan untuk container, lalu mulai PostgreSQL. Ganti `change-me` dengan kata sandi Anda sendiri, di sini dan di perintah berikutnya:

    ```bash
    docker network create forums
    docker run -d --name forums-postgres --network forums --restart unless-stopped \
      -e POSTGRES_DB=lportal -e POSTGRES_USER=liferay -e POSTGRES_PASSWORD=change-me \
      -v forums-postgres-data:/var/lib/postgresql/data \
      postgres:16.15
    ```

1. Mulai Liferay. Volume `forums-liferay-routes` menyimpan kredensial yang ditulis Liferay untuk microservice:

    ```bash
    docker run -d --name forums-liferay --network forums -p 8080:8080 --restart unless-stopped \
      -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_DRIVER_UPPERCASEC_LASS_UPPERCASEN_AME=org.postgresql.Driver \
      -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_URL=jdbc:postgresql://forums-postgres:5432/lportal \
      -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_USERNAME=liferay \
      -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_PASSWORD=change-me \
      -v forums-liferay-data:/opt/liferay/data \
      -v forums-liferay-routes:/opt/liferay/routes \
      -v "$PWD/patching:/mnt/liferay/patching" \
      liferay/dxp:2026.q1.4-lts
    ```

1. Tunggu hingga Liferay selesai dimulai: `docker logs forums-liferay` menampilkan `Server startup in`. Proses ini memakan waktu beberapa menit. Liferay kemudian tersedia di `http://localhost:8080`.

## Langkah 3: Deploy Batch {#step-3-deploy-the-batch}

1. Salin batch ke container yang sedang berjalan:

    ```bash
    docker cp liferay-forums-batch.zip forums-liferay:/opt/liferay/osgi/client-extensions/
    ```

1. Pantau log, dan tunggu hingga log menampilkan lima baris yang berisi `Finished batch engine import task` setelah penyalinan, lalu tekan **Ctrl+C**:

    ```bash
    docker logs -f --since 2m forums-liferay | grep "Finished batch engine import task"
    ```

{: .warning }
Liferay juga mencatat beberapa baris seperti ini saat dimulai. Hitung hanya baris yang muncul setelah penyalinan, dan jangan lanjutkan sebelum kelimanya selesai.

## Langkah 4: Deploy Zip Microservice {#step-4-deploy-the-microservices-zip}

```bash
docker cp liferay-forums-etc-spring-boot.zip forums-liferay:/opt/liferay/osgi/client-extensions/
```

Tunggu hingga `docker logs forums-liferay` menampilkan `STARTED liferayforumsetcspringboot`.

## Langkah 5: Mulai Microservice {#step-5-start-the-microservice}

1. Bangun image microservice dari `Dockerfile` di dalam zip-nya:

    ```bash
    mkdir microservice
    unzip liferay-forums-etc-spring-boot.zip -d microservice
    docker build -t liferay-forums-microservice microservice
    ```

1. Mulai microservice di jaringan Liferay, dengan volume kredensial Liferay:

    ```bash
    docker run -d --name forums-microservice --network container:forums-liferay --restart unless-stopped \
      -v forums-liferay-routes:/opt/liferay/routes:ro \
      -e LIFERAY_ROUTES_CLIENT_EXTENSION=/opt/liferay/routes/default/liferay-forums-etc-spring-boot \
      -e LIFERAY_ROUTES_DXP=/opt/liferay/routes/default/dxp \
      liferay-forums-microservice
    ```

1. Pastikan Liferay dapat menjangkaunya. Perintah ini mencetak `READY`:

    ```bash
    docker exec forums-liferay curl -s http://localhost:58081/ready
    ```

## Langkah 6: Siapkan Notifikasi Email {#step-6-set-up-email-notifications}

Batch membuat dua template email dengan alamat pengirim placeholder. Atur alamat yang sebenarnya, lalu restart microservice dengan `docker restart forums-microservice`, sebelum anggota menerima email. Lihat [Notifikasi Email](../administering/email-notifications.html).

## Langkah 7: Buat Situs Forum {#step-7-create-the-forum-sites}

Lanjutkan dengan [Membuat Situs Forum](creating-sites.html).

## Penggunaan Sehari-hari {#day-to-day}

- **Setelah container Liferay di-restart,** restart juga container microservice, karena container tersebut berbagi jaringan dengan Liferay: `docker restart forums-microservice`.
- **Zip-zip berada di dalam container Liferay.** Jika Anda menghapus container tersebut dan memulai container baru, misalnya untuk mengubah pengaturan atau image, container baru tidak memiliki zip forum apa pun. Salin batch, lalu zip microservice, seperti pada Langkah 3 dan 4. Kemudian hapus container microservice dan mulai lagi dengan perintah `docker run` dari Langkah 5: container tersebut terikat ke container Liferay yang lama, sehingga me-restart-nya akan gagal.

    ```bash
    docker rm -f forums-microservice
    ```
- **Log:** `docker logs forums-liferay` dan `docker logs forums-microservice`.

## Informasi Terkait {#related-information}

- [Memeriksa Instalasi](checking.html)
- [Instalasi](./)
