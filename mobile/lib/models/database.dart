import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class OfflineDatabase {
  OfflineDatabase._();

  static final OfflineDatabase db = OfflineDatabase._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      print('Database was created.');
      return _database;
    } else {
      print('Database have been created yet.');
      _database = await initDB();
      return _database;
    }
  }

  initDB() async {
    Directory documentsPath = await getApplicationDocumentsDirectory();
    String path = join(documentsPath.path, 'geol_recap.db');
    return openDatabase(
      path,
      version: 1,
      onOpen: (db) async {},
      onCreate: (Database db, int version) async {
        // dictionary
        await db.execute('''
          CREATE TABLE dictionary
          (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              key TEXT NOT NULL,
              value TEXT,
              image_url TEXT
          );
          ''');
      },
    );
  }
}