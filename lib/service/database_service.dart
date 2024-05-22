import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_database_crud/models/task.dart';

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

  Future<List<Task>> getTaskList() async {
    final db = await database;
    final tasks = await db.query(_tableName);
    final taskList = tasks
        .map((e) => Task(
            id: e['id'] as int,
            content: e['content'] as String,
            status: e['status'] as int))
        .toList();
    return taskList;
  }

  void updateTask(int id, int status) async {
    final db = await database;
    db.update(
      _tableName,
      {_taskStatusColumnName: status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  void deleteTask(int id) async {
    final db = await database;
    db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
