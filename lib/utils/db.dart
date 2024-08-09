// lib/services/db_service.dart
import 'package:flutter_photo_editor/services/models/image.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBService {
  static Database? _database;
  static final DBService db = DBService._();

  DBService._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'imagesss.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE images (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertImage(ImageModel image) async {
    final db = await database;
    return await db.insert('images', image.toMap());
  }

  Future<List<ImageModel>> getImages() async {
    final db = await database;
    var res = await db.query('images');
    return res.isNotEmpty ? res.map((c) => ImageModel.fromMap(c)).toList() : [];
  }

  Future<int> deleteImage(int id) async {
    final db = await database;
    return await db.delete('images', where: 'id = ?', whereArgs: [id]);
  }
}
