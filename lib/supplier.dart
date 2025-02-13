class Supplier {
  final int id_supplier; // Pastikan ini ada
  final String nama;
  final String alamat;
  final String kontak;

  Supplier({
    required this.id_supplier, // Pastikan ini ada sesuai dengan namanya
    required this.nama,
    required this.alamat,
    required this.kontak,
  });

  // Konversi objek Supplier menjadi Map untuk disimpan di SQLite
  Map<String, dynamic> toMap() {
    return {
      'nama_supplier': nama,
      'alamat': alamat,
      'kontak': kontak,
    };
  }

  // Mengonversi Map menjadi objek Supplier
  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      id_supplier: map['id_supplier'],
      nama: map['nama_supplier'],
      alamat: map['alamat'],
      kontak: map['kontak'],
    );
  }
}