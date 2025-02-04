import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';

// Insights Section
class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  InsightsScreenState createState() => InsightsScreenState();
}

class InsightsScreenState extends State<InsightsScreen> {
  List<CategoryRating> categoryRatings = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategoryRatings();
    });
  }

  Future<void> _loadCategoryRatings() async {
    final recipes = await Provider.of<RecipeProvider>(context, listen: false)
        .fetchAllRecipesForAnalysis();
    if (recipes.isNotEmpty) {
      categoryRatings = _calculateCategoryRatings(recipes);
    } else {
      categoryRatings = []; // Or handle error/empty case differently
    }
    setState(() {}); // Trigger UI update
  }

  List<CategoryRating> _calculateCategoryRatings(List<Recipe> recipes) {
    Map<String, CategoryRating> categoryRatingMap = {};
    for (var recipe in recipes) {
      if (categoryRatingMap.containsKey(recipe.category)) {
        categoryRatingMap[recipe.category]!.totalRating += recipe.rating;
      } else {
        categoryRatingMap[recipe.category] = CategoryRating(
            category: recipe.category, totalRating: recipe.rating);
      }
    }

    List<CategoryRating> calculatedRatings = categoryRatingMap.values.toList();
    calculatedRatings.sort((a, b) => b.totalRating
        .compareTo(a.totalRating)); // Descending order by total rating
    return calculatedRatings.take(3).toList(); // Top 3 categories
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top 3 Categories by Rating')),
      body: Consumer<RecipeProvider>(
        builder: (context, recipeProvider, child) {
          if (recipeProvider.isLoading && categoryRatings.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (recipeProvider.errorMessage != null && categoryRatings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(recipeProvider.errorMessage!),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _loadCategoryRatings();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (categoryRatings.isEmpty) {
            return const Center(
                child: Text('No category rating data available.'));
          }

          return ListView.builder(
            itemCount: categoryRatings.length,
            itemBuilder: (context, index) {
              final categoryRating = categoryRatings[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category: ${categoryRating.category}',
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(
                          'Total Rating: ${categoryRating.totalRating.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CategoryRating {
  String category;
  double totalRating;

  CategoryRating({required this.category, required this.totalRating});
}