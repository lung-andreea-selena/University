import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/project.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'projects_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE projects(
        id INTEGER PRIMARY KEY,
        name TEXT,
        team TEXT,
        details TEXT,
        status TEXT,
        members INTEGER,
        type TEXT
      )
    ''');
  }

  Future<List<Project>> getProjects() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('projects');
    return List.generate(maps.length, (i) {
      return Project.fromJson(maps[i]);
    });
  }

  Future<Project?> getProjectById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'projects',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Project.fromJson(maps.first);
    }
    return null;
  }

  Future<void> insertProject(Project project) async {
    final db = await database;
    await db.insert('projects', project.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateProject(Project project) async {
    final db = await database;
    await db.update(
      'projects',
      project.toJson(),
      where: 'id = ?',
      whereArgs: [project.id],
    );
  }

  Future<void> deleteProject(int id) async {
    final db = await database;
    await db.delete(
      'projects',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('projects');
  }
}
