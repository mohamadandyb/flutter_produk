import 'package:app_produk/halaman_produk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahProduk extends StatefulWidget {
  const TambahProduk({super.key});

  @override
  State<TambahProduk> createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  final formKey = GlobalKey<FormState>(); // Perbaikan: mendefinisikan formKey
  TextEditingController nama_produk = TextEditingController();
  TextEditingController harga_produk = TextEditingController();

  Future<bool> _simpan() async {
    final respon = await http
        .post(Uri.parse('http://10.0.2.2/api_mobile/produk/create.php'), body: {
      'nama_produk': nama_produk.text,
      'harga_produk': harga_produk.text,
    });
    return respon.statusCode == 200; // Menyederhanakan pengecekan statusCode
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
                  return null; // Perbaikan: harus ada return null jika valid
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Harga produk tidak boleh kosong!";
                  }
                  return null; // Perbaikan: harus ada return null jika valid
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
