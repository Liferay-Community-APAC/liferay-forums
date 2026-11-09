---
title: Di Liferay SaaS
parent: Instalasi
nav_order: 3.5
---

# Instalasi di Liferay SaaS {#installing-on-liferay-saas}
{: .no_toc }

Di Liferay SaaS, Anda men-deploy tiga zip forum dengan command line tool Liferay Cloud, satu per satu, sesuai urutan. Liferay Cloud menjalankan batch dan situs forum sebagai job, dan microservice sebagai layanan yang terus berjalan.

{: .warning }
Langkah-langkah ini telah diuji pada Liferay DXP 2026.Q1.4 LTS yang bersih dengan perbaikan yang diperlukan, di salinan lokal dari cara Liferay Cloud menjalankan client extension, tetapi belum di lingkungan Liferay SaaS.

1. TOC
{:toc}

## Langkah 1: Periksa Versi dan Perbaikan Liferay {#step-1-check-the-liferay-version-and-fixes}

Di Liferay SaaS, Liferay mengelola versi Liferay dan hotfix-nya, untuk semua lingkungan di cluster yang sama sekaligus: hotfix tidak dapat diinstal hanya untuk lingkungan Anda. Jadi, Anda bekerja dengan rilis yang dijalankan lingkungan Anda:

1. Tanyakan kepada Liferay Support rilis dan hotfix mana yang dijalankan lingkungan Anda, dan pastikan rilis tersebut adalah rilis 2026.Q1 LTS.

1. Bandingkan dengan [perbaikan Liferay yang diperlukan](./#required-liferay-fixes). Untuk setiap perbaikan yang tidak tercakup, gunakan [solusi sementara](./#without-a-hotfix) setelah instalasi. LPD-85594 tidak berpengaruh di Liferay SaaS: langkah-langkah di bawah ini tidak pernah menjalankan site initializer dua kali.

## Langkah 2: Bersiap untuk Deploy {#step-2-get-ready-to-deploy}

1. Instal [command line tool](https://learn.liferay.com/w/dxp/cloud/reference/command-line-tool) Liferay Cloud, lalu masuk dengan `lcp login`.

1. Temukan ID lingkungan ekstensi yang menjadi tujuan deploy, dalam format `<project>-<environment>`. Konsol Liferay Cloud menampilkannya.

1. Dari [rilis terbaru](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest), unduh:

    - [`liferay-forums-batch.zip`](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest/download/liferay-forums-batch.zip)
    - [`liferay-forums-etc-spring-boot.zip`](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest/download/liferay-forums-etc-spring-boot.zip)
    - [`liferay-forums-site-initializer.zip`](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest/download/liferay-forums-site-initializer.zip)

## Langkah 3: Deploy Batch {#step-3-deploy-the-batch}

1. Deploy batch:

    ```bash
    lcp deploy -p <project>-<environment> --extension liferay-forums-batch.zip
    ```

1. Tunggu hingga job-nya selesai. Job selesai ketika *Applications* → *Notification Templates* menampilkan **C2M0 Notification Email Reply** dan **C2M0 Notification Email Mention**, yang dibuat batch paling akhir. *Control Panel* → *Objects* kemudian menampilkan folder **C2M0 Forums**, dengan tujuh object: C2M0 Attachment, C2M0 Message, C2M0 Subscription, C2M0 Suspicious Activity, C2M0 Thread, C2M0 User, dan C2M0 Vote.

{: .warning }
Jangan lanjutkan sebelum batch selesai. Microservice yang di-deploy pada langkah berikutnya hanya mendapatkan akses ke bagian forum yang sudah ada pada saat itu. Jika di-deploy terlalu awal, microservice tidak mendapatkan akses, dan setiap postingan ditolak dengan pesan **Your account has been banned from participating in the forums.**

## Langkah 4: Deploy Microservice {#step-4-deploy-the-microservice}

```bash
lcp deploy -p <project>-<environment> --extension liferay-forums-etc-spring-boot.zip
```

Liferay mendaftarkan microservice, dan Liferay Cloud memulainya dengan kredensialnya. *Control Panel* → *Security* → *OAuth 2 Administration* kemudian menampilkan **Liferay Forums Etc Spring Boot OAuth Application Headless Server** dan **Liferay Forums Etc Spring Boot OAuth Application User Agent**.

## Langkah 5: Deploy Site Initializer {#step-5-deploy-the-site-initializer}

```bash
lcp deploy -p <project>-<environment> --extension liferay-forums-site-initializer.zip
```

Job-nya membuat situs forum di `/web/forums`.

## Langkah 6: Siapkan Notifikasi Email {#step-6-set-up-email-notifications}

Batch membuat dua template email dengan alamat pengirim placeholder. Atur alamat yang sebenarnya, lalu restart layanan microservice, `liferayforumsetcspringboot`, dari konsol Liferay Cloud, sebelum anggota menerima email. Lihat [Notifikasi Email](../administering/email-notifications.html).

## Langkah 7: Periksa Instalasi {#step-7-check-the-installation}

Lanjutkan dengan [Memeriksa Instalasi](checking.html), untuk situs forum di `/web/forums`.

Jika balasan ditolak, lihat [Postingan Ditolak](checking.html#posts-are-rejected).

## Batas Panggilan API {#api-call-limit}

Liferay SaaS membatasi panggilan API per pengguna dan per jam. Microservice memanggil Liferay untuk setiap postingan, sebagai satu pengguna, untuk semua situs forum sekaligus. Forum yang ramai, atau beberapa situs forum yang ramai, dapat mencapai batas tersebut, dan postingan kemudian ditolak hingga jam tersebut berakhir. Konfirmasikan batas yang berlaku saat ini kepada Liferay Support jika Anda memperkirakan penggunaan yang tinggi.

## Deploy Berikutnya {#later-deploys}

- **Jangan deploy batch lagi.** Setiap deploy menjalankan job-nya lagi, yang melaporkan item yang gagal untuk template email, karena template tersebut sudah ada. Data Anda dan perubahan Anda pada template tetap tersimpan, tetapi job ditampilkan sebagai gagal.
- **Jangan deploy site initializer lagi.** Job-nya akan berjalan lagi, dan mereset alamat situs forum ke `/web/group-<number>`, yang merusak tautan forum. LPD-85594 tidak mencegah hal ini di Liferay SaaS. Jika hal ini terjadi, kembalikan friendly URL di *Site Settings*.
- **Deploy microservice lagi** hanya untuk versi barunya, dan periksa balasan setelahnya.

## Menambahkan Situs Forum Lain {#adding-more-forum-sites}

Setiap situs forum mendapatkan zip site initializer tersendiri, yang dibangun dari kode sumber rilis dan di-deploy satu kali. Microservice tidak perlu di-restart. Lihat [Beberapa Situs](creating-sites.html#several-sites).

## Informasi Terkait {#related-information}

- [Di Liferay PaaS](paas.html)
- [Instalasi](./)
