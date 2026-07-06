# 📱 apk-TravelLog

## Tentang Project
**apk-TravelLog** adalah aplikasi mobile yang membantu pengguna mencatat aktivitas perjalanan sekaligus mengelola pengeluaran selama perjalanan berlangsung. Data disimpan secara dinamis melalui REST API custom (PHP Native) yang terhubung ke database MySQL.

## Fitur Utama
- ✅ Tambah catatan perjalanan baru
- 📄 Menampilkan daftar seluruh catatan perjalanan
- 🗑️ Menghapus catatan perjalanan
- 📊 Pencatatan & pengelolaan pengeluaran per perjalanan
- 🔗 Sinkronisasi data real-time via REST API

## Tech Stack
Flutter (Dart) — frontend
PHP native — REST API
MySQL — database
XAMPP untuk local server

## ⚙️ Instalasi & Menjalankan Project
### 1. Clone Repository
```bash
git clone https://github.com/Fahmihmdn22/apk-TravelLog.git
cd apk-TravelLog
```

### 2. Setup Backend (PHP & MySQL)
```bash
# 1. Jalankan Apache & MySQL di XAMPP
# 2. Import database
mysql -u root -p travel < travel.sql

# 3. Pindahkan folder API ke direktori server
cp -r app_travel_api/ /path/to/xampp/htdocs/
```

### 3. Jalankan Aplikasi Flutter
```bash
flutter pub get
flutter run
```

## 🔗 Struktur Project
```
apk-TravelLog/
├── lib/
│   ├── main.dart
│   ├── login.dart
│   └── main_page.dart
│
└── app_travel_api/
    └── catatan_perjalanan.php
```

##  Konfigurasi API
Pastikan base URL API pada aplikasi Flutter mengarah ke IP lokal server kamu (bukan `localhost`), agar dapat diakses dari emulator/perangkat fisik.
```
http://192.168.x.x/app_travel_api/
```

Cek IP lokal dengan:
```bash
ipconfig      # Windows
ifconfig      # macOS / Linux
```

##  Roadmap
- [ ] Autentikasi user (login/register)
- [ ] Export laporan pengeluaran ke PDF (comming soon)
- [ ] Filter catatan berdasarkan tanggal
- [ ] Mode offline dengan local storage

## 📄 Lisensi
Project ini dibuat untuk keperluan akademik (UAS / Tugas Akhir Mata Kuliah) dan bebas digunakan sebagai referensi belajar.

---

<div align="center">
Made with using Flutter
</div>
