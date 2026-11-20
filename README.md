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

### Tugas 8

1. Navigator.push() menambahkan route ke dalam stack route, sehingga route yang baru ditambahkan akan ditampilkan kepada pengguna. Navigator.pushReplacement() bukan hanya menambahkan tetapi mengganti/menghapus route paling atas di stack dengan route yang baru ditambahkan. Jadi, kalau di push() biasa, pengguna bisa menekan tombol back untuk kembali ke halaman sebelumnya, sedangkan di pushReplacement(), halaman sebelumnya sudah hilang atau digantikan. Navigator.pop() menghapus route yang berada di paling atas stack (yang sedang ditampilkan ke pengguna), sehingga tampilan aplikasi berpindah ke route yang berada di bawahnya. 

Metode yang digunakan untuk membuka formulir dari kartu aksi adalah Navigator.push(), berbeda dengan yang digunakan pada drawer yaitu pushReplacement(). Opsi Home di drawer menggunakan pushReplacement() sehingga ia akan menghapus route saat ini (misalnya EducationForm) dan menggantinya dengan MyHomePage. Karena route EducationFormnya sudah dihapus, ketika pengguna menekan tombol kembali, aplikasi tidak akan menampilkan kembali form Education tersebut.

2. Scaffold adalah kerangka dasar halaman yang menyediakan slot tetap, appBar di atas, drawer di kiri, dan body di tengah. Karena setiap route/halaman menggunakan kerangka yang sama, jadi struktur halaman tetap konsisten dan pengguna selalu menemukan elemen yang sama di tempat yang sama. Warna tema portofolio yang digunakan adalah background indigo dan foreground white, warna tersebut sama-sama digunakan di ExperienceForm dan EducationForm.

3. body dari formulir menggunakan Form, SingleChildScrollView, Column, dan tiap field dibungkus Padding. Tata letak tersebut dipilih karena Column menyusun field dari atas ke bawah, seperti urutan orang mengisi formulir pada umumnya. Padding sebagai pengatur jarak agar input field tidak menempel satu sama lain. SingleChildScrollView agar halaman bisa discroll saat di layar kecil atau memunculkan keyboard, tanpa itu field yang ada di bawah mungkin tidak bisa dijangkau dan Flutter menampilkan error RenderFlex overflowed.

4. `GlobalKey<FormState> (_formKey)` adalah pegangan ke Form. Melalui `_formKey.currentState`, kode di luar field (tombol save) bisa menjangkau seluruh form sekaligus (validasi atau reset). validator ada di tiap TextFormField untuk mengecek apakah input user valid (return null) atau tidak (return pesan error berupa String). validate() dipanggil saat tombol save ditekan dan akan menjalankan semua validator di dalam form, jika ada satu saja yang mengembalikan pesan, pesan merah ditampilkan di field yang bermasalah.

Contoh nilai yang ditolak oleh validasi adalah jika user mengisi "   " (hanya spasi) pada Institution Name, validator mengecek dengan value.trim().isEmpty kemudian ditolak. keyboardType dan inputFormatters hanya memandu pengetikan dan tidak menjamin inputnya benar/sesuai. digitsOnly mencegah huruf tapi tidak angka ekstrem seperti 1 atau 9999.

Penggunaan AI: Menggunakan Claude untuk meminta referensi penggunaan showDatePicker() dan widget input untuk tipe data int, serta membantu menyusun kata untuk menjawab pertanyaan reflektif.