# Projek_Absensi_UTSPMP — Jurnal Absensi Mahasiswa

> **Proyek Ujian Tengah Semester (UTS) — Pemrograman Multi Platform Lanjutan (IT312)**  
> **Fakultas Teknologi Informasi — Institut Sains dan Bisnis Atma Luhur Pangkalpinang**  
> Dosen Koordinator: Rezky Yuranda, M.Kom  
> Kelompok: TA5J  

---

## 👥 Tabel Anggota Kelompok & Pembagian Peran

Pembagian peran disusun sesuai standar baku instruksi UTS PMP:

| No | Nama Mahasiswa | NIM | Peran Baku |
|---|---|---|---|
| 1 | **Sandi Kurniawan** | **2411500011** | **Auth + navigasi + struktur folder** |
| 2 | *[Nama Anggota 2]* | *[NIM]* | **Firestore CRUD + Model/Service/Provider + ViewState** |
| 3 | *[Nama Anggota 3]* | *[NIM]* | **Dio REST API + loading/error/empty + Future vs Stream** |

*(Catatan: Jika kelompok terdiri dari 2 orang, Anggota 2 merangkap peran Anggota 3 sesuai ketentuan silabus).*

---

## 🚀 Fitur Utama Aplikasi

Aplikasi dibangun berdasarkan tema **6. Jurnal Absensi/Kelas** dengan integrasi penuh teknologi modern Flutter:

1. **Firebase Authentication (P04):**
   - Registrasi akun baru (`createUserWithEmailAndPassword`).
   - Login dengan validasi kredensial (`signInWithEmailAndPassword`).
   - Logout dan pembersihan sesi lokal (`signOut`).
   - Auth Gating reaktif menggunakan `Stream<User?>` (`authStateChanges().listen`).
   - Penanganan pesan error berbahasa Indonesia yang informatif dan ramah pengguna.

2. **Cloud Firestore CRUD Realtime (P05 & P06):**
   - Koleksi: `journals`.
   - Struktur field: `{nim, status, note, createdAt}` bertipe `Timestamp`.
   - **Create**: Tambah catatan absensi baru via dialog modal interaktif.
   - **Read**: Langganan stream realtime via `snapshots()` dan pembacaan single-fetch via `get()`.
   - **Update**: Pembaruan status atau catatan absensi mahasiswa.
   - **Delete**: Penghapusan data absensi dengan dialog konfirmasi keamanan.
   - **Aturan Query Firestore**: Tanpa klausa `orderBy()` di server (menghindari error composite index). Pengurutan data (terbaru di atas) dan penyaringan status/NIM diproses secara efisien di sisi client (Dart).

3. **Pola Arsitektur MultiProvider & ViewState (P03 & P05):**
   - 3 ChangeNotifier terdaftar di root `main.dart` melalui `MultiProvider`:
     - `AuthProvider`: State autentikasi pengguna.
     - `JournalProvider`: State manajemen koleksi data absensi Firestore.
     - `DataProvider`: State manajemen integrasi REST API Dio.
   - Pola 5 status `ViewState`: `initial`, `loading`, `loaded`, `empty`, `error`.
   - Pembersihan memori (`dispose()`) dengan pembatalan langganan stream (`_subscription?.cancel()`) untuk mencegah memory leak.

4. **Integrasi REST API Dio (P02 & P03):**
   - Mengambil data mahasiswa dari REST API publik Reqres (`https://reqres.in/api/users`).
   - Otentikasi header kustom `x-api-key: reqres-free-v1`.
   - Konfigurasi timeout koneksi dan penerimaan data masing-masing 10 detik.
   - Visualisasi status lengkap: Spinner pemuatan, penanganan state kosong, dan tombol *Retry* saat koneksi terputus.

5. **Navigasi Minimal 4 Layar Berkelanjutan:**
   - **Layar 1 — Login / Register Screen**: Antarmuka autentikasi modern dengan tombol toggle formulir.
   - **Layar 2 — Home CRUD Screen**: Dasbor utama jurnal absensi, ringkasan statistik kehadiran, filter status chip, pencarian instan, dan kartu absensi dengan status badge.
   - **Layar 3 — List API Screen**: Katalog daftar mahasiswa dari Reqres API via Dio dengan fitur pencarian dan mode picker NIM.
   - **Layar 4 — Detail API Screen**: Profil lengkap mahasiswa, informasi teknis REST API, tombol cepat pencatatan absensi, dan riwayat absensi mahasiswa terkait di Firestore.

