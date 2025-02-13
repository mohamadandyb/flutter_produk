class Produk {
  final int? id_produk; // ID ini akan diisi saat objek dibaca dari database
  final String nama_produk;
  final int harga_produk;

  // Constructor
  Produk({
    this.id_produk,
    required this.nama_produk,
    required this.harga_produk,
  });

  // Konversi objek ke Map
  Map<String, dynamic> toMap() {
    return {
      'nama_produk': nama_produk,
      'harga_produk': harga_produk,
    };
  }

  // Mengonversi Map ke objek produk
  factory Produk.fromMap(Map<String, dynamic> map) {
    return Produk(
      id_produk: map['id_produk'],  // Mengambil ID dari Map
      nama_produk: map['nama_produk'],
      harga_produk: map['harga_produk'],
    );
  }
}