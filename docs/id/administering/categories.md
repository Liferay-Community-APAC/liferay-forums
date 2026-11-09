---
title: Mengelola Kategori
parent: Administrasi
nav_order: 1
---

# Mengelola Kategori {#managing-categories}
{: .no_toc }

Setiap topik termasuk dalam sebuah kategori. Situs forum baru belum memiliki kategori, jadi buatlah kategori sebelum anggota mulai mengirim postingan.

{: .important }
Mengelola kategori memerlukan role **Forum Category Admin**, atau role **Administrator** milik Liferay. Pengguna dengan role tersebut melihat **Forum Categories Admin** di navigasi forum.

1. TOC
{:toc}

![Halaman Forum Categories Admin dengan Seed Default Categories, formulir Add Custom Category, dan kategori yang sudah ada.](../../assets/images/categories-admin.png){: .screenshot }

## Menambahkan Kategori Bawaan {#adding-the-default-categories}

Klik **Seed Default Categories** untuk menambahkan empat kategori awal: **General Discussion**, **Technical Help**, **Feature Requests**, dan **Best Practices**. Edit atau hapus kategori tersebut sesuai keinginan Anda.

## Menambahkan Kategori {#adding-a-category}

1. Di bawah **Add Custom Category**, masukkan **Category Name** dan **Description** (opsional).

1. Untuk menjadikannya subkategori, pilih **Parent Category**-nya. Biarkan **None (Top Level)** untuk kategori tingkat atas.

1. Klik **Add**.

Kategori memiliki satu tingkat subkategori. Kategori yang memiliki subkategori tetap berada di tingkat atas.

## Mengedit atau Menghapus Kategori {#editing-or-deleting-a-category}

Gunakan tombol **Edit** (pensil) dan **Delete** (tempat sampah) di samping kategori.

{: .warning }
Menghapus kategori juga menghapus subkategorinya. Topik-topiknya tidak dihapus: topik tersebut kehilangan kategorinya dan tetap tercantum di bawah **All Discussions**. Tindakan ini tidak dapat dibatalkan.

{: .note }
Kategori adalah kategori Liferay dalam vocabulary **Forum Categories** milik situs, sehingga Anda juga dapat mengelolanya di *Site Menu* → *Categorization* → *Categories*.

## Informasi Terkait {#related-information}

- [Menjelajah dan Mencari](../using/browsing-and-searching.html)
- [Referensi Konfigurasi](../reference/configuration.html)