6. **Desain UI/UX Selaras:**
   - Menyesuaikan referensi desain mockup: Kartu berbayang halus, sudut melengkung (*border radius 16*), status badge warna-warni (*HADIR, SAKIT, IZIN, ALPA*), dan floating action button.

---

## 📁 Struktur Folder Proyek

```text
lib/
├── firebase_options.dart         # Konfigurasi platform Firebase (Wajib di-commit)
├── main.dart                     # Inisialisasi Firebase, MultiProvider, & Auth Gating
├── models/
│   ├── journal_model.dart        # Model data Firestore {nim, status, note, createdAt}
│   └── user_model.dart           # Model data REST API Reqres {id, email, names, avatar}
├── providers/
│   ├── auth_provider.dart        # Manajemen status autentikasi Firebase Auth
│   ├── data_provider.dart        # Manajemen data REST API Dio & ViewState
│   ├── journal_provider.dart     # Manajemen CRUD Firestore, ViewState, & Stream
│   └── view_state.dart           # Enum status: initial, loading, loaded, empty, error
├── screens/
│   ├── home_screen.dart          # Layar Utama CRUD Jurnal Absensi
│   ├── login_screen.dart         # Layar Login & Registrasi Akun
│   ├── user_detail_screen.dart   # Layar Detail Mahasiswa (API) & Riwayat Kehadiran
│   └── user_list_screen.dart     # Layar Daftar Mahasiswa (API Reqres via Dio)
├── services/
│   ├── api_service.dart          # Layanan HTTP Client Dio Reqres & Error Handling
│   └── firestore_service.dart    # Layanan Operasi Database Cloud Firestore
└── theme/
    └── app_theme.dart            # Konfigurasi tema global, warna status badge, & komponen
```

---

## 🛠️ Panduan Menjalankan Aplikasi

Pastikan Flutter SDK (>= 3.13.3) telah terpasang pada komputer Anda.

### 1. Unduh Dependensi
Jalankan perintah berikut di direktori proyek:
```bash
flutter pub get
```

### 2. Konfigurasi Firebase (Khusus Dosen / Penguji)
Jika ingin menghubungkan ulang ke proyek Firebase pribadi:
```bash
# Pastikan Firebase CLI & FlutterFire CLI sudah aktif
firebase login
flutterfire configure
```
> **Catatan**: Berkas `lib/firebase_options.dart` bawaan sudah dikonfigurasi dan diikutsertakan di repositori sehingga aplikasi dapat langsung dijalankan tanpa konfigurasi ulang.

### 3. Menjalankan Aplikasi
```bash
# Mode Debug pada perangkat/emulator yang aktif:
flutter run
```

---

## 💡 Konsep Async P01: Perbedaan `Future` vs `Stream`

Sebagai panduan saat presentasi video UTS:

| Pembeda | `Future` (Single Fetch) | `Stream` (Continuous Pipeline) |
|---|---|---|
| **Karakteristik** | Menghasilkan **satu nilai tunggal** atau pesan error di masa depan, kemudian selesai/tertutup. | Menghasilkan **rangkaian banyak nilai** secara berkelanjutan dari waktu ke waktu sampai dihentikan (*cancel/dispose*). |
| **Implementasi di Proyek** | `ApiService.fetchUsers()` via `_dio.get()` dan `FirestoreService.getNotesOnce()` / `refreshOnce()`. | `FirebaseAuth.instance.authStateChanges()` dan `FirestoreService.streamJournals()` via `.snapshots()`. |
| **Skenario Penggunaan** | Mengambil data mahasiswa dari REST API publik atau tombol refresh manual satu kali klik. | Menampilkan perubahan jurnal absensi secara realtime saat data ditambahkan/diubah dari mana saja. |

---

## 🔗 Tautan Video Presentasi & Demo

- **Link Video Google Drive**: `[MASUKKAN_LINK_GOOGLE_DRIVE_DI_SINI]`
*(Pastikan hak akses tautan telah disetel ke "Anyone with the link / Siapa saja yang memiliki link dapat melihat")*
