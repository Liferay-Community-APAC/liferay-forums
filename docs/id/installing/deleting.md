---
title: Menghapus Situs Forum
parent: Instalasi
nav_order: 7
---

# Menghapus Situs Forum {#deleting-a-forum-site}

Menghapus situs forum akan menghapus halaman-halamannya dan semua konten forumnya: topik, balasan, follow, vote, dan laporan. Situs forum lainnya tidak terpengaruh.

{: .warning }
Penghapusan situs tidak dapat dibatalkan. Cadangkan database Liferay terlebih dahulu jika Anda mungkin memerlukan kontennya.

1. Pastikan zip site initializer situs tersebut tidak ada di folder `osgi/client-extensions` Liferay; [Membuat Situs Forum](creating-sites.html) meminta Anda menghapusnya setelah situs ada. Jika di-deploy lagi di kemudian hari, zip tersebut akan membuat situs lagi, dalam keadaan kosong. Di Liferay PaaS, periksa hal yang sama untuk proyek site initializer-nya di `liferay/client-extensions`.

1. Di *Control Panel* → *Sites*, buka menu **Actions** situs tersebut, klik **Delete**, lalu konfirmasi.

Bagian-bagian forum yang digunakan bersama tetap ada, karena situs forum lain menggunakannya: model data dari batch, microservice, serta role **Forum Moderator**, **Forum Category Admin**, dan **Forum Banned**.

## Informasi Terkait {#related-information}

- [Menjalankan Beberapa Situs Forum](../administering/several-sites.html)
- [Instalasi](./)
