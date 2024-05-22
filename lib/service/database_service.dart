import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();
  static const String _dbName = 'notes.db';
  static const String _tableName = 'tasks';
  static const String _taskIdColumnName = 'id';
  static const String _taskContentColumnName = 'content';
  static const String _taskStatusColumnName = 'status';

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, _dbName);
    final database =
        await openDatabase(databasePath, version: 1, onCreate: (db, version) {
      db.execute('''
          CREATE TABLE $_tableName (
          $_taskIdColumnName INTEGER PRIMARY KEY,
          $_taskContentColumnName TEXT NOT NULL,
          $_taskStatusColumnName INTEGER NOT NULL
          )
          ''');
    });
    return database;
  }

  void insertTask(String content) async {
    final db = await database;
    db.insert(_tableName,
        {_taskContentColumnName: content, _taskStatusColumnName: 0});
  }
}
