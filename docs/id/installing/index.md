---
title: Instalasi
nav_order: 3
has_children: true
permalink: /id/installing/
---

# Instalasi {#installing}
{: .no_toc }

Halaman-halaman ini memandu Anda menginstal Liferay Forums 1.0.0, mulai dari Liferay yang masih kosong hingga situs forum yang berfungsi. Sediakan waktu sekitar satu jam untuk pertama kalinya, sebagian besar untuk menunggu Liferay selesai dimulai.

1. TOC
{:toc}

## Sebelum Memulai {#before-you-begin}

Pastikan Anda memiliki:

- **Liferay DXP 2026.Q1 LTS**, di server dari bundle Tomcat, di Docker, di Liferay PaaS, atau di Liferay SaaS, dengan [perbaikan Liferay](#required-liferay-fixes) di bawah ini sudah terinstal, atau dengan solusi sementaranya (workaround).
- **Database yang didukung Liferay**, seperti PostgreSQL. Forum tidak berfungsi di Hypersonic, database demo yang digunakan Liferay saat dimulai jika belum ada database yang disiapkan.
- **Java 17 atau yang lebih baru** di mesin tempat microservice forum berjalan, di Liferay Self-Hosted (Tomcat), dan untuk membangun site initializer bagi [beberapa situs forum](creating-sites.html#several-sites).

### Perbaikan Liferay yang Diperlukan {#required-liferay-fixes}

Mintalah hotfix untuk rilis 2026.Q1 Anda yang mencakup perbaikan yang diperlukan kepada Liferay Support, lalu instal hotfix tersebut sebelum forum. Di Liferay SaaS, Liferay menginstal hotfix untuk seluruh cluster, bukan untuk satu lingkungan, jadi gunakan solusi sementara untuk setiap perbaikan yang tidak tercakup dalam rilis lingkungan Anda; lihat [Di Liferay SaaS](saas.html#step-1-check-the-liferay-version-and-fixes).

| Perbaikan | Tanpa Perbaikan Ini | Diperlukan |
| --- | --- | --- |
| LPD-90465 (di 2026.Q1.4, backport-nya LPD-112124) | Pemblokiran (ban) tidak berlaku, dan moderator tidak melihat **Lock Topic**. | Ya |
| LPD-85594 | Setiap kali zip site initializer di-deploy lagi pada situs yang sudah ada, alamat situs direset, dan tautan forum menampilkan halaman tidak ditemukan. Perbaikan ini tidak mencakup Liferay PaaS dan SaaS, tempat langkah instalasi menghindari menjalankan site initializer lagi. | Ya, sampai 2026.Q1.12, yang sudah mencakupnya |
| LPD-102310 | Liferay mencatat error `Invalid asset category` saat sebuah topik diperbarui. Tidak ada hal lain yang terpengaruh. | Tidak, tetapi disarankan |

Liferay Forums 1.0.0 telah diuji di 2026.Q1.1 dan 2026.Q1.4.

#### Tanpa Hotfix {#without-a-hotfix}

- **Sebagai pengganti LPD-90465:** setelah situs forum pertama dibuat, berikan kode referensi eksternal pada role **Forum Banned** secara manual, seperti dijelaskan di [Pemblokiran Tidak Berlaku](checking.html#bans-have-no-effect-or-moderators-dont-see-lock-topic).
- **Sebagai pengganti LPD-85594:** setelah setiap deployment zip site initializer pada situs yang sudah ada, periksa friendly URL situs di *Site Settings*, dan kembalikan jika berubah.

## Yang Akan Anda Instal {#what-youll-install}

Setiap [rilis](https://github.com/Liferay-Community-APAC/liferay-forums/releases) berisi file-file berikut:

| File | Keterangan |
| --- | --- |
| `liferay-forums-batch.zip` | Data forum: topik, balasan, vote, laporan, dan follow, beserta template notifikasi dan pengaturan pencariannya. |
| `liferay-forums-etc-spring-boot.zip` | **Microservice** forum, program kecil yang berjalan di samping Liferay. Microservice ini memeriksa setiap postingan terhadap blokir dan topik yang dikunci, serta mengirim notifikasi. Liferay memerlukan zip-nya, sedangkan microservice itu sendiri berjalan sebagai proses atau container tersendiri. |
| `liferay-forums-site-initializer.zip` | Situs forum itu sendiri: halaman, role, dan izinnya. Men-deploy-nya akan membuat satu situs forum. |
| `generate-site-initializer-zips.sh` | Di Liferay Self-Hosted, membuat satu salinan zip site initializer per situs, untuk menjalankan beberapa situs forum. |
| [`liferay-forums-<version>-source.zip`](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest){: data-release-asset="-source.zip"} | Kode sumber ketiga zip tersebut, sebagai Liferay Workspace. Anda memerlukannya di Liferay PaaS, untuk membangun site initializer bagi setiap situs forum tambahan, atau untuk menambahkan forum ke Liferay Workspace Anda sendiri. |
| `SHA256SUMS` | Checksum file-file di atas. |

## Pilih Tempat Liferay Berjalan {#choose-where-liferay-runs}

<div class="doc-cards">
  <a class="card doc" href="tomcat.html"><strong>Liferay Self-Hosted (Tomcat)</strong><span>Liferay yang diinstal dari bundle Tomcat. Microservice berjalan di mesin yang sama atau di mesin lain.</span></a>
  <a class="card doc" href="docker.html"><strong>Liferay Self-Hosted (Docker)</strong><span>Liferay dan PostgreSQL di dalam container, dan microservice di container di samping container Liferay.</span></a>
  <a class="card doc" href="paas.html"><strong>Di Liferay PaaS</strong><span>Proyek-proyek forum di repositori proyek PaaS Anda, di-deploy bersama bagian proyek lainnya.</span></a>
  <a class="card doc" href="saas.html"><strong>Di Liferay SaaS</strong><span>Zip forum di-deploy satu per satu dengan command line tool Liferay Cloud.</span></a>
</div>

Di Liferay Self-Hosted, selanjutnya ikuti [Membuat Situs Forum](creating-sites.html), lalu [Memeriksa Instalasi](checking.html). Di Liferay PaaS dan Liferay SaaS, situs forum dibuat selama instalasi. [Membuat Situs Forum](creating-sites.html#several-sites) membahas penambahan situs forum untuk setiap jenis instalasi.

Jika Anda membangun kode Liferay Anda sendiri dengan Liferay Workspace, lihat [Pengembangan dengan Liferay Workspace](workspace.html) untuk menambahkan proyek-proyek forum ke dalamnya.

## Mengapa Urutan Itu Penting {#why-the-order-matters}

Forum diinstal dengan urutan yang tetap: batch, lalu microservice, lalu situs. Setiap langkah memerlukan langkah sebelumnya.

- **Batch harus pertama.** Saat zip microservice di-deploy, Liferay memberikan akses ke data forum kepada microservice, tetapi hanya ke bagian yang sudah ada. Jika di-deploy sebelum batch selesai, microservice tidak mendapatkan akses, dan setiap postingan ditolak.
- **Situs harus terakhir, setelah Liferay selesai dimulai sepenuhnya.** Situs forum yang dibuat saat Liferay masih dalam proses dimulai tidak memiliki halaman topik. Hal itu terjadi jika zip site initializer disalin saat Liferay dihentikan, jadi selalu deploy zip tersebut ke Liferay yang sedang berjalan.

## Informasi Terkait {#related-information}

- [Memulai](../getting-started.html)
- [Menghapus Situs Forum](deleting.html)
