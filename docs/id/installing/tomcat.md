---
title: Liferay Self-Hosted (Tomcat)
parent: Instalasi
nav_order: 1
---

# Instalasi di Liferay Self-Hosted (Tomcat) {#installing-on-liferay-self-hosted-tomcat}
{: .no_toc }

Ikuti langkah-langkah ini jika Liferay diinstal dari bundle Tomcat di server yang Anda kelola.

{: .important }
Anda memerlukan akses file ke server Liferay, [perbaikan Liferay yang diperlukan](./#required-liferay-fixes) yang diinstal dengan [patching tool](https://learn.liferay.com/w/dxp/self-hosted-installation-and-upgrades/maintaining-a-liferay-installation/patching-liferay) Liferay atau solusi sementaranya, dan Liferay harus sudah selesai dimulai sebelum Anda memulai. Dalam langkah-langkah di bawah ini, `<liferay-home>` adalah folder instalasi Liferay, yaitu folder yang berisi folder `osgi` dan `routes`.

1. TOC
{:toc}

## Langkah 1: Unduh Rilis {#step-1-download-the-release}

Dari [rilis terbaru](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest), unduh:

- [`liferay-forums-batch.zip`](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest/download/liferay-forums-batch.zip)
- [`liferay-forums-etc-spring-boot.zip`](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest/download/liferay-forums-etc-spring-boot.zip)
- [`liferay-forums-site-initializer.zip`](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest/download/liferay-forums-site-initializer.zip)
- [`generate-site-initializer-zips.sh`](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest/download/generate-site-initializer-zips.sh), hanya untuk menjalankan beberapa situs forum dengan skrip; lihat [Membuat Situs Forum](creating-sites.html#a-shortcut-on-liferay-self-hosted).

## Langkah 2: Deploy Batch {#step-2-deploy-the-batch}

1. Salin `liferay-forums-batch.zip` ke `<liferay-home>/osgi/client-extensions`.

1. Tunggu hingga log Liferay menampilkan lima baris yang berisi `Finished batch engine import task` setelah penyalinan. Proses ini memakan waktu sekitar satu menit.

{: .warning }
Jangan lanjutkan sebelum kelimanya selesai. Microservice yang di-deploy pada langkah berikutnya hanya mendapatkan akses ke bagian forum yang sudah ada pada saat itu. Liferay juga mencatat beberapa baris seperti ini saat dimulai, jadi hitung hanya baris yang muncul setelah penyalinan.

## Langkah 3: Deploy Zip Microservice {#step-3-deploy-the-microservices-zip}

Salin `liferay-forums-etc-spring-boot.zip` ke `<liferay-home>/osgi/client-extensions`.

Liferay mendaftarkan microservice dan menulis kredensialnya ke `<liferay-home>/routes/default`. Liferay tidak menjalankan microservice itu sendiri; langkah berikutnya yang memulainya.

## Langkah 4: Mulai Microservice {#step-4-start-the-microservice}

Microservice harus berjalan setiap kali Liferay berjalan: posting, notifikasi, dan moderasi semuanya bergantung padanya. Jalankan di mesin Liferay jika memungkinkan; cara ini lebih sederhana.

### Di Mesin Liferay {#on-the-liferay-machine}

1. Ekstrak `liferay-forums-etc-spring-boot.zip` ke folder pilihan Anda, seperti `/opt/liferay-forums`.

1. Dari folder tersebut, mulai microservice dengan `LIFERAY_HOME` diatur ke folder instalasi Liferay. Microservice menemukan alamat Liferay dan kredensialnya di sana, sehingga tidak ada yang perlu dikonfigurasi.

    Di Linux:

    ```bash
    LIFERAY_HOME=/opt/liferay ./start.sh
    ```

    Di Windows:

    ```bat
    set LIFERAY_HOME=C:\liferay
    start.bat
    ```

    Jika microservice berhenti dengan pesan bahwa routes tidak ada, zip-nya belum di-deploy ke Liferay tersebut, atau `LIFERAY_HOME` menunjuk ke folder yang salah.

1. Pastikan microservice berjalan. Perintah ini mencetak `READY`:

    ```bash
    curl http://localhost:58081/ready
    ```

{: .tip }
Agar tetap berjalan setelah reboot di Linux, jalankan sebagai layanan sistem. Misalnya, unit systemd di `/etc/systemd/system/liferay-forums.service`:

```ini
[Unit]
Description=Liferay Forums microservice
After=network.target

[Service]
User=liferay
Environment=LIFERAY_HOME=/opt/liferay
WorkingDirectory=/opt/liferay-forums
ExecStart=/opt/liferay-forums/start.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Lalu jalankan `sudo systemctl enable --now liferay-forums`.

### Di Mesin Lain {#on-another-machine}

Liferay selalu memanggil microservice di `localhost:58081`, jadi port `58081` di mesin Liferay harus diteruskan ke mesin microservice.

1. Di mesin microservice, ekstrak `liferay-forums-etc-spring-boot.zip` ke folder pilihan Anda.

1. Di `application.properties`, di samping file jar, hapus tanda komentar dan isi empat pengaturan berikut:

    ```properties
    com.liferay.lxc.dxp.mainDomain=liferay.example.com
    com.liferay.lxc.dxp.server.protocol=https
    liferay-forums-etc-spring-boot-oahs.oauth2.headless.server.client.id=<client ID>
    liferay-forums-etc-spring-boot-oahs.oauth2.headless.server.client.secret=<client secret>
    ```

    `mainDomain` dan `server.protocol` menentukan cara microservice menjangkau Liferay; sertakan port di `mainDomain` kecuali port-nya 80 atau 443. Client ID dan secret adalah milik **Liferay Forums Etc Spring Boot OAuth Application Headless Server**, di *Control Panel* → *Security* → *OAuth 2 Administration*.

1. Mulai microservice tanpa `LIFERAY_HOME`: `./start.sh` di Linux, atau `start.bat` di Windows.

1. Di mesin Liferay, teruskan port `58081` ke mesin microservice, dan biarkan penerusan tetap berjalan selama microservice berjalan. Izinkan port `58081` melewati firewall apa pun di antara kedua mesin. Anda dapat menjalankan `socat` di mesin Liferay:

    ```bash
    socat TCP-LISTEN:58081,bind=127.0.0.1,fork,reuseaddr TCP:<microservice-host>:58081
    ```

    Atau buka tunnel SSH dari mesin microservice:

    ```bash
    ssh -N -R 58081:localhost:58081 <user>@<liferay-host>
    ```

1. Di mesin Liferay, pastikan penerusan menjangkau microservice. Perintah ini mencetak `READY`:

    ```bash
    curl http://localhost:58081/ready
    ```

## Langkah 5: Siapkan Notifikasi Email {#step-5-set-up-email-notifications}

Batch membuat dua template email dengan alamat pengirim placeholder. Atur alamat yang sebenarnya, lalu restart microservice, sebelum anggota menerima email. Lihat [Notifikasi Email](../administering/email-notifications.html).

## Langkah 6: Buat Situs Forum {#step-6-create-the-forum-sites}

Lanjutkan dengan [Membuat Situs Forum](creating-sites.html).

## Informasi Terkait {#related-information}

- [Memeriksa Instalasi](checking.html)
- [Instalasi](./)
