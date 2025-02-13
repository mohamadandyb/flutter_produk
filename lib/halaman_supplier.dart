import 'package:flutter/material.dart';
import 'package:app_produk/edit_supplier.dart';
import 'package:app_produk/exp_to_pdf.dart';  
import 'package:app_produk/tambah_supplier.dart';
import 'package:app_produk/detail_supplier.dart';
import 'package:app_produk/halaman_produk.dart';
import 'package:app_produk/supplier.dart';
import 'package:app_produk/database_helper.dart';

class HalamanSupplier extends StatefulWidget {
  const HalamanSupplier({super.key});

  @override
  State<HalamanSupplier> createState() => _HalamanSupplierState();
}

class _HalamanSupplierState extends State<HalamanSupplier> {
  List<Supplier> _listdata = [];
  bool _loading = true;

  // Fungsi untuk mendapatkan data supplier dari database SQLite
  Future<void> _getdata() async {
    final dbHelper = DatabaseHelper.instance;
    final suppliers = await dbHelper.getAllSuppliers();
    setState(() {
      _listdata = suppliers;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getdata();
  }

  // Fungsi untuk menghapus supplier
  Future<bool> _hapus(int id) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final result = await dbHelper.deleteSupplier(id);
      return result > 0;
    } catch (e) {
      print(e);
      return false;
    }
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
                _getdata(); // Memperbarui data setelah menambahkan supplier
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              exportToPDF(context, _listdata); // Mengekspor data ke PDF
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _listdata.length,
              itemBuilder: (context, index) {
                var supplier = _listdata[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailSupplier(supplier: supplier),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(supplier.nama),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Alamat: ${supplier.alamat}'),
                          Text('No Telepon: ${supplier.kontak}'),
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
                                  builder: (context) => UbahSupplier(supplier: supplier),
                                ),
                              ).then((_) {
                                _getdata(); // Memperbarui data setelah editing
                              });
                            },
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () {
                              // Dialog konfirmasi penghapusan
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Konfirmasi Hapus'),
                                    content: const Text('Apakah Anda yakin ingin menghapus supplier ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Menutup dialog
                                        },
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _hapus(supplier.id_supplier).then((value) {
                                            Navigator.of(context).pop(); // Menutup dialog
                                            if (value) {
                                              setState(() {
                                                _listdata.removeAt(index);
                                              });
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Data supplier berhasil dihapus')),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Gagal menghapus data supplier')),
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
          }
        },
      ),
    );
  }
}