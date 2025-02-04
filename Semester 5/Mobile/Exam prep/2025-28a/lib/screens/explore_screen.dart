import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';

// Explore Section
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  ExploreScreenState createState() => ExploreScreenState();
}

class ExploreScreenState extends State<ExploreScreen> {
  List<MonthlyRating> monthlyRatings = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMonthlyRatings();
    });
  }

  Future<void> _loadMonthlyRatings() async {
    final recipes = await Provider.of<RecipeProvider>(context, listen: false)
        .fetchAllRecipesForAnalysis();
    if (recipes.isNotEmpty) {
      monthlyRatings = _calculateMonthlyRatings(recipes);
    } else {
      monthlyRatings = []; // Or handle error/empty case differently
    }
    setState(() {}); // Trigger UI update after data is loaded
  }

  List<MonthlyRating> _calculateMonthlyRatings(List<Recipe> recipes) {
    Map<String, MonthlyRating> monthlyRatingMap = {};
    for (var recipe in recipes) {
      String monthYear = recipe.date.substring(0, 7); // YYYY-MM
      if (monthlyRatingMap.containsKey(monthYear)) {
        monthlyRatingMap[monthYear]!.totalRating += recipe.rating;
        monthlyRatingMap[monthYear]!.recipeCount++;
      } else {
        monthlyRatingMap[monthYear] = MonthlyRating(
            monthYear: monthYear, totalRating: recipe.rating, recipeCount: 1);
      }
    }

    List<MonthlyRating> calculatedRatings = monthlyRatingMap.values.toList();
    for (var monthlyRating in calculatedRatings) {
      monthlyRating.averageRating =
          monthlyRating.totalRating / monthlyRating.recipeCount;
    }

    calculatedRatings.sort((a, b) =>
        b.monthYear.compareTo(a.monthYear)); // Descending order by month
    return calculatedRatings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Rating Analysis')),
      body: Consumer<RecipeProvider>(
        builder: (context, recipeProvider, child) {
          if (recipeProvider.isLoading && monthlyRatings.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (recipeProvider.errorMessage != null && monthlyRatings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(recipeProvider.errorMessage!),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _loadMonthlyRatings();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (monthlyRatings.isEmpty) {
            return const Center(child: Text('No ratings data available.'));
          }
          return ListView.builder(
            itemCount: monthlyRatings.length,
            itemBuilder: (context, index) {
              final monthlyRating = monthlyRatings[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Month: ${monthlyRating.monthYear}',
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(
                          'Average Rating: ${monthlyRating.averageRating.toStringAsFixed(2)}'),
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

class MonthlyRating {
  String monthYear;
  double totalRating;
  int recipeCount;
  double averageRating = 0; // Initialize

  MonthlyRating(
      {required this.monthYear,
        required this.totalRating,
        required this.recipeCount});
}