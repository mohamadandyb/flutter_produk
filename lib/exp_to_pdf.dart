import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

Future<void> exportToPDF(BuildContext context, List<dynamic> data) async {
  final pdf = pw.Document();

  // Menambahkan halaman baru ke PDF
  pdf.addPage(pw.Page(
    build: (pw.Context context) {
      return pw.Column(
        children: [
          pw.Text('Laporan Data Supplier', style: pw.TextStyle(fontSize: 20)),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ['ID Supplier', 'Nama Supplier', 'Alamat', 'No Telepon'],
            data: data.map((supplier) {
              return [
                supplier['id_supplier'],
                supplier['nama_supplier'],
                supplier['alamat'],
                supplier['no_telepon']
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
