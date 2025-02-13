import 'package:app_produk/database_helper.dart'; // Import DatabaseHelper
import 'package:app_produk/halaman_produk.dart';
import 'package:flutter/material.dart';
import 'produk.dart'; // Pastikan untuk import model Produk

class TambahProduk extends StatefulWidget {
  const TambahProduk({super.key});

  @override
  State<TambahProduk> createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  final formKey = GlobalKey<FormState>(); // Mendefinisikan formKey
  TextEditingController nama_produk = TextEditingController();
  TextEditingController harga_produk = TextEditingController();

  Future<bool> _simpan() async {
    try {
      final dbHelper = DatabaseHelper.instance; // Gunakan instance untuk mengakses DatabaseHelper
      // Membuat objek Produk dengan data yang diinputkan
      final produk = Produk(
        id_produk: 0,  // id akan ditentukan oleh SQLite secara otomatis
        nama_produk: nama_produk.text,
        harga_produk: int.tryParse(harga_produk.text) ?? 0,
      );

      // Menyimpan data produk ke database
      int result = await dbHelper.insertProduk(produk);

      return result > 0; // Mengembalikan true jika berhasil menyimpan
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[300],
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: formKey, // Menggunakan formKey yang sudah didefinisikan
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: nama_produk,
                decoration: InputDecoration(
                  hintText: 'Nama Produk',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Nama produk tidak boleh kosong!";
                  }
                  return null; // Return null jika valid
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: harga_produk,
                decoration: InputDecoration(
                  hintText: 'Harga Produk',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number, // Memastikan input angka
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Harga produk tidak boleh kosong!";
                  }
                  // Validasi harga harus berupa angka
                  if (double.tryParse(value) == null) {
                    return "Harga produk harus berupa angka!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[400],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _simpan().then((value) {
                      // Mengecek apakah widget masih aktif sebelum melakukan tindakan
                      if (!mounted) return;

                      final snackBar = SnackBar(
                        content: Text(value
                            ? 'Data berhasil disimpan'
                            : 'Data gagal disimpan'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      if (value) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HalamanProduk()),
                          (route) => false,
                        );
                      }
                    });
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
