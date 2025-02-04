import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/recipe.dart';



// Database Helper (SQLite)
class RecipeDatabaseHelper {
  static Database? _database;

  //ensure only one database instance is created (singleton pattern)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'recipe_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recipes(
        id INTEGER PRIMARY KEY,
        date TEXT,
        title TEXT,
        ingredients TEXT,
        category TEXT,
        rating REAL
      )
    ''');
  }

  Future<List<Recipe>> getRecipes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipes');
    return List.generate(maps.length, (i) {
      return Recipe.fromJson(maps[i]);
    });
  }

  Future<Recipe?> getRecipe(int id) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Recipe.fromJson(maps.first);
    }
    return null;
  }

  //if a recipe with the same id exists, it replaces the old entry (ConflictAlgorithm.replace)
  Future<void> insertRecipe(Recipe recipe) async {
    final db = await database;
    await db.insert('recipes', recipe.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteRecipe(int id) async {
    final db = await database;
    await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('recipes');
  }
}