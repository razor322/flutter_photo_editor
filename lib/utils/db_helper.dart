import 'package:flutter_photo_editor/services/models/image.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'images.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE images(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path TEXT
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
    final List<Map<String, dynamic>> maps = await db.query('images');

    return List.generate(maps.length, (i) {
      return ImageModel.fromMap(maps[i]);
    });
  }

  Future<int> deleteImage(int id) async {
    final db = await database;
    return await db.delete('images', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateImagePath(int imageId, String newPath) async {
    final db = await database;

    return await db.update(
      'images',
      {'path': newPath},
      where: 'id = ?',
      whereArgs: [imageId],
    );
  }
}
