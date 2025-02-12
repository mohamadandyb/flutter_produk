import 'dart:convert'; // Import dart:convert untuk JSON encoding
import 'package:app_produk/halaman_supplier.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UbahSupplier extends StatefulWidget {
  final Map ListData;
  const UbahSupplier({super.key, required this.ListData});

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

  Future<bool> _ubah() async {
    try {
      // Mengirim request POST dengan body JSON
      final response = await http.post(
        Uri.parse('http://10.0.2.2/api_mobile/supplier/edit.php'),
        headers: {
          'Content-Type': 'application/json', // Set content-type ke JSON
        },
        body: json.encode({
          'id_supplier': id_supplier.text,
          'nama_supplier': nama_supplier.text,
          'alamat': alamat.text,
          'no_telepon': no_telepon.text,
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
    id_supplier.text = widget.ListData['id_supplier'];
    nama_supplier.text = widget.ListData['nama_supplier'];
    alamat.text = widget.ListData['alamat'];
    no_telepon.text = widget.ListData['no_telepon'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Data Supplier', style: TextStyle(fontWeight: FontWeight.bold)),
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
