import 'dart:convert';
import 'dart:developer';

import '../models/recipe.dart';
import 'database_helper.dart';
import 'package:http/http.dart' as http;

const String serverUrl = 'http://192.168.1.132:2528'; // Replace with your server URL

class ApiService {
  final RecipeDatabaseHelper dbHelper = RecipeDatabaseHelper();

  Future<List<Recipe>> fetchRecipes() async {
    log('API Call: GET /recipes');
    try {
      final response = await http.get(Uri.parse('$serverUrl/recipes'));
      if (response.statusCode == 200) {
        final List<dynamic> recipeJsonList = jsonDecode(response.body);
        List<Recipe> recipes = recipeJsonList.map((json) => Recipe.fromJson(json)).toList();

        // Store in local DB
        await dbHelper.clearDatabase(); // Clear old data before storing new data
        for (var recipe in recipes) {
          await dbHelper.insertRecipe(recipe);
        }
        return recipes;
      } else {
        log('API Error: GET /recipes - ${response.statusCode}');
        throw Exception('Failed to load recipes from server');
      }
    } catch (e) {
      log('API Exception: GET /recipes - $e');
      throw Exception('Failed to connect to server');
    }
  }

  Future<Recipe?> fetchRecipeById(int id) async {
    log('API Call: GET /recipe/$id');
    try {
      final response = await http.get(Uri.parse('$serverUrl/recipe/$id'));
      if (response.statusCode == 200) {
        final Recipe recipe = Recipe.fromJson(jsonDecode(response.body));
        await dbHelper.insertRecipe(recipe); // Update local DB
        return recipe;
      } else if (response.statusCode == 404) {
        return null; // Recipe not found on server
      }
      else {
        log('API Error: GET /recipe/$id - ${response.statusCode}');
        throw Exception('Failed to load recipe details from server');
      }
    } catch (e) {
      log('API Exception: GET /recipe/$id - $e');
      throw Exception('Failed to connect to server');
    }
  }

  Future<Recipe> addRecipe(Recipe recipe) async {
    log('API Call: POST /recipe - ${recipe.toJson()}');
    try {
      final response = await http.post(
        Uri.parse('$serverUrl/recipe'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(recipe.toJson()..remove('id')), // Don't send ID for new recipe
      );
      if (response.statusCode == 201) {
        final Recipe newRecipe = Recipe.fromJson(jsonDecode(response.body));
        return newRecipe;
      } else {
        log('API Error: POST /recipe - ${response.statusCode} - ${response.body}');
        throw Exception('Failed to add recipe: ${response.body}');
      }
    } catch (e) {
      log('API Exception: POST /recipe - $e');
      throw Exception('Failed to connect to server');
    }
  }

  Future<Recipe?> deleteRecipe(int id) async {
    log('API Call: DELETE /recipe/$id');
    try {
      final response = await http.delete(Uri.parse('$serverUrl/recipe/$id'));
      if (response.statusCode == 200) {
        await dbHelper.deleteRecipe(id); // Remove from local DB
        return Recipe.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        return null; // Recipe not found on server
      }
      else {
        log('API Error: DELETE /recipe/$id - ${response.statusCode}');
        throw Exception('Failed to delete recipe');
      }
    } catch (e) {
      log('API Exception: DELETE /recipe/$id - $e');
      throw Exception('Failed to connect to server');
    }
  }

  Future<List<Recipe>> fetchAllRecipes() async {
    log('API Call: GET /allRecipes');
    try {
      final response = await http.get(Uri.parse('$serverUrl/allRecipes'));
      if (response.statusCode == 200) {
        final List<dynamic> recipeJsonList = jsonDecode(response.body);
        return recipeJsonList.map((json) => Recipe.fromJson(json)).toList();
      } else {
        log('API Error: GET /allRecipes - ${response.statusCode}');
        throw Exception('Failed to load all recipes');
      }
    } catch (e) {
      log('API Exception: GET /allRecipes - $e');
      throw Exception('Failed to connect to server');
    }
  }
}