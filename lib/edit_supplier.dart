import 'package:app_produk/database_helper.dart';
import 'package:app_produk/halaman_supplier.dart';
import 'package:flutter/material.dart';
import 'supplier.dart'; // Pastikan model Supplier diimpor

class UbahSupplier extends StatefulWidget {
  final Supplier supplier; // menggunakan objek Supplier langsung
  const UbahSupplier({super.key, required this.supplier});

  @override
  State<UbahSupplier> createState() => _UbahSupplierState();
}

class _UbahSupplierState extends State<UbahSupplier> {
  final formKey = GlobalKey<FormState>();
  
  // Menyimpan controller untuk setiap input field
  TextEditingController id_supplier = TextEditingController();
  TextEditingController nama_supplier = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController no_telepon = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Mengisi controller dengan data yang diterima
    id_supplier.text = widget.supplier.id_supplier.toString();
    nama_supplier.text = widget.supplier.nama;
    alamat.text = widget.supplier.alamat;
    no_telepon.text = widget.supplier.kontak; // menggunakan kontak untuk No Telepon
  }

  Future<bool> _ubah() async {
    try {
      final updatedSupplier = Supplier(
        id_supplier: int.parse(id_supplier.text), // Parsing ID menjadi integer
        nama: nama_supplier.text,
        alamat: alamat.text,
        kontak: no_telepon.text,
      );
      final dbHelper = DatabaseHelper.instance;
      final result = await dbHelper.updateSupplier(updatedSupplier); // Menggunakan DatabaseHelper
      return result > 0; // return true jika berhasil
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
          'Ubah Data Supplier',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Field untuk Nama Supplier
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
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // Field untuk Alamat
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
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // Field untuk No Telepon
              TextFormField(
                controller: no_telepon,
                keyboardType: TextInputType.phone,
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
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // Tombol Ubah
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
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
                child: const Text('Ubah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}