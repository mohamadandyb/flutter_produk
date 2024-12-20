import 'package:flutter/material.dart';

class DetailSupplier extends StatelessWidget {
  final Map<String, dynamic>
      ListData; // Mendeklarasikan tipe data yang lebih jelas

  const DetailSupplier({super.key, required this.ListData});

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
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Mengatur posisi teks dari kiri
              children: [
                ListTile(
                  title: const Text('Id Supplier'),
                  subtitle: Text(ListData['id_supplier'].toString()),
                ),
                ListTile(
                  title: const Text('Nama Supplier'),
                  subtitle: Text(ListData['nama_supplier']),
                ),
                ListTile(
                  title: const Text('Alamat'),
                  subtitle: Text(ListData['alamat']),
                ),
                ListTile(
                  title: const Text('No Telepon'),
                  subtitle: Text(ListData['no_telepon'].toString()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
