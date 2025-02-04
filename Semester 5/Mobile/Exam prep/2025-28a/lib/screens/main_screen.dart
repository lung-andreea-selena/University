import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../providers/websocket_provider.dart';
import '../screens/recipe_detail_screen.dart';
import '../screens/add_recipe_screen.dart';

// Main Screen
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Wrap the fetch call
      Provider.of<RecipeProvider>(context, listen: false).fetchRecipes(); //The UI automatically updates if RecipeProvider notifies changes
    });
    Provider.of<WebSocketProvider>(context,
        listen:
        false); // WebSocket provider initialization is likely fine here as it's just setting up a listener, not immediately triggering state changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.explore),
            onPressed: () {
              Navigator.pushNamed(context, '/explore');
            },
          ),
          IconButton(
            icon: const Icon(Icons.insights),
            onPressed: () {
              Navigator.pushNamed(context, '/insights');
            },
          ),
        ],
      ),
      body: Consumer<RecipeProvider>( //consumer listens for data changes in the specified provider, it automatically rebuilds the ui only when the data inside the provider changes
        builder: (context, recipeProvider, child) {
          if (recipeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (recipeProvider.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(recipeProvider.errorMessage!)));
            });

            if (recipeProvider.recipes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(recipeProvider.errorMessage!),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        recipeProvider.fetchRecipes();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else {
              // Fallback to showing offline data with error message
              return _buildRecipeList(recipeProvider.recipes,
                  errorMessage: recipeProvider.errorMessage);
            }
          }
          if (recipeProvider.recipes.isEmpty) {
            return const Center(child: Text('No recipes available.'));
          }//if success
          return _buildRecipeList(recipeProvider.recipes);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRecipeList(List<Recipe> recipes, {String? errorMessage}) {
    return Stack(
      children: [
        ListView.builder(//display recipes dynamically
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return RecipeCard(recipe: recipe);
          },
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
        Consumer<WebSocketProvider>(
          builder: (context, webSocketProvider, child) {
            if (webSocketProvider.newRecipeNotification != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final recipe = webSocketProvider.newRecipeNotification!;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'New recipe added: ${recipe.title} (${recipe.category})'),
                    duration: const Duration(seconds: 3),
                  ),
                );
              });
              return const SizedBox.shrink(); // Render nothing in the UI
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

// Recipe Card Widget
class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recipe.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Category: ${recipe.category}'),
            Text('Rating: ${recipe.rating.toStringAsFixed(1)}'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text('View Details'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecipeDetailScreen(recipeId: recipe.id),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, recipe.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, int recipeId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext dialogContext) {
        // Use dialogContext here!
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this recipe?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Provider.of<RecipeProvider>(context, listen: false)
                    .deleteRecipe(recipeId)
                    .then((_) {
                  Navigator.of(dialogContext).pop(); // close the dialog
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(
                          content:
                          Text('Recipe deleted'))); // Use dialogContext!
                }).catchError((error) {
                  Navigator.of(dialogContext).pop(); // Dismiss the dialog
                  ScaffoldMessenger.of(dialogContext).showSnackBar(SnackBar(
                      content: Text(
                          'Failed to delete recipe: $error'))); // Use dialogContext!
                });
              },
            ),
          ],
        );
      },
    );
  }
}