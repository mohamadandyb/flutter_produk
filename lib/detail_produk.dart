import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailProduk extends StatelessWidget {
  final Map<String, dynamic> produk; // Mengganti nama parameter ke 'produk'
  
  const DetailProduk({super.key, required this.produk}); // Menggunakan 'produk' di constructor

  @override
  Widget build(BuildContext context) {
    // Mengonversi harga dari string ke integer dan memformat dengan separator ribuan
    var harga = int.tryParse(produk['harga_produk'].toString());
    var formattedHarga = harga != null 
      ? NumberFormat('#,###', 'id_ID').format(harga) 
      : 'Invalid';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[300],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Card(
          elevation: 12,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Mengatur posisi teks dari kiri
              children: [
                ListTile(
                  title: const Text('Id Produk'),
                  subtitle: Text(produk['id_produk'].toString()),
                ),
                ListTile(
                  title: const Text('Nama Produk'),
                  subtitle: Text(produk['nama_produk']),
                ),
                ListTile(
                  title: const Text('Harga Produk'),
                  subtitle: Text(
                    'Rp. $formattedHarga', // Menampilkan harga dengan separator ribuan
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}