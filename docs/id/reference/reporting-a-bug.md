---
title: Melaporkan Bug
parent: Referensi
nav_order: 5
---

# Melaporkan Bug {#reporting-a-bug}
{: .no_toc }

Laporkan masalah pada Liferay Forums, dan sarankan perbaikan, sebagai issue di
[repositori liferay-forums di GitHub](https://github.com/Liferay-Community-APAC/liferay-forums/issues). Anda memerlukan
akun GitHub.

1. TOC
{:toc}

## Jika Anda Memiliki Paket TAM {#if-you-have-a-tam-package}

Jika langganan Liferay Anda mencakup paket Technical Account Manager (TAM), laporkan masalah langsung ke
Liferay Support alih-alih membuka issue di GitHub. Tiket menjaga log dan detail lingkungan Anda tetap privat, dan
TAM Anda dapat menindaklanjutinya.

1. Masuk ke [Liferay Help Center](https://support.liferay.com/) dengan akun liferay.com Anda.
1. Buat tiket, seperti yang dijelaskan dalam
   [Help Center Ticket Creation Process](https://learn.liferay.com/kb-article/help-center-ticket-creation-process).
1. Di tiket, sebutkan bahwa masalahnya ada di **Liferay Forums**, beserta versinya, dan sertakan detail yang sama seperti
   [laporan bug](#report-a-bug): versi Liferay DXP, jenis instalasi, langkah-langkah untuk mereproduksi, dan baris
   log.
1. Beri tahu TAM Anda tentang tiket tersebut.

## Sebelum Melapor {#before-you-report}

- Periksa [Masalah yang Diketahui](known-issues.html) untuk rilis Anda.
- Jika postingan ditolak, tautan topik menampilkan halaman not found, atau tidak ada email yang masuk, ikuti
  [Jika Ada yang Salah](../installing/checking.html#if-somethings-wrong).
- Cari masalah yang sama di [issue yang masih terbuka](https://github.com/Liferay-Community-APAC/liferay-forums/issues). Jika
  Anda menemukannya, tambahkan informasi yang Anda ketahui ke issue tersebut, atau beri 👍, alih-alih membuka issue baru.

## Melaporkan Bug {#report-a-bug}

1. Buka [New issue](https://github.com/Liferay-Community-APAC/liferay-forums/issues/new/choose), lalu pilih
   **Bug report**.
1. Isi formulir:
    - versi Liferay Forums dan versi Liferay DXP;
    - cara Anda menginstalnya: Liferay Self-Hosted (Tomcat atau Docker), Liferay PaaS, Liferay SaaS, atau Liferay Workspace;
    - apakah [perbaikan Liferay yang diperlukan](../installing/#required-liferay-fixes) sudah terinstal;
    - apa yang terjadi, apa yang Anda harapkan, dan langkah-langkah untuk mereproduksinya, beserta role anggota yang melakukan setiap
      langkah;
    - error dari log Liferay dan log microservice.
1. Klik **Create**.

{: .warning }
Issue bersifat publik. Sebelum Anda menempelkan log atau tangkapan layar, hapus alamat email, nama pengguna, hostname, alamat
internal, token, dan data pelanggan apa pun.

Untuk menyarankan perbaikan, pilih **Feature request**, lalu jelaskan apa yang ingin Anda lakukan.

## Masalah Keamanan {#security-problems}

Jangan laporkan masalah keamanan dalam issue publik. Laporkan secara privat, di tab **Security** repositori →
[**Report a vulnerability**](https://github.com/Liferay-Community-APAC/liferay-forums/security/advisories/new). Hanya
maintainer yang dapat melihatnya. Lihat
[kebijakan keamanan](https://github.com/Liferay-Community-APAC/liferay-forums/security/policy) repositori.

## Pertanyaan {#questions}

Untuk pertanyaan tentang instalasi, penyiapan, atau penggunaan forum, mulailah
[diskusi](https://github.com/Liferay-Community-APAC/liferay-forums/discussions) alih-alih issue.

## Apa yang Terjadi Selanjutnya {#what-happens-next}

Maintainer meninjau issue baru, dan meminta detail tambahan jika diperlukan. Bug yang terkonfirmasi direncanakan untuk suatu
rilis, biasanya patch berikutnya dari lini rilis terbaru, dan issue tersebut menyebutkan rilis mana. Saat rilis tersebut
dipublikasikan, issue ditutup dengan tautan ke rilis itu. Catatan rilisnya menjelaskan cara menginstalnya.

Liferay Forums adalah proyek komunitas, sehingga issue ditangani berdasarkan upaya terbaik (best effort).

## Informasi Terkait {#related-information}

- [Masalah yang Diketahui](known-issues.html)
- [Memeriksa Instalasi](../installing/checking.html)
