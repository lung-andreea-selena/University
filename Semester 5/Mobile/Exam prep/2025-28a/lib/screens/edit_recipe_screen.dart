import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';

// Edit Recipe Screen
class EditRecipeScreen extends StatefulWidget {
  final Recipe recipe;
  const EditRecipeScreen({super.key, required this.recipe});

  @override
  EditRecipeScreenState createState() => EditRecipeScreenState();
}

class EditRecipeScreenState extends State<EditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _categoryController = TextEditingController();
  final _ratingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.recipe.title;
    _ingredientsController.text = widget.recipe.ingredients;
    _categoryController.text = widget.recipe.category;
    _ratingController.text = widget.recipe.rating.toString();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ingredientsController.dispose();
    _categoryController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Recipe')),
      body: Consumer<RecipeProvider>(
        builder: (context, recipeProvider, child) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _ingredientsController,
                        decoration: const InputDecoration(labelText: 'Ingredients'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter ingredients';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(labelText: 'Category'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter category';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _ratingController,
                        decoration: const InputDecoration(labelText: 'Rating (0.0-5.0)'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter rating';
                          }
                          final rating = double.tryParse(value);
                          if (rating == null || rating < 0 || rating > 5) {
                            return 'Rating must be between 0.0 and 5.0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final recipe = Recipe(
                              id: widget.recipe.id,
                              date: widget.recipe.date, // Keep original date
                              title: _titleController.text,
                              ingredients: _ingredientsController.text,
                              category: _categoryController.text,
                              rating: double.parse(_ratingController.text),
                            );
                            // In a real edit scenario, you would need an UPDATE API call.
                            // For simplicity in this example, we are just going back and not persisting edits.
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit feature not fully implemented in this example (No update API). Data changed locally only.')));
                          }
                        },
                        child: const Text('Save Changes (Edit Not Implemented)'),
                      ),
                    ],
                  ),
                ),
              ),
              if (recipeProvider.isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              if (recipeProvider.errorMessage != null)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.redAccent.withOpacity(0.8),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      recipeProvider.errorMessage!,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}