import 'dart:convert';
import 'package:app_produk/edit_supplier.dart';
import 'package:app_produk/exp_to_pdf.dart';  // pastikan ekspor PDF sudah benar
import 'package:app_produk/tambah_supplier.dart';
import 'package:app_produk/detail_supplier.dart';
import 'package:app_produk/halaman_produk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HalamanSupplier extends StatefulWidget {
  const HalamanSupplier({super.key});

  @override
  State<HalamanSupplier> createState() => _HalamanSupplierState();
}

class _HalamanSupplierState extends State<HalamanSupplier> {
  List _listdata = [];
  bool _loading = true;

  // Fungsi untuk mendapatkan data supplier
  Future _getdata() async {
    try {
      final respon = await http.get(Uri.parse('http://10.0.2.2/api_mobile/supplier/read.php'));
      if (respon.statusCode == 200) {
        final data = jsonDecode(respon.body);
        setState(() {
          _listdata = data;
          _loading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // Fungsi untuk menghapus supplier
  Future<bool> _hapus(String id) async {
    try {
      final respon = await http.post(
        Uri.parse('http://10.0.2.2/api_mobile/supplier/delete.php'),
        body: {'id_supplier': id},
      );
      if (respon.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data Supplier',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TambahSupplier()),
              ).then((_) {
                setState(() {
                  _getdata();
                });
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              exportToPDF(context, _listdata); // Mengubah exportToPDF untuk menerima context
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _listdata.length,
              itemBuilder: (context, index) {
                var alamat = _listdata[index]['alamat'];
                var noTelepon = _listdata[index]['no_telepon'].toString();

                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailSupplier(
                            ListData: _listdata[index],
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(_listdata[index]['nama_supplier']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Alamat: $alamat'),
                          Text('No Telepon: $noTelepon'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UbahSupplier(
                                    ListData: {
                                      'id_supplier': _listdata[index]['id_supplier'],
                                      'nama_supplier': _listdata[index]['nama_supplier'],
                                      'alamat': _listdata[index]['alamat'],
                                      'no_telepon': _listdata[index]['no_telepon'],
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () {
                              // Dialog konfirmasi penghapusan
                              showDialog(
                                context: context,
                                barrierDismissible: false, // Tidak dapat ditutup di luar dialog
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Konfirmasi Hapus'),
                                    content: const Text(
                                        'Apakah Anda yakin ingin menghapus supplier ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Menutup dialog
                                        },
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _hapus(_listdata[index]['id_supplier']).then((value) {
                                            Navigator.of(context).pop(); // Menutup dialog
                                            if (value) {
                                              setState(() {
                                                _listdata.removeAt(index);
                                              });
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                    content: Text('Data supplier berhasil dihapus')),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                    content: Text('Gagal menghapus data supplier')),
                                              );
                                            }
                                          });
                                        },
                                        child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Supplier',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HalamanProduk()),
            );
          } else {
            // Tetap di halaman supplier
          }
        },
      ),
    );
  }
}
