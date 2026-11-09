---
title: Pengembangan dengan Liferay Workspace
parent: Instalasi
nav_order: 8
---

# Pengembangan dengan Liferay Workspace {#developing-with-a-liferay-workspace}
{: .no_toc }

Jika Anda membangun kode Liferay Anda sendiri dengan [Liferay Workspace](https://learn.liferay.com/w/dxp/liferay-development/tooling/liferay-workspace), Anda dapat menambahkan proyek-proyek forum ke dalamnya, membangunnya bersama kode Anda, dan men-deploy-nya ke bundle Liferay milik workspace itu sendiri untuk pengembangan.

Ini bukan cara terpisah untuk menginstal forum. Untuk menginstalnya di server, di Docker, atau di Liferay SaaS, bangun zip-zip di sini, lalu ikuti [Instalasi](./) dengan zip tersebut. Folder `liferay` dari proyek Liferay PaaS sudah merupakan workspace: ikuti [Di Liferay PaaS](paas.html).

{: .important }
Diuji dengan plugin Gradle Liferay Workspace 15.0.0 dan Liferay DXP 2026.Q1.4. Anda memerlukan [Blade](https://learn.liferay.com/w/dxp/liferay-development/tooling/blade-cli), atau jalankan `./gradlew` milik workspace sebagai pengganti `blade gw`.

1. TOC
{:toc}

## Langkah 1: Tambahkan Proyek-Proyek Forum {#step-1-add-the-forums-projects}

1. Dari [rilis terbaru](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest), unduh kode sumber forum, `liferay-forums-<version>-source.zip`, lalu ekstrak. Hasil ekstraksinya adalah folder bernama `liferay-forums-<version>`, seperti `liferay-forums-1.0.0`.

1. Salin tiga folder berikut ke folder `client-extensions` di workspace Anda:

    - `client-extensions/liferay-forums-batch`
    - `client-extensions/liferay-forums-etc-spring-boot`
    - `client-extensions/liferay-forums-site-initializer`

Workspace mengenalinya sebagai proyek client extension, di samping proyek Anda sendiri, tanpa perubahan lain.

## Langkah 2: Bangun Proyek-Proyek Tersebut {#step-2-build-them}

Dari folder root workspace:

```bash
blade gw build
```

Setiap zip ditulis ke folder `dist` proyeknya, misalnya `client-extensions/liferay-forums-batch/dist/liferay-forums-batch.zip`. Zip-zip ini sama dengan zip dalam rilis.

## Langkah 3: Deploy ke Bundle Workspace {#step-3-deploy-them-to-the-workspaces-bundle}

Langkah ini untuk bundle Liferay milik workspace, yang disiapkan dengan `blade server init`. Mulai bundle tersebut, dan tunggu hingga selesai dimulai. Task `deploy` setiap proyek hanya menyalin zip miliknya sendiri ke bundle, secara default di `bundles/osgi/client-extensions`.

{: .warning }
**Jangan pernah menginstal dengan `blade gw deploy`.** Deploy untuk seluruh workspace men-deploy semua proyek sekaligus, sehingga zip microservice dapat tiba sebelum batch selesai, dan setiap postingan kemudian ditolak.

Jika Anda meletakkan proyek-proyek tersebut di subfolder, seperti `client-extensions/forums`, path task mengikutinya: `:client-extensions:forums:liferay-forums-batch:deploy`.

1. **Batch.** Lalu tunggu hingga log Liferay menampilkan lima baris yang berisi `Finished batch engine import task`:

    ```bash
    blade gw :client-extensions:liferay-forums-batch:deploy
    ```

1. **Zip microservice:**

    ```bash
    blade gw :client-extensions:liferay-forums-etc-spring-boot:deploy
    ```

1. **Mulai microservice,** seperti pada [Langkah 4 dari Liferay Self-Hosted (Tomcat)](tomcat.html#step-4-start-the-microservice): ekstrak `client-extensions/liferay-forums-etc-spring-boot/dist/liferay-forums-etc-spring-boot.zip` ke sebuah folder, lalu mulai dengan `LIFERAY_HOME` diatur ke path lengkap bundle. Gunakan path lengkap: `start.sh` berjalan dari foldernya sendiri.

    ```bash
    LIFERAY_HOME=/home/me/my-workspace/bundles ./start.sh
    ```

1. **Siapkan notifikasi email,** seperti dalam [Notifikasi Email](../administering/email-notifications.html), lalu restart microservice.

1. **Situs forum.** Setelah situs ada, hapus `liferay-forums-site-initializer.zip` dari `bundles/osgi/client-extensions`.

    ```bash
    blade gw :client-extensions:liferay-forums-site-initializer:deploy
    ```

Untuk situs forum lainnya, tambahkan salinan proyek site initializer per situs, seperti dalam [Beberapa Situs](creating-sites.html#several-sites), lalu deploy masing-masing dengan task `deploy`-nya sendiri.

## Langkah 4: Periksa Instalasi {#step-4-check-the-installation}

Lanjutkan dengan [Memeriksa Instalasi](checking.html).

## Hal yang Harus Dihindari {#things-to-avoid}

- **Deploy untuk seluruh workspace di kemudian hari** melewati proyek yang tidak berubah, sehingga `blade gw deploy` untuk kode Anda sendiri tidak men-deploy forum lagi. Setelah `blade gw clean`, atau perubahan pada proyek forum, perintah tersebut men-deploy zip forum lagi, semuanya sekaligus. Kemudian restart microservice, yang mendapatkan kredensial baru, dan lihat [Men-deploy Batch Lagi](../reference/known-issues.html#deploying-the-batch-again).
- **Task Docker milik workspace,** seperti `buildDockerImage` dan `startDockerContainer`, memasukkan setiap proyek ke dalam image Liferay, dan Liferay men-deploy-nya saat dimulai, yang terlalu awal bagi microservice dan site initializer. Untuk Docker, bangun zip-zip di sini, lalu ikuti [Liferay Self-Hosted (Docker)](docker.html).

## Informasi Terkait {#related-information}

- [Liferay Self-Hosted (Tomcat)](tomcat.html)
- [Membuat Situs Forum](creating-sites.html)
