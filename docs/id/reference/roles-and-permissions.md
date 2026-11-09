---
title: Role dan Izin
parent: Referensi
nav_order: 1
---

# Role dan Izin {#roles-and-permissions}

Site initializer membuat tiga role dan mengatur izin forum. Tetapkan role di *Control Panel* → *Users* → *Roles*, atau, untuk **Forum Banned**, melalui [moderasi](../moderating/banning.html).

| Role | Jenis | Tujuan |
| --- | --- | --- |
| **Forum Moderator** | Regular | Memoderasi topik dan laporan, serta melarang (ban) anggota |
| **Forum Category Admin** | Regular | Mengelola kategori forum |
| **Forum Banned** | Site | Mencegah anggota mengirim postingan di situs tersebut |

{: .important }
**Forum Moderator** dan **Forum Category Admin** adalah regular role, sehingga berlaku untuk seluruh instance Liferay, bukan untuk satu situs. Forum Moderator memoderasi setiap situs forum, dan Forum Category Admin dapat menambahkan, mengubah, dan menghapus kategori di setiap situs, tidak hanya situs forum. Hanya ban yang berlaku untuk satu situs. Berikan kedua role ini hanya kepada orang yang Anda percayai untuk setiap situs forum.

## Apa yang Dapat Dilakukan Setiap Kelompok {#what-each-group-can-do}

| Tindakan | Tamu | Anggota yang sudah masuk | Forum Moderator | Forum Category Admin |
| --- | :---: | :---: | :---: | :---: |
| Membaca topik dan mencari | | ✓ | ✓ | ✓ |
| Memulai topik, membalas, memberi suara, melampirkan file | | ✓ | ✓ | ✓ |
| Mengikuti topik dan menerima notifikasi | | ✓ | ✓ | ✓ |
| Melaporkan topik | | ✓ | ✓ | ✓ |
| Mengedit atau menghapus topik atau balasan apa pun | | | ✓ | |
| Mengatur prioritas topik | | | ✓ | |
| Mengunci dan membuka kunci topik | | | ✓ | |
| Menandai jawaban pada pertanyaan apa pun | | | ✓ | |
| Meninjau laporan, memblokir dan membuka blokir anggota | | | ✓ | |
| Membuat, mengedit, dan menghapus kategori | | | | ✓ |

Hanya anggota yang sudah masuk yang dapat membaca forum. Pengunjung yang belum masuk melihat halaman-halaman forum, tetapi tidak ada topik, dan alamat topik menampilkan halaman not found. Untuk membuka forum bagi mereka, lihat [Mengizinkan Tamu Membaca Forum](#let-guests-read-the-forum).

Anggota dapat mengedit dan menghapus topik serta balasan mereka sendiri. Di versi 1.0.0, penulis pertanyaan belum dapat menandai jawabannya; lihat [Masalah yang Diketahui](known-issues.html). Role **Administrator** milik Liferay dapat melakukan semuanya.

{: .note }
Anggota yang dilarang tetap memiliki izin untuk membaca, tetapi setiap topik atau balasan baru ditolak di situs tempat mereka dilarang.

## Mengizinkan Tamu Membaca Forum {#let-guests-read-the-forum}

Pengunjung yang belum masuk memiliki role **Guest** milik Liferay. Untuk mengizinkan mereka membaca topik, balasan, dan kategori, serta mencari, berikan izin view kepada role **Guest** dan izinkan role tersebut memanggil dua API kategori yang digunakan halaman-halaman forum. Tamu tetap tidak dapat memulai topik, membalas, memberi suara, mengikuti topik, atau melaporkan konten.

{: .important }
Izin ini berlaku untuk setiap situs forum di instance Liferay, dan untuk API forum serta halamannya: siapa pun kemudian dapat membaca setiap topik dan balasan melalui `/o/c/c2m0threads` dan `/o/c/c2m0messages`.

### Memberikan Izin {#grant-the-permissions}

1. Buka *Control Panel* → *Users* → *Roles*, klik **Guest**, lalu buka tab **Define Permissions**.

1. Cari `C2M0`. Di bawah *Objects*, buka masing-masing item berikut, pilih **View** di izin entri-nya (misalnya, **C2M0 Thread** → **View**), lalu klik **Save**:

    - **C2M0 Thread**
    - **C2M0 Message**
    - **C2M0 Vote**
    - **C2M0 User**
    - **C2M0 Attachment**

    Biarkan **C2M0 Subscription** dan **C2M0 Suspicious Activity** apa adanya.

1. Cari `Categories`, lalu buka *Site and Asset Library Administration* → *Categorization* → **Categories**. Di bawah *Resource Permissions*, pilih **View** untuk **Category Vocabulary** dan untuk **Category**, lalu klik **Save**.

1. Buka *Control Panel* → *Security* → *Service Access Policy*, lalu klik **FORUM_GUEST_ACCESS**. Di bawah **Allowed Service Signatures**, klik **Switch to Advanced Mode**, tambahkan dua baris berikut di bawah baris yang sudah ada, lalu klik **Save**:

    ```
    com.liferay.headless.admin.taxonomy.internal.resource.v1_0.BaseTaxonomyCategoryResourceImpl#getTaxonomyVocabularyTaxonomyCategoriesPage
    com.liferay.headless.admin.taxonomy.internal.resource.v1_0.BaseTaxonomyVocabularyResourceImpl#getSiteTaxonomyVocabulariesPage
    ```

    Tanpa kedua baris ini, tamu dapat membaca topik, tetapi daftar diskusi tidak menampilkan kategori di breadcrumb dan menu **All Categories**-nya.

Keluar (sign out) dan buka forum untuk memeriksa: halaman beranda, daftar diskusi, halaman topik, dan hasil pencarian sekarang menampilkan topik.

### Membatalkannya {#undo-it}

1. Di tab **Define Permissions** milik role **Guest**, buka *Summary*, lalu klik **Remove** di samping setiap izin yang Anda tambahkan: kelima izin view **C2M0**, serta izin view **Category Vocabulary** dan **Category**.

1. Di **FORUM_GUEST_ACCESS**, hapus dua baris yang Anda tambahkan dari **Allowed Service Signatures**, lalu klik **Save**. Pertahankan dua baris `ObjectEntryResourceImpl` yang sudah ada sebelumnya.

Pengunjung yang belum masuk kemudian tidak dapat lagi membaca topik.

## Informasi Terkait {#related-information}

- [Moderasi](../moderating/)
- [Halaman](pages.html)
