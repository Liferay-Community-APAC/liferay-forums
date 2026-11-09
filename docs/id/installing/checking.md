---
title: Memeriksa Instalasi
parent: Instalasi
nav_order: 6
---

# Memeriksa Instalasi {#checking-the-installation}
{: .no_toc }

Empat pemeriksaan singkat memastikan bahwa forum berfungsi. Jika salah satunya gagal, perbaikan di bawah ini membahas penyebab yang umum.

1. TOC
{:toc}

## Pemeriksaan 1: Microservice {#check-1-the-microservice}

Di mesin Liferay, perintah ini mencetak `READY`:

```bash
curl http://localhost:58081/ready
```

Di Liferay Self-Hosted (Docker), jalankan `docker exec forums-liferay curl -s http://localhost:58081/ready`.

Di Liferay PaaS dan Liferay SaaS, periksa di konsol Liferay Cloud bahwa layanan `liferayforumsetcspringboot` sedang berjalan.

## Pemeriksaan 2: Role Forum Banned {#check-2-the-forum-banned-role}

Setelah masuk ke Liferay sebagai administrator, buka alamat berikut, dengan alamat Liferay Anda sebagai pengganti `<liferay-url>`. Alamat ini menampilkan role **Forum Banned**, bukan error tidak ditemukan, setelah situs forum pertama ada:

```
<liferay-url>/o/headless-admin-user/v1.0/roles/by-external-reference-code/FORUM_BANNED
```

Jika menampilkan tidak ditemukan, lihat [Pemblokiran Tidak Berlaku](#bans-have-no-effect-or-moderators-dont-see-lock-topic).

## Pemeriksaan 3: Posting {#check-3-post}

1. Sebagai administrator, selesaikan [penyiapan awal](../getting-started.html#first-time-setup). Setidaknya satu kategori harus ada sebelum siapa pun dapat memposting.
1. Masuk sebagai anggota, buka situs forum, misalnya `/web/forums`, dan mulai sebuah topik.
1. Balas topik tersebut.

## Pemeriksaan 4: Menerima Email {#check-4-get-an-email}

1. Sebagai satu anggota, ikuti sebuah topik.
1. Sebagai anggota lain, balas topik tersebut.
1. Pastikan anggota pertama menerima email, yang dikirim dari alamat yang Anda atur di [Notifikasi Email](../administering/email-notifications.html).

## Jika Ada Masalah {#if-somethings-wrong}

### Postingan Ditolak {#posts-are-rejected}

Anggota melihat pesan **Your account has been banned from participating in the forums.** atau error kunci, padahal mereka tidak diblokir dan topiknya tidak dikunci.

1. Pastikan microservice sedang berjalan, dan Liferay dapat menjangkaunya ([Pemeriksaan 1](#check-1-the-microservice)). Di Liferay Self-Hosted (Docker), restart container microservice setelah container Liferay di-restart.
1. Jika microservice berjalan, dan log-nya menampilkan error `403` dari Liferay, zip-nya di-deploy sebelum batch selesai, sehingga Liferay tidak memberikan akses ke data forum kepadanya. Men-deploy zip yang sama lagi tidak membantu; deploy ulang dari awal:
    1. Hapus `liferay-forums-etc-spring-boot.zip` dari folder `osgi/client-extensions` Liferay.
    1. Tunggu hingga log Liferay menampilkan bundle-nya `STOPPED`.
    1. Salin kembali zip tersebut.
    1. Restart microservice.
1. Di Liferay PaaS, deploy build kedua dan restart microservice, seperti dalam [Instalasi di Liferay PaaS](paas.html#step-5-deploy-a-second-build). Di Liferay SaaS, minta Liferay Support untuk menghapus client extension microservice, lalu deploy lagi.

### Tautan Topik Menampilkan Halaman Tidak Ditemukan {#topic-links-show-a-not-found-page}

Situs dibuat saat Liferay masih dalam proses dimulai, sehingga situs tersebut tidak memiliki halaman topik. Sebelum ada yang memposting di situs tersebut, hapus situs di *Control Panel* → *Sites*, lalu deploy lagi zip site initializer-nya ke Liferay yang sedang berjalan, seperti dalam [Membuat Situs Forum](creating-sites.html).

### Pemblokiran Tidak Berlaku, atau Moderator Tidak Melihat Lock Topic {#bans-have-no-effect-or-moderators-dont-see-lock-topic}

Role **Forum Banned** tidak memiliki kode referensi eksternal `FORUM_BANNED`, yang terjadi tanpa perbaikan Liferay LPD-90465. Atur secara manual, setelah masuk sebagai administrator, misalnya dengan API explorer Liferay di `<liferay-url>/o/api`:

1. Temukan ID role: `GET /o/headless-admin-user/v1.0/roles?search=Forum%20Banned`.
1. Atur kodenya: `PATCH /o/headless-admin-user/v1.0/roles/<role ID>` dengan body `{"externalReferenceCode": "FORUM_BANNED"}`.
1. Pastikan [Pemeriksaan 2](#check-2-the-forum-banned-role) kini menampilkan role tersebut.

### Email Tidak Diterima {#no-email-arrives}

Periksa alamat **From** pada template dan pengirim email Liferay di [Notifikasi Email](../administering/email-notifications.html), serta pastikan mail server Liferay sudah dikonfigurasi. Setelah mengubah template, restart microservice: microservice hanya membaca template saat dimulai.

## Informasi Terkait {#related-information}

- [Memulai](../getting-started.html)
- [Masalah yang Diketahui](../reference/known-issues.html)
