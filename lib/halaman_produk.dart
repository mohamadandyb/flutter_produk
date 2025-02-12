import 'dart:convert';
import 'package:app_produk/edit_produk.dart';
import 'package:app_produk/tambah_produk.dart';
import 'package:app_produk/detail_produk.dart';
import 'package:app_produk/halaman_supplier.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HalamanProduk extends StatefulWidget {
  const HalamanProduk({super.key});

  @override
  State<HalamanProduk> createState() => _HalamanProdukState();
}

class _HalamanProdukState extends State<HalamanProduk> {
  List _listdata = [];
  bool _loading = true;

  // Fungsi untuk mendapatkan data produk
  Future _getdata() async {
    try {
      final respon = await http
          .get(Uri.parse('http://10.0.2.2/api_mobile/produk/read.php'));
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

  // Fungsi untuk menghapus produk
  Future<bool> _hapus(String id) async {
    try {
      final respon = await http.post(
        Uri.parse('http://10.0.2.2/api_mobile/produk/delete.php'),
        body: {'id_produk': id},
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
          'Halaman Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[300],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigasi ke halaman Tambah Produk
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TambahProduk()),
              ).then((_) {
                // Memperbarui data produk setelah menambahkan produk
                setState(() {
                  _getdata();
                });
              });
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _listdata.length,
              itemBuilder: (context, index) {
                var harga =
                    int.tryParse(_listdata[index]['harga_produk'].toString());
                var formattedHarga = harga != null
                    ? NumberFormat('#,###', 'id_ID').format(harga)
                    : 'Invalid';

                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailProduk(
                            ListData: _listdata[index],
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(_listdata[index]['nama_produk']),
                      subtitle: Text(
                        'Rp $formattedHarga',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UbahProduk(
                                    ListData: {
                                      'id_produk': _listdata[index]
                                          ['id_produk'],
                                      'nama_produk': _listdata[index]
                                          ['nama_produk'],
                                      'harga_produk': _listdata[index]
                                          ['harga_produk'],
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, color: Colors.teal),
                          ),
                          IconButton(
                            onPressed: () {
                              // Dialog konfirmasi penghapusan
                              showDialog(
                                context: context,
                                barrierDismissible:
                                    false, // Tidak dapat ditutup di luar dialog
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Konfirmasi Hapus'),
                                    content: const Text(
                                        'Apakah Anda yakin ingin menghapus produk ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Menutup dialog
                                        },
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _hapus(_listdata[index]['id_produk'])
                                              .then((value) {
                                            Navigator.of(context)
                                                .pop(); // Menutup dialog
                                            if (value) {
                                              setState(() {
                                                _listdata.removeAt(
                                                    index); // Menghapus produk dari list
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Produk berhasil dihapus')),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Gagal menghapus produk')),
                                              );
                                            }
                                          });
                                        },
                                        child: const Text('Hapus',
                                            style:
                                                TextStyle(color: Colors.red)),
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
        currentIndex: 0,
        selectedItemColor: Colors.teal,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HalamanSupplier()),
            );
          } else {
            // Tetap di halaman produk
          }
        },
      ),
    );
  }
}
