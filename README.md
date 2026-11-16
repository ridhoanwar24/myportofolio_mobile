### Tugas 7

1. Widget tree adalah representasi susunan elemen UI di flutter(teks, ikon, tombol, dll). Widget parent dapat memiliki satu atau lebih child. Parent mengirimkan batasan ukuran (seperti lebar/tinggi minimum dan maksimum) ke child. Kemudian, child menentukan ukurannya sendiri sesuai batasan tersebut, lalu parent mengatur posisi child di layar. Child juga dapat mengakses data yang disediakan oleh parentnya (seperti tema warna dari MaterialApp).

2. - MaterialApp: root widget yang membungkus aplikasi
   - MyHomePage: sebagai halaman utama
   - Scaffold: sebagai kerangka/tata letak visual
   - AppBar: menampilkan judul di bagian atas
   - Padding: memberikan jarak
   - Column: menyusun widget children ke dalam kolom
   - Row: menyusun widget children ke dalam baris
   - InfoCard: menampilkan informasi dalam bentuk card
   - Card: menampilkan kotak/kartu
   - Container: sebagai pembungkus/wadah yang menampung widget-widget childrennya
   - SizedBox: membuat kotak dengan ukuran tertentu
   - Center: mengatur posisi agar ke tengah
   - Text: menampilkan text
   - GridView: menyusun widget dalam bentuk grid
   - ItemCard: Kartu aksi/tombol yang mewakili setiap menu pada halaman portofolio
   - Icon: menampilkan ikon
   - SnackBar: menampilkan pesan notifikasi di bawah layar ketika pengguna menekan salah satu ItemCard

3. MaterialApp berfungsi untuk mengatur tema aplikasi secara global, mengelola rute dan navigasi antarhalaman, dan menyediakan fungsi bawaan seperti ScaffoldMessenger untuk menampilkan SnackBar. MaterialApp umum dijadikan root widget karena banyak widget turunan(Scaffold, AppBar, Card, SnackBar, dll.) membutuhkan konfigurasi tema dan konteks navigator yang hanya disediakan oleh MaterialApp.

4. StatelessWidget bersifat immutable dan hanya dirender sekali saat pertama kali dibuat, atau jika parent mengirim data baru. Sedangkan StatefulWudget bersifat mutable dan dapat dirender ulang secara dinamis. StatelessWidget digunakan ketika tampilan UI murni statis dan tidak berubah akibat interaksi dengan user, StatefulWidget digunakan ketika tampilan perlu diperbarui secara dinamis berdasarkan interaksi user atau perubahan data secara real-time.

5. BuildContext adalah pegangan yang menyimpan lokasi sebuah widget di dalam widget tree. Setiap widget memiliki BuildContext-nya sendiri yang menghubungkannya dengan parent di atasnya. BuildContext merupakan satu-satunya cara bagi sebuah widget untuk berkomunikasi ke atas dalam hirarki tree untuk mencari data dari parentnya. Di tugas ini, parameter context diteruskan ke metode build untuk mengambil informasi dari widget induk di atasnya, contohnya adalah Theme.of(context).colorScheme.primary: menelusuri pohon ke atas untuk mengambil warna utama yang didefinisikan pada MaterialApp.

6. Hot reload memuat perubahan kode ke Dart Virtual Machine dan membangun ulang widget tree tanpa mengubah state aplikasi. Hot restart memuat perubahan kode ke VM tapi merestart Flutter app sehingga kehilangan state aplikasi saat ini. Kita tidak bisa hanya mengandalkan hot reload ketika mengubah variabel global atau mengubah struktur fungsi main() (harus melakukan hot restart), atau ketika menambahkan package/dependensi dan aset baru (harus full restart).

Penggunaan AI: Pengerjaan kode pada tugas 7 mengikuti contoh tutorial tanpa penggunaan AI, menggunakan Google Mode AI untuk membantu menjawab pertanyaan reflektif yang tidak ditemukan referensinya di Slide perkuliahan.