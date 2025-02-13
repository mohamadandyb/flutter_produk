import 'package:flutter/material.dart';
import 'package:app_produk/database_helper.dart'; // Pastikan untuk mengimpor DatabaseHelper
import 'package:app_produk/supplier.dart'; // Pastikan untuk mengimpor model Supplier
import 'halaman_supplier.dart';

class TambahSupplier extends StatefulWidget {
  const TambahSupplier({super.key});

  @override
  State<TambahSupplier> createState() => _TambahSupplierState();
}

class _TambahSupplierState extends State<TambahSupplier> {
  final formKey = GlobalKey<FormState>(); // Mendefinisikan formKey
  TextEditingController nama_supplier = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController no_telepon = TextEditingController();

  Future<bool> _simpan() async {
    try {
      final newSupplier = Supplier(
        id_supplier: 0, // ID akan diatur otomatis oleh database
        nama: nama_supplier.text,
        alamat: alamat.text,
        kontak: no_telepon.text,
      );

      final dbHelper = DatabaseHelper.instance;
      final result = await dbHelper.insertSupplier(newSupplier); // Menggunakan DatabaseHelper
      return result > 0; // Mengembalikan true jika berhasil
    } catch (e) {
      print("Error: $e");
      return false; // Mengembalikan false jika terjadi error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Data Supplier',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: formKey, // Menggunakan formKey yang sudah didefinisikan
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: nama_supplier,
                decoration: InputDecoration(
                  hintText: 'Nama Supplier',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Nama supplier tidak boleh kosong!";
                  }
                  return null; // Return null jika valid
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: alamat,
                decoration: InputDecoration(
                  hintText: 'Alamat',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Alamat tidak boleh kosong!";
                  }
                  return null; // Return null jika valid
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: no_telepon,
                decoration: InputDecoration(
                  hintText: 'No Telepon',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Nomor Telepon tidak boleh kosong!";
                  }
                  return null; // Return null jika valid
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
                      // Jika berhasil, kembali ke halaman supplier
                      if (value) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HalamanSupplier()),
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