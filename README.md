# Linguora Translation — Company Profile + Order Database

Website responsif untuk Linguora Translation, Bangkalan, Madura. Berisi profil, layanan English ↔ Indonesian, tim, informasi harga per halaman, formulir pesanan tersimpan ke Supabase, dan dashboard admin untuk anggota tim yang disetujui.

## Struktur file
- `index.html` — konten dan struktur website.
- `style.css` — desain responsif navy, cream, teal.
- `app.js` — koneksi database, formulir pesanan, login, dashboard.
- `config.js` — Supabase Project URL dan anon/public key.
- `supabase.sql` — tabel, validasi, dan Row Level Security.
- `assets/logo.svg` — logo Linguora.

## 1. Siapkan Supabase dari HP Android
1. Buka https://supabase.com, daftar/login, lalu buat project `linguora-translation`.
2. Simpan database password secara pribadi.
3. Buka SQL Editor → New query. Salin seluruh isi file `supabase.sql`, tempel, lalu tekan Run.
4. Buka Project Settings → API (atau API Keys). Salin Project URL dan anon/public key.
5. Jangan pernah menyalin `service_role` key, secret key, atau database password ke website/chat.

## 2. Hubungkan website ke database
1. Setelah upload ke GitHub, buka file `config.js`.
2. Ganti `PASTE_YOUR_SUPABASE_PROJECT_URL_HERE` dengan Project URL Supabase.
3. Ganti `PASTE_YOUR_SUPABASE_ANON_PUBLIC_KEY_HERE` dengan anon/public key.
4. Commit changes. Anon key memang boleh berada di browser; keamanan data diatur oleh RLS pada database.

## 3. Buat lima akun admin tim
Jangan aktifkan public sign-up. Pemilik project membuat akun secara manual:
1. Supabase → Authentication → Users → Add user.
2. Buat akun terpisah untuk Tria Maretno, Qibtiyah, Mukrifah, Nurrisma Dwi Januwati, dan Nagita Tri Cahyani menggunakan email yang mereka miliki. Berikan password awal secara pribadi dan minta mereka menggantinya.
3. Setelah dibuat, salin UUID setiap user dari Authentication → Users.
4. Di SQL Editor jalankan query berikut setelah mengganti seluruh UUID placeholder dengan UUID asli:

```sql
insert into public.team_members(user_id, display_name) values
('UUID-TRIA', 'Tria Maretno'),
('UUID-QIBTIYAH', 'Qibtiyah'),
('UUID-MUKRIFAH', 'Mukrifah'),
('UUID-NURRISMA', 'Nurrisma Dwi Januwati'),
('UUID-NAGITA', 'Nagita Tri Cahyani');
```

Jangan menjalankan query dengan teks UUID placeholder. Setiap anggota memakai akun sendiri. Hanya user yang terdaftar di `team_members` dapat melihat/mengelola pesanan.

## 4. Upload dan publikasikan ke GitHub Pages via Android
1. Download ZIP ini dan ekstrak menggunakan aplikasi Files/My Files.
2. Buka https://github.com lalu login.
3. Buat repository baru bernama `linguora-translation`, pilih Public.
4. Repository → Add file → Upload files. Unggah semua isi folder hasil ekstrak termasuk folder `assets` (jangan hanya ZIP).
5. Commit changes ke branch `main`.
6. Repository → Settings → Pages.
7. Build and deployment: pilih Deploy from a branch, branch `main`, folder `/(root)`, lalu Save.
8. Tunggu proses publikasi. Alamatnya: `https://USERNAME.github.io/linguora-translation/` (ganti USERNAME dengan username GitHub).

## 5. Tes sistem
1. Buka website publik dan kirim permintaan tes dengan data contoh yang tidak sensitif.
2. Supabase → Table Editor → orders, pastikan data muncul.
3. Di bagian Admin website, login dengan akun tim yang sudah didaftarkan.
4. Pastikan pesanan tampil dan status dapat diubah.
5. Coba akses sebagai pengunjung tanpa login: daftar pesanan tidak boleh terbaca.

## Catatan keamanan & batasan
- Jangan pernah menaruh `service_role` key, secret key, atau password database dalam file frontend.
- RLS mengizinkan pengunjung mengirim pesanan, tetapi tidak membaca pesanan. Hanya anggota tim terdaftar dapat melihat/memperbarui.
- Formulir belum menerima unggahan dokumen. Jangan minta pelanggan memasukkan dokumen rahasia ke kolom detail. Fitur upload kelak perlu Supabase Storage private bucket dan aturan akses tersendiri.
- Tambahkan CAPTCHA/rate limit sebelum promosi besar untuk mengurangi spam.
- Harga per halaman belum diisi nominalnya karena belum diberikan. Website menampilkan ajakan meminta penawaran, bukan harga rekaan.
- GitHub Pages dan Supabase memiliki paket gratis dengan batas penggunaan yang dapat berubah. Custom domain biasanya berbayar.
- Email: translationlionguora@gmail.com; WhatsApp: +62 859-5424-0751; Instagram: @linguoratranslation.
