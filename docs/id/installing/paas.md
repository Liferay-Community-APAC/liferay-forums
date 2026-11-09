---
title: Di Liferay PaaS
parent: Instalasi
nav_order: 3
---

# Instalasi di Liferay PaaS {#installing-on-liferay-paas}
{: .no_toc }

Di Liferay PaaS, Anda menambahkan tiga proyek forum ke repositori proyek PaaS Anda, lalu men-deploy-nya bersama bagian proyek lainnya. Masing-masing berjalan sebagai layanan PaaS tersendiri: batch dan situs forum sebagai job, dan microservice sebagai layanan yang terus berjalan.

{: .warning }
Langkah-langkah ini telah diuji pada Liferay DXP 2026.Q1.4 LTS yang bersih dengan perbaikan yang diperlukan, di salinan lokal dari cara Liferay PaaS menjalankan client extension, tetapi belum di lingkungan Liferay PaaS. Client extension adalah fitur beta di Liferay PaaS.

1. TOC
{:toc}

## Langkah 1: Siapkan Proyek {#step-1-prepare-the-project}

Ikuti panduan Liferay [Configuring Liferay PaaS for Client Extensions](https://learn.liferay.com/w/dxp/cloud/customizing-liferay-dxp-in-the-cloud/configuring-liferay-paas-for-client-extensions). Khususnya:

1. Jika lingkungan `infra` Anda tidak memiliki pipeline build client extension, minta Liferay Cloud Support untuk mengaktifkannya.

1. Jika suatu lingkungan menggunakan autentikasi dasar (basic authentication) di web server-nya, izinkan path `/o` lewat tanpa autentikasi tersebut. Liferay dan microservice saling memanggil di bawah `/o`.

1. Hapus `virtual.hosts.valid.hosts` dan `web.server.protocol` dari pengaturan layanan Liferay, jika diatur. Client extension tidak berfungsi dengan pengaturan tersebut.

## Langkah 2: Instal Perbaikan Liferay {#step-2-install-the-liferay-fixes}

Instal hotfix dengan [perbaikan Liferay yang diperlukan](./#required-liferay-fixes) sebelum Anda menambahkan proyek-proyek forum.

1. Tambahkan hotfix ke proyek Anda dengan salah satu cara berikut:

    - **Untuk setiap lingkungan:** di `ci/LCP.json`, atur variabel lingkungan `LCP_CI_LIFERAY_DXP_HOTFIXES_COMMON` ke nama hotfix tanpa `.zip`:

        ```json
        "env": {
          "LCP_CI_LIFERAY_DXP_HOTFIXES_COMMON": "<hotfix-name>"
        }
        ```

    - **Untuk satu lingkungan:** gunakan `LCP_CI_LIFERAY_DXP_HOTFIXES_<ENVIRONMENT>` sebagai gantinya, misalnya `LCP_CI_LIFERAY_DXP_HOTFIXES_PRD`.
    - **Di repositori:** letakkan zip hotfix di `liferay/configs/<environment>/patching/`, misalnya `liferay/configs/prd/patching/`, satu kali untuk setiap lingkungan.

1. Push perubahan tersebut, lalu deploy build-nya ke lingkungan Anda, seperti pada [Langkah 4](#step-4-deploy-the-first-build).

1. Setelah layanan Liferay di-restart, pastikan log-nya menampilkan `The following patches are installed:` dengan hotfix tersebut.

Lihat panduan Liferay [Deploying to the Liferay Service](https://learn.liferay.com/w/dxp/cloud/customizing-liferay-dxp-in-the-cloud/using-the-liferay-dxp-service/deploying-to-the-liferay-service) untuk informasi lebih lanjut tentang menginstal hotfix.

## Langkah 3: Tambahkan Proyek-Proyek Forum {#step-3-add-the-forums-projects}

1. Dari [rilis terbaru](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest), unduh kode sumber forum, `liferay-forums-<version>-source.zip`, lalu ekstrak. Hasil ekstraksinya adalah folder bernama `liferay-forums-<version>`, seperti `liferay-forums-1.0.0`.

1. Salin tiga folder berikut ke `liferay/client-extensions` di repositori proyek PaaS Anda:

    - `client-extensions/liferay-forums-batch`
    - `client-extensions/liferay-forums-etc-spring-boot`
    - `client-extensions/liferay-forums-site-initializer`

## Langkah 4: Deploy Build Pertama {#step-4-deploy-the-first-build}

1. Push proyek tersebut. Liferay Cloud akan membangunnya; build client extension adalah build **Custom Services**.

1. Di konsol Liferay Cloud, buka **Builds**, lalu pada build tersebut, pilih **Deploy Build to...**, lalu lingkungan Anda.

Setelah deploy selesai, job-job telah membuat data forum dan situs forum di `/web/forums`, dan microservice telah dimulai. Pastikan bahwa:

- Log layanan Liferay menampilkan lima baris yang berisi `Finished batch engine import task`, satu untuk setiap file batch.
- *Control Panel* → *Objects* menampilkan folder **C2M0 Forums**, dengan tujuh object: C2M0 Attachment, C2M0 Message, C2M0 Subscription, C2M0 Suspicious Activity, C2M0 Thread, C2M0 User, dan C2M0 Vote.
- *Control Panel* → *Security* → *OAuth 2 Administration* menampilkan empat aplikasi forum: masing-masing satu untuk batch dan site initializer, serta dua untuk microservice, **Liferay Forums Etc Spring Boot OAuth Application Headless Server** dan **User Agent**.

Pada tahap ini, setiap balasan ditolak dengan pesan **Your account has been banned from participating in the forums.** Hal ini memang diharapkan: Liferay mendaftarkan microservice sebelum data forum ada, sehingga microservice belum memiliki akses ke data tersebut. Dua langkah berikutnya memperbaikinya.

## Langkah 5: Deploy Build Kedua {#step-5-deploy-a-second-build}

Job-job forum berjalan lagi pada setiap deploy, padahal seharusnya tidak, karena data dan situs forum kini sudah ada:

- Mulai dari deploy kedua, job batch akan melaporkan item yang gagal untuk dua template email forum, karena template tersebut sudah ada.
- Setiap kali job site initializer berjalan lagi, alamat situs forum direset ke `/web/group-<number>`, yang merusak tautan forum. LPD-85594 tidak mencegah hal ini di Liferay PaaS.

Oleh karena itu, build kedua tidak menyertakan file template email dan site initializer:

1. Hapus file dan folder berikut dari repositori Anda:

    ```
    liferay/client-extensions/liferay-forums-batch/batch/05-notification-email-template.batch-engine-data.json
    liferay/client-extensions/liferay-forums-site-initializer
    ```

1. Push, lalu deploy build baru tersebut ke lingkungan Anda, seperti pada Langkah 4.

Liferay mendaftarkan microservice lagi, kali ini dengan akses ke data forum, dan memberikan kredensial baru kepadanya. Job batch berhasil, pada deploy ini dan setiap deploy berikutnya, dan template email, beserta perubahan yang Anda buat padanya, tetap seperti apa adanya. Situs forum tetap berada di `/web/forums`, dengan halaman dan kontennya: menghapus site initializer tidak menghapus situsnya.

## Langkah 6: Restart Microservice {#step-6-restart-the-microservice}

Di konsol Liferay Cloud, restart layanan `liferayforumsetcspringboot`, agar layanan tersebut menggunakan kredensial baru. Balasan kini diterima.

{: .note }
Jika balasan masih ditolak setelah restart, Liferay mungkin tidak dapat menjangkau microservice di `localhost:58081`. Di `liferay/client-extensions/liferay-forums-etc-spring-boot/client-extension.yaml`, ubah kedua baris `.serviceAddress: localhost:58081` menjadi `liferayforumsetcspringboot:58081`, yaitu alamat layanan microservice, lalu deploy lagi. Hal ini belum diverifikasi di Liferay PaaS.

## Langkah 7: Siapkan Notifikasi Email {#step-7-set-up-email-notifications}

Batch membuat dua template email dengan alamat pengirim placeholder. Atur alamat yang sebenarnya, lalu restart layanan `liferayforumsetcspringboot`, sebelum anggota menerima email. Lihat [Notifikasi Email](../administering/email-notifications.html).

## Langkah 8: Periksa Instalasi {#step-8-check-the-installation}

Lanjutkan dengan [Memeriksa Instalasi](checking.html), untuk situs forum di `/web/forums`.

## Menambahkan Situs Forum Lain {#adding-more-forum-sites}

Setiap situs forum mendapatkan proyek site initializer tersendiri di repositori Anda, yang di-deploy satu kali, lalu dihapus lagi, seperti pada situs pertama. Lihat [Beberapa Situs](creating-sites.html#several-sites).

## Deploy Berikutnya {#later-deploys}

Liferay memberikan kredensial baru kepada microservice pada setiap deploy proyek Anda, bahkan deploy yang tidak mengubah forum. Sampai microservice di-restart dengan kredensial tersebut, balasan ditolak dengan pesan **Your account has been banned from participating in the forums.** Setelah setiap deploy, restart layanan `liferayforumsetcspringboot`, seperti pada [Langkah 6](#step-6-restart-the-microservice), dan pastikan balasan diterima.

## Informasi Terkait {#related-information}

- [Di Liferay SaaS](saas.html)
- [Instalasi](./)
