import 'package:flutter/material.dart';
import 'package:app_produk/supplier.dart'; // Pastikan mengimpor model Supplier

class DetailSupplier extends StatelessWidget {
  final Supplier supplier; // Menggunakan objek Supplier langsung
  
  const DetailSupplier({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Supplier',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Card(
          elevation: 12,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text('Id Supplier'),
                  subtitle: Text(supplier.id_supplier.toString()), // Mengakses id dari objek Supplier
                ),
                ListTile(
                  title: const Text('Nama Supplier'),
                  subtitle: Text(supplier.nama), // Mengakses nama dari objek Supplier
                ),
                ListTile(
                  title: const Text('Alamat'),
                  subtitle: Text(supplier.alamat), // Mengakses alamat dari objek Supplier
                ),
                ListTile(
                  title: const Text('No Telepon'),
                  subtitle: Text(supplier.kontak), // Mengakses kontak dari objek Supplier
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}