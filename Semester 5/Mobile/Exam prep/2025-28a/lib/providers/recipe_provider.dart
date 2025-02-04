import 'package:flutter/material.dart';


import '../models/recipe.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';

class RecipeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final RecipeDatabaseHelper _dbHelper = RecipeDatabaseHelper();
  List<Recipe> _recipes = [];
  Recipe? _selectedRecipe;
  bool _isLoading = false;
  String? _errorMessage;

  List<Recipe> get recipes => _recipes;
  Recipe? get selectedRecipe => _selectedRecipe;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRecipes() async {
    _setLoading(true);
    _clearErrorMessage();
    try {
      _recipes = await _apiService.fetchRecipes();
      notifyListeners();
    } catch (e) {
      _setErrorMessage('Failed to fetch recipes. Displaying offline data if available.');
      _recipes = await _dbHelper.getRecipes(); // Load from local DB on error
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchRecipeById(int id) async {
    _setLoading(true);
    _clearErrorMessage();
    _selectedRecipe = null; // Clear previous selected recipe
    try {
      _selectedRecipe = await _apiService.fetchRecipeById(id);
      if (_selectedRecipe == null) {
        _setErrorMessage('Recipe not found on server. Displaying offline data if available.');
        _selectedRecipe = await _dbHelper.getRecipe(id); // Load from local DB if not found online
      }
      notifyListeners();
    } catch (e) {
      _setErrorMessage('Failed to fetch recipe details. Displaying offline data if available.');
      _selectedRecipe = await _dbHelper.getRecipe(id); // Load from local DB on error
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }


  Future<void> addRecipe(Recipe recipe) async {
    _setLoading(true);
    _clearErrorMessage();
    try {
      final newRecipe = await _apiService.addRecipe(recipe);
      _recipes.add(newRecipe); // Optimistically update local list
      notifyListeners();
    } catch (e) {
      _setErrorMessage('Failed to add recipe.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteRecipe(int id) async {
    _setLoading(true);
    _clearErrorMessage();
    try {
      await _apiService.deleteRecipe(id);
      _recipes.removeWhere((recipe) => recipe.id == id); // Optimistically update local list
      notifyListeners();
    } catch (e) {
      _setErrorMessage('Failed to delete recipe.');
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Recipe>> fetchAllRecipesForAnalysis() async {
    _setLoading(true);
    _clearErrorMessage();
    try {
      return await _apiService.fetchAllRecipes();
    } catch (e) {
      _setErrorMessage('Failed to fetch recipes for analysis.');
      return [];
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}