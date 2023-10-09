import 'package:contact_hub/models/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  DatabaseHelper.internal();

  Future<Database> initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'contacts.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int newVersion) async {
        await db.execute('''
          CREATE TABLE contacts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT,
          phone TEXT,
          imagePath TEXT
          )
        ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
      },
    );
  }

  Future<int> saveContact(Contact contact) async {
    final dbClient = await db;
    return await dbClient!.insert('contacts', contact.toMap());
  }

  Future<List<Contact>> getContacts() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient!.query('contacts');
    return List.generate(maps.length, (i) {
      return Contact.fromMap(maps[i]);
    });
  }

  Future<int> updateContact(Contact contact) async {
    final dbClient = await db;
    return await dbClient!.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final dbClient = await db;
    return await dbClient!.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final dbClient = await db;
    dbClient!.close();
  }
}
