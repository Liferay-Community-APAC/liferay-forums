---
title: Masalah yang Diketahui
parent: Referensi
nav_order: 4
---

# Masalah yang Diketahui {#known-issues}

Keterbatasan yang diketahui pada Liferay Forums 1.0.0.

## Penulis Pertanyaan Tidak Dapat Menandai Jawaban {#a-questions-author-cant-mark-an-answer}

Penulis pertanyaan melihat **Mark as Answer**, tetapi penandaan balasan gagal, karena anggota tidak diizinkan mengubah balasan anggota lain. Moderator dapat menandai jawaban.

## Men-deploy Batch Lagi {#deploying-the-batch-again}

Deploy `liferay-forums-batch.zip` sekali saja. Setiap kali batch di-deploy lagi:

- Custom field dan relationship yang ditambahkan administrator ke object **User** milik Liferay akan dihapus. Tambahkan kembali setelahnya.
- Liferay mencatat error bahwa template email sudah ada. Batch mempertahankan perubahan Anda pada template tersebut.
- Di Liferay PaaS, tempat job batch berjalan pada setiap deploy, job tersebut ditampilkan sebagai gagal karena alasan yang sama. Data forum sudah diimpor sebelum itu, sehingga tidak ada yang hilang. [Langkah 5 di On Liferay PaaS](../installing/paas.html#step-5-deploy-a-second-build) mencegahnya, dengan menghapus file template email setelah deploy pertama.

## Error Dicatat Saat Topik Diperbarui {#an-error-is-logged-when-a-topic-is-updated}

Tanpa perbaikan Liferay LPD-102310, saat microservice forum memperbarui topik yang memiliki kategori, Liferay mencatat `ERROR ... Invalid asset category with external reference code ...`. Topik tetap mempertahankan kategorinya, dan tidak ada hal lain yang terpengaruh.

## Di Liferay PaaS dan SaaS, Menjalankan Ulang Job Site Initializer Mengatur Ulang Alamat Situs {#on-liferay-paas-and-saas-a-site-initializer-job-run-again-resets-the-sites-address}

Setiap kali job site initializer dijalankan lagi pada situs yang sudah ada, friendly URL situs diatur ulang menjadi `/group-<number>`, dan tautan forum menampilkan halaman not found. LPD-85594 memperbaiki hal ini untuk zip site initializer yang di-deploy ke Liferay itu sendiri, tetapi tidak untuk job yang dijalankan Liferay Cloud. Hapus setiap proyek site initializer setelah situsnya ada, seperti dalam [Menginstal di Liferay PaaS](../installing/paas.html#step-5-deploy-a-second-build), dan di Liferay SaaS jangan deploy site initializer lagi. Jika alamat telah diatur ulang, atur kembali di *Site Settings*.

## Menghapus Balasan Tidak Mengubah Tanggal Aktivitas Topik {#deleting-a-reply-doesnt-change-a-topics-activity-date}

Topik tetap berada di posisinya di **Recent Activity** setelah balasan terbarunya dihapus.

## Informasi Terkait {#related-information}

- [Melaporkan Bug](reporting-a-bug.html)
- [Catatan rilis](https://github.com/Liferay-Community-APAC/liferay-forums/releases)
