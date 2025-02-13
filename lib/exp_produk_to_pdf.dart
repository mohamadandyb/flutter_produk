import 'dart:io'; // Import untuk penggunaan File
import 'package:path_provider/path_provider.dart'; // Import untuk pengelolaan direktori
import 'package:pdf/widgets.dart' as pw; // Import untuk PDF
import 'package:flutter/material.dart'; // Import untuk BuildContext dan widget
import 'package:flutter_pdfview/flutter_pdfview.dart'; // Import untuk PDFView
import 'package:app_produk/produk.dart'; // Pastikan untuk mengimpor model Produk

Future<void> exportprodukToPDF(BuildContext context, List<Produk> products) async {
  final pdf = pw.Document();
  
  pdf.addPage(pw.Page(
    build: (pw.Context context) {
      return pw.Column(
        children: [
          pw.Text('Laporan Data Produk', style: const pw.TextStyle(fontSize: 20)),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: ['ID Produk', 'Nama Produk', 'Harga'],
            data: products.map((product) {
              return [
                product.id_produk, // Menggunakan getter
                product.nama_produk, // Menggunakan getter
                product.harga_produk, // Menggunakan getter
              ];
            }).toList(),
          ),
        ],
      );
    },
  ));

  // Menyimpan file PDF ke perangkat
  final directory = await getExternalStorageDirectory();
  final file = File('${directory?.path}/data_produk.pdf');
  await file.writeAsBytes(await pdf.save());

  // Menampilkan pesan bahwa ekspor berhasil
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Data berhasil diekspor ke PDF!')),
  );

  // Menampilkan PDF setelah diekspor
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PDFScreen(pdfFilePath: file.path),
    ),
  );
}

// Widget untuk menampilkan PDF
class PDFScreen extends StatelessWidget {
  final String pdfFilePath;

  const PDFScreen({super.key, required this.pdfFilePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lihat PDF'),
      ),
      body: PDFView(
        filePath: pdfFilePath,
      ),
    );
  }
}