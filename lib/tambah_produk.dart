import 'package:app_produk/halaman_produk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import untuk encoding JSON

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
      final response = await http.post(
        Uri.parse('http://10.0.2.2/api_mobile/produk/create.php'),
        headers: {
          'Content-Type': 'application/json', // Menetapkan content-type ke JSON
        },
        body: json.encode({
          'nama_produk': nama_produk.text,
          'harga_produk': harga_produk.text,
        }),
      );

      // Mengecek jika widget masih aktif (mounted)
      if (!mounted) return false;

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Mengembalikan true jika statusCode 200 dan body mengandung "Sukses"
      return response.statusCode == 200 && response.body.contains('Sukses');
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
