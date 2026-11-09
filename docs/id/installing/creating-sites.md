---
title: Membuat Situs Forum
parent: Instalasi
nav_order: 5
---

# Membuat Situs Forum {#creating-forum-sites}
{: .no_toc }

Setiap forum adalah situs Liferay, yang dibuat oleh site initializer saat di-deploy ke Liferay yang sedang berjalan. Satu site initializer membuat tepat satu situs, jadi setiap situs forum memerlukan site initializer tersendiri. Batch dan microservice digunakan bersama oleh semua situs forum, dan di-deploy satu kali.

{: .note }
Forum tidak dapat ditambahkan ke situs yang sudah ada, karena Liferay menyiapkan halaman situs hanya saat membuat situs tersebut. Sebagai gantinya, buat situs forum, lalu tautkan ke situs tersebut dari situs Anda yang sudah ada.

1. TOC
{:toc}

## Satu Situs {#one-site}

`liferay-forums-site-initializer.zip` membuat situs **FORUMS**, di `/web/forums`.

- **Liferay Self-Hosted (Tomcat):** salin zip ke `<liferay-home>/osgi/client-extensions`. Liferay membuat situs dalam waktu sekitar satu menit. Setelah situs ada, hapus lagi zip tersebut.
- **Liferay Self-Hosted (Docker):** salin zip ke container, tunggu hingga situs dibuat, lalu hapus zip tersebut:

    ```bash
    docker cp liferay-forums-site-initializer.zip forums-liferay:/opt/liferay/osgi/client-extensions/
    docker exec forums-liferay rm /opt/liferay/osgi/client-extensions/liferay-forums-site-initializer.zip
    ```

- **Liferay PaaS dan Liferay SaaS:** instalasi akan membuatnya; lihat [Di Liferay PaaS](paas.html) atau [Di Liferay SaaS](saas.html).

Menghapus zip tidak mengubah situs. Hal ini mencegah site initializer membuat situs lagi, dalam keadaan kosong, jika situs tersebut suatu saat dihapus.

## Beberapa Situs {#several-sites}

Sebelum Anda menambahkan situs, lihat [Menjalankan Beberapa Situs Forum](../administering/several-sites.html), terutama mengenai moderator.

### Langkah 1: Buat Site Initializer untuk Setiap Situs {#step-1-make-a-site-initializer-for-each-site}

Anda menyalin proyek site initializer forum satu kali untuk setiap situs, dan memberikan nama tersendiri pada setiap salinan.

1. Dari [rilis terbaru](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest), unduh kode sumber forum, [`liferay-forums-<version>-source.zip`](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest){: data-release-asset="-source.zip"}, lalu ekstrak. Hasil ekstraksinya adalah folder bernama <span data-release-folder>`liferay-forums-<version>`</span><span data-release-example>, seperti `liferay-forums-1.0.0`</span>; jalankan perintah-perintah di bawah ini dari folder tersebut.

1. Salin seluruh folder `client-extensions/liferay-forums-site-initializer`, beserta semua isinya, ke folder baru di sampingnya, yang dinamai sesuai situs. Untuk situs bernama *Acme*:

    ```bash
    cp -r client-extensions/liferay-forums-site-initializer client-extensions/liferay-forums-site-initializer-acme
    ```

    Di Liferay PaaS, salin folder tersebut ke `liferay/client-extensions` di repositori proyek PaaS Anda, sebagai `liferay/client-extensions/liferay-forums-site-initializer-acme`.

    Anda kemudian memiliki dua folder yang berdampingan. Biarkan folder asli seperti apa adanya; hanya salinannya yang diubah:

    ```
    client-extensions/
    ├── liferay-forums-site-initializer/
    └── liferay-forums-site-initializer-acme/
        ├── build.gradle
        ├── client-extension.yaml    ← the only file you change
        └── site-initializer/
    ```

