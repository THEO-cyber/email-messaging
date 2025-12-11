import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/email_models.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'emails.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE emails(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            toEmail TEXT,
            cc TEXT,
            subject TEXT,
            body TEXT,
            timestamp TEXT,
            isSent INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertEmail(Email email) async {
    final db = await database;
    try {
      return await db.insert('emails', email.toMap());
    } catch (e) {
      print('Error inserting email: $e');
      return -1; // or handle the error as needed
    }
  }

  Future<List<Email>> getSentEmails() async {
    final db = await database;
    final maps = await db.query(
      'emails',
      where: 'isSent = 1',
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) => Email.fromMap(maps[i]));
  }

  Future<List<Email>> getReceivedEmails() async {
    final db = await database;
    final maps = await db.query(
      'emails',
      where: 'isSent = 0',
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) => Email.fromMap(maps[i]));
  }
}
