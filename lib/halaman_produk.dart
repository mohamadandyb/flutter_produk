import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_produk/database_helper.dart';
import 'package:app_produk/edit_produk.dart';
import 'package:app_produk/tambah_produk.dart';
import 'package:app_produk/detail_produk.dart';
import 'package:app_produk/halaman_supplier.dart';
import 'package:app_produk/produk.dart';
import 'package:app_produk/exp_produk_to_pdf.dart'; // Import untuk fungsi ekspor PDF

class HalamanProduk extends StatefulWidget {
  const HalamanProduk({super.key});

  @override
  State<HalamanProduk> createState() => _HalamanProdukState();
}

class _HalamanProdukState extends State<HalamanProduk> {
  List<Map<String, dynamic>> _listdata = [];
  bool _loading = true;

  // Fungsi untuk mendapatkan data produk dari database
  Future<void> _getdata() async {
    final dbHelper = DatabaseHelper.instance;
    final List<Map<String, dynamic>> data = await dbHelper.getAllProduk();
    setState(() {
      _listdata = data;
      _loading = false;
    });
  }

  // Fungsi untuk menghapus produk
  Future<void> _hapus(int id) async {
    final dbHelper = DatabaseHelper.instance;
    int result = await dbHelper.deleteProduk(id);
    if (result > 0) {
      setState(() {
        _listdata.removeWhere((item) => item['id_produk'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil dihapus')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus produk')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getdata(); // Ambil data produk saat halaman pertama kali dibuka
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
                _getdata(); // Memperbarui data produk setelah menambahkan produk
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              // Mengonversi data produk dari Map ke List<Produk>
              exportprodukToPDF(context, _listdata.map((item) => Produk.fromMap(item)).toList());
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _listdata.length,
              itemBuilder: (context, index) {
                var harga = _listdata[index]['harga_produk'];
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
                            produk: _listdata[index], // Menyesuaikan dengan parameter produk
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
                                    produk: Produk.fromMap(_listdata[index]),
                                  ),
                                ),
                              ).then((_) {
                                _getdata(); // Memperbarui data setelah perubahan
                              });
                            },
                            icon: const Icon(Icons.edit, color: Colors.teal),
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
                                    content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Menutup dialog
                                        },
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _hapus(_listdata[index]['id_produk']).then((_) {
                                            Navigator.of(context).pop(); // Menutup dialog
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
        currentIndex: 0,
        selectedItemColor: Colors.teal,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HalamanSupplier()),
            );
          }
        },
      ),
    );
  }
}