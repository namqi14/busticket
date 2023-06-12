import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:busticket/models/users.dart';

class DatabaseService {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, 'busservices.db');
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );

    bool indexExists = await _indexExists(database, 'busticket', 'idx_user_id');
    if (!indexExists) {
      await database.execute('CREATE INDEX idx_user_id ON busticket(user_id)');
    }

    return database;
  }

  Future<bool> _indexExists(
      Database database, String table, String index) async {
    var result = await database.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'index' AND tbl_name = '$table' AND name = '$index'",
    );
    return result.isNotEmpty;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        f_name TEXT NOT NULL,
        l_name TEXT NOT NULL,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        mobilehp TEXT NOT NULL
      )
      ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS busticket (
        book_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        depart_date DATE NOT NULL,
        time TIME NOT NULL,
        depart_station TEXT NOT NULL,
        dest_station TEXT NOT NULL,
        user_id INTEGER NOT NULL
      )
      ''');
  }

  Future<bool> insertUser(Users users) async {
    final db = await this.db;
    var data = users.toMap();
    try {
      print('Inserting User: $users');
      await db?.insert(
        'users',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('User Inserted Successfully');
      return true;
    } catch (error) {
      print('Failed to Insert User: $error');
      return false;
    }
  }

  Future<Users?> getUsers(String username, String password) async {
    final db = await this.db;
    var res = await db?.rawQuery('''
      SELECT *
      FROM `users`
      WHERE username = ? AND password = ?
      ''', [username, password]);

    if (res!.isNotEmpty) {
      var firstResult = res.first;
      return Users.fromMap({
        'user_id': firstResult['user_id'],
        'f_name': firstResult['f_name'],
        'l_name': firstResult['l_name'],
        'username': firstResult['username'],
        'password': firstResult['password'],
        'mobilehp': firstResult['mobilehp'],
      });
    }

    return null;
  }

  Future<List<Users>> getAllUsers() async {
    final db = await this.db;
    var res = await db?.query('users');

    if (res!.isNotEmpty) {
      return res.map((userMap) => Users.fromMap(userMap)).toList();
    }

    return [];
  }

  Future<bool> updateUsers(Users users) async {
    final db = await this.db;
    var data = users.toMap();
    try {
      await db!.update(
        'users',
        data,
        where: 'user_id = ?',
        whereArgs: [users.userID],
      );

      return true;
    } catch (error) {
      print('Failed to update users : $error');
      return false;
    }
  }

  Future<bool> removeUser(int userID) async {
    final db = await this.db;
    try {
      await db!.delete(
        'users',
        where: 'user_id = ?',
        whereArgs: [userID],
      );

      return true;
    } catch (error) {
      print('Failed to remove user : $error');
      return false;
    }
  }

  Future<int?> getCurrentUserID(String username, String password) async {
    final db = await this.db;
    var res = await db?.rawQuery('''
      SELECT user_id
      FROM users
      WHERE username = ? AND password = ?
      ''', [username, password]);

    if (res!.isNotEmpty) {
      return res.first['user_id'] as int;
    }

    return null;
  }
}
