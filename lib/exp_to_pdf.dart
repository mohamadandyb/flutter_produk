import 'dart:io'; // Import dart:io untuk penggunaan File
import 'package:path_provider/path_provider.dart'; // Import untuk pengelolaan direktori
import 'package:pdf/widgets.dart' as pw; // Import untuk PDF
import 'package:flutter/material.dart'; // Import untuk BuildContext dan widget
import 'package:flutter_pdfview/flutter_pdfview.dart'; // Pastikan untuk mengimpor PDFView
import 'package:app_produk/supplier.dart'; // Pastikan untuk mengimpor model Supplier

Future<void> exportToPDF(BuildContext context, List<Supplier> suppliers) async {
  final pdf = pw.Document();
  
  // Menambahkan halaman baru ke PDF
  pdf.addPage(pw.Page(
    build: (pw.Context context) {
      return pw.Column(
        children: [
          pw.Text('Laporan Data Supplier', style: const pw.TextStyle(fontSize: 20)),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: ['ID Supplier', 'Nama Supplier', 'Alamat', 'No Telepon'],
            data: suppliers.map((supplier) {
              return [
                supplier.id_supplier, // Menggunakan getter
                supplier.nama,        // Menggunakan getter
                supplier.alamat,      // Menggunakan getter
                supplier.kontak,      // Menggunakan getter
              ];
            }).toList(),
          ),
        ],
      );
    },
  ));
  
  // Menyimpan file PDF ke perangkat
  final directory = await getExternalStorageDirectory();
  final file = File('${directory?.path}/data_supplier.pdf');
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