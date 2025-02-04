import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../screens/edit_recipe_screen.dart';

// Recipe Detail Screen
class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  RecipeDetailScreenState createState() => RecipeDetailScreenState();
}

class RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) { // Wrap the fetch call
      Provider.of<RecipeProvider>(context, listen: false).fetchRecipeById(widget.recipeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Details')),
      body: Consumer<RecipeProvider>(
        builder: (context, recipeProvider, child) {
          if (recipeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (recipeProvider.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(recipeProvider.errorMessage!)));
            });
            if (recipeProvider.selectedRecipe == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(recipeProvider.errorMessage!),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        recipeProvider.fetchRecipeById(widget.recipeId);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else {
              // Fallback to showing offline data with error message
              return _buildRecipeDetails(recipeProvider.selectedRecipe!, errorMessage: recipeProvider.errorMessage);
            }
          }
          if (recipeProvider.selectedRecipe == null) {
            return const Center(child: Text('Recipe details not found.'));
          }
          return _buildRecipeDetails(recipeProvider.selectedRecipe!);
        },
      ),
    );
  }

  Widget _buildRecipeDetails(Recipe recipe, {String? errorMessage}) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(recipe.title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              Text('Date: ${recipe.date}'),
              Text('Category: ${recipe.category}'),
              Text('Rating: ${recipe.rating.toStringAsFixed(1)}'),
              const SizedBox(height: 16),
              Text('Ingredients:', style: Theme.of(context).textTheme.titleMedium),
              Text(recipe.ingredients),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditRecipeScreen(recipe: recipe),
                    ),
                  );
                },
                child: const Text('Edit Recipe'),
              ),
            ],
          ),
        ),
        if (errorMessage != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.orangeAccent.withOpacity(0.8),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}