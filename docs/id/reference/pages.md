---
title: Halaman
parent: Referensi
nav_order: 2
---

# Halaman {#pages}

Site initializer membuat halaman-halaman berikut. Alamat bersifat relatif terhadap situs, misalnya `/web/forums`.

| Halaman | Alamat | Yang Ditampilkan | Siapa yang Dapat Melihatnya |
| --- | --- | --- | --- |
| **Forums** | `/forums` | Halaman beranda: statistik, pencarian, diskusi yang dipromosikan, kategori | Semua orang |
| **Forums Messages** | `/forums-messages` | Daftar diskusi, difilter menurut kategori atau tag | Semua orang |
| **New Discussion** | `/new-discussion` | Formulir untuk memulai topik | Anggota yang sudah masuk |
| **Search** | `/search` | Hasil pencarian dengan facet | Semua orang |
| **Forums Moderation** | `/forums-moderation` | Antrean moderasi | Forum Moderator |
| **Forum Categories Admin** | `/forum-categories-admin` | Pengelolaan kategori | Forum Category Admin |
| **Liferay Learn**, **Help Center** | | Tautan ke dokumentasi dan help center Liferay | Semua orang |

Setiap topik memiliki halamannya sendiri di `/c_c2m0thread/<topic-title>`, yang dibangun dari display page template **Forum Thread**.

Halaman yang terbuka untuk semua orang hanya menampilkan topik kepada anggota yang sudah masuk, kecuali administrator [mengizinkan tamu membaca forum](roles-and-permissions.html#let-guests-read-the-forum).

## Informasi Terkait {#related-information}

- [Role dan Izin](roles-and-permissions.html)
- [Menyesuaikan Forum](../administering/customizing.html)