1. Di salinan tersebut, buka `client-extension.yaml`, dan ganti seluruh isinya dengan nama-nama untuk situs baru. Setiap nama di dalamnya harus unik untuk salinan tersebut: kedua key, aplikasi OAuth, dan kode referensi eksternal situs. Untuk situs bernama *Acme*:

    ```yaml
   {% include snippet.md file="client-extension.yaml" indent="   " %}
    ```

    {% include download.html file="client-extension.yaml" %}

    Liferay membentuk alamat situs dari `siteName`: situs ini tersedia di `/web/acme`.

1. Kecuali di Liferay PaaS, yang membangun proyek sendiri, bangun salinan tersebut dari folder hasil ekstraksi. Anda memerlukan Java 17 atau yang lebih baru:

    ```bash
    ./gradlew :client-extensions:liferay-forums-site-initializer-acme:build
    ```

    Zip-nya adalah `client-extensions/liferay-forums-site-initializer-acme/dist/liferay-forums-site-initializer-acme.zip`.

### Langkah 2: Deploy Satu Kali {#step-2-deploy-it-once}

- **Liferay Self-Hosted (Tomcat atau Docker):** deploy setiap zip seperti pada [Satu Situs](#one-site), lalu hapus zip tersebut setelah situsnya ada.
- **Liferay PaaS:** push, lalu deploy build-nya. Restart layanan `liferayforumsetcspringboot`, dan periksa situsnya. Kemudian hapus folder salinan tersebut dari repositori Anda, push, deploy build tersebut, dan restart layanan itu lagi. Jika tidak, job-nya akan berjalan lagi pada setiap deploy, dan mereset alamat situs. Lihat [Deploy Berikutnya](paas.html#later-deploys).
- **Liferay SaaS:** deploy zip tersebut, dan jangan pernah men-deploy-nya lagi: job-nya akan mereset alamat situs.

    ```bash
    lcp deploy -p <project>-<environment> --extension client-extensions/liferay-forums-site-initializer-acme/dist/liferay-forums-site-initializer-acme.zip
    ```

Lalu periksa setiap situs baru di alamatnya, dan kirim balasan di sana.

### Jalan Pintas di Liferay Self-Hosted {#a-shortcut-on-liferay-self-hosted}

Di Liferay Self-Hosted (Tomcat atau Docker), skrip `generate-site-initializer-zips.sh`, yang dilampirkan pada [rilis terbaru](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest), membuat salinan-salinan dari `liferay-forums-site-initializer.zip` tanpa perlu membangunnya. Skrip ini berjalan di Linux, dengan Bash, `unzip`, dan `zip`. Jangan gunakan zip yang dihasilkannya di Liferay PaaS atau SaaS: semuanya berbagi satu aplikasi OAuth, yang hanya berfungsi jika di-deploy langsung ke Liferay.

1. Letakkan skrip di sebuah folder bersama `liferay-forums-site-initializer.zip`.

1. Edit daftar `SITES` di dekat bagian atas skrip. Setiap entri memetakan kode referensi eksternal situs ke namanya:

    ```bash
    declare -A SITES=(
    	[LIFERAY_ACME]="Acme, Inc. site"
    	[LIFERAY_NORTHWIND]="Northwind site"
    )
    ```

1. Jalankan skrip. Skrip menulis satu zip per situs ke folder `out`. Untuk melihat opsinya, jalankan dengan `--help`:

    ```bash
    bash generate-site-initializer-zips.sh
    ```

1. Deploy zip yang dihasilkan seperti pada [Satu Situs](#one-site), lalu hapus zip tersebut setelah situsnya ada.

Situs bernama *Acme, Inc. site* tersedia di `/web/acme-inc.-site`. Untuk menggunakan alamat lain, pilih nama yang berbeda, atau ubah friendly URL situs di *Site Settings* setelah situs dibuat.

## Informasi Terkait {#related-information}

- [Memeriksa Instalasi](checking.html)
- [Menjalankan Beberapa Situs Forum](../administering/several-sites.html)
