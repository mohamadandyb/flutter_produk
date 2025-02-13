import 'package:app_produk/database_helper.dart';
import 'package:app_produk/halaman_produk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import FilteringTextInputFormatter
import 'produk.dart';

class UbahProduk extends StatefulWidget { // Mengubah menjadi StatefulWidget
  final Produk produk; // Mengambil objek Produk langsung
  const UbahProduk({super.key, required this.produk}); // Modifikasi Key

  @override
  _UbahProdukState createState() => _UbahProdukState();
}

class _UbahProdukState extends State<UbahProduk> {
  final formKey = GlobalKey<FormState>();

  TextEditingController id_produk = TextEditingController();
  TextEditingController nama_produk = TextEditingController();
  TextEditingController harga_produk = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Mengisi controller dengan data yang diterima
    id_produk.text = widget.produk.id_produk.toString();
    nama_produk.text = widget.produk.nama_produk;
    harga_produk.text = widget.produk.harga_produk.toString();
  }

  Future<bool> _ubah() async {
    try {
      final produk = Produk(
        id_produk: int.tryParse(id_produk.text) ?? 0,
        nama_produk: nama_produk.text,
        harga_produk: int.tryParse(harga_produk.text) ?? 0,
      );
      int result = await DatabaseHelper.instance.updateProduk(produk);
      return result > 0;
    } catch (e) {
      print("Error: $e");
      return false;
    }
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
              // Field untuk ID Produk (tidak bisa diubah)
              TextFormField(
                controller: id_produk,
                decoration: InputDecoration(
                  hintText: 'ID Produk',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                readOnly: true, // ID produk tidak bisa diubah
              ),
              const SizedBox(height: 10),

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
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                        content: Text(value ? 'Data berhasil diubah' : 'Data gagal diubah'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      // Jika berhasil, kembali ke halaman produk
                      if (value) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HalamanProduk()),
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
