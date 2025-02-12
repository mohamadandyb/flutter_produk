import 'dart:convert'; // Import dart:convert untuk JSON encoding
import 'package:app_produk/halaman_produk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class UbahProduk extends StatefulWidget {
  final Map ListData;
  const UbahProduk({super.key, required this.ListData});

  @override
  State<UbahProduk> createState() => _UbahProdukState();
}

class _UbahProdukState extends State<UbahProduk> {
  final formKey = GlobalKey<FormState>();

  // Menyimpan controller untuk setiap input field
  TextEditingController id_produk = TextEditingController();
  TextEditingController nama_produk = TextEditingController();
  TextEditingController harga_produk = TextEditingController();

  Future<bool> _ubah() async {
    try {
      // Mengirim request POST dengan body JSON
      final response = await http.post(
        Uri.parse('http://10.0.2.2/api_mobile/produk/edit.php'),
        headers: {
          'Content-Type': 'application/json', // Set content-type ke JSON
        },
        body: json.encode({
          'id_produk': id_produk.text,
          'nama_produk': nama_produk.text,
          'harga_produk': harga_produk.text,
        }),
      );

      // Mengecek status code dan response body
      if (response.statusCode == 200 && response.body.contains('Sukses')) {
        return true; // Jika berhasil
      } else {
        return false; // Jika gagal
      }
    } catch (e) {
      print("Error: $e");
      return false; // Jika terjadi error
    }
  }

  @override
  void initState() {
    super.initState();
    // Mengisi controller dengan data yang diterima
    id_produk.text = widget.ListData['id_produk'];
    nama_produk.text = widget.ListData['nama_produk'];
    harga_produk.text = widget.ListData['harga_produk'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Produk', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal[300],
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Field untuk Nama Produk
              TextFormField(
                controller: nama_produk,
                decoration: InputDecoration(
                  hintText: 'Nama Produk',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) return "Nama produk tidak boleh kosong!";
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Field untuk Harga Produk
              TextFormField(
                controller: harga_produk,
                decoration: InputDecoration(
                  hintText: 'Harga Produk',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ], // Hanya menerima angka
                validator: (value) {
                  if (value!.isEmpty) return "Harga produk tidak boleh kosong!";
                  if (int.tryParse(value) == null) {
                    return "Harga produk harus berupa angka!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Tombol Ubah
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
                    _ubah().then((value) {
                      final snackBar = SnackBar(
                        content: Text(value
                            ? 'Data berhasil diubah'
                            : 'Data gagal diubah'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      // Jika berhasil, kembali ke halaman produk
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
                child: const Text('Ubah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
