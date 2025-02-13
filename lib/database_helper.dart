import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'produk.dart';
import 'supplier.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('produk.db');
    return _database!;
  }

  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final dbLocation = join(dbPath, path);
    return openDatabase(
      dbLocation,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE produk(
        id_produk INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_produk TEXT,
        harga_produk INTEGER
      );
    ''');
    await db.execute('''
      CREATE TABLE supplier(
        id_supplier INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_supplier TEXT,
        alamat TEXT,
        kontak TEXT
      );
    ''');
  }

  // Fungsi untuk menyimpan produk baru
  Future<int> insertProduk(Produk produk) async {
    final db = await instance.database;
    return await db.insert('produk', produk.toMap());
  }

  // Fungsi untuk mengedit produk
  Future<int> updateProduk(Produk produk) async {
    final db = await instance.database;
    return await db.update(
      'produk',
      produk.toMap(),
      where: 'id_produk = ?',
      whereArgs: [produk.id_produk],
    );
  }

  // Fungsi untuk mengambil semua produk
  Future<List<Map<String, dynamic>>> getAllProduk() async {
    final db = await database;
    return await db.query('produk'); // query produk
  }

  // Fungsi untuk menghapus produk
  Future<int> deleteProduk(int id) async {
    final db = await instance.database;
    return await db.delete(
      'produk',
      where: 'id_produk = ?',
      whereArgs: [id],
    );
  }

  // Create Supplier
  Future<int> insertSupplier(Supplier supplier) async {
    final db = await instance.database;
    return await db.insert('supplier', supplier.toMap());
  }

  // Read all Suppliers
  Future<List<Supplier>> getAllSuppliers() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('supplier');
    return List.generate(maps.length, (i) {
      return Supplier.fromMap(maps[i]);
    });
  }

  // Get a Supplier by id
  Future<Supplier?> getSupplierById(int id) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'supplier',
      where: 'id_supplier = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Supplier.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Update Supplier
  Future<int> updateSupplier(Supplier supplier) async {
    final db = await instance.database;
    return await db.update(
      'supplier',
      supplier.toMap(),
      where: 'id_supplier = ?',
      whereArgs: [supplier.id_supplier],
    );
  }

  // Delete Supplier
  Future<int> deleteSupplier(int id) async {
    final db = await instance.database;
    return await db.delete(
      'supplier',
      where: 'id_supplier = ?',
      whereArgs: [id],
    );
  }
}