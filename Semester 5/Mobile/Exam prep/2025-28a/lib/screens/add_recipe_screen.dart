import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';

// Add Recipe Screen
class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  AddRecipeScreenState createState() => AddRecipeScreenState();
}

class AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _categoryController = TextEditingController();
  final _ratingController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _ingredientsController.dispose();
    _categoryController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  /// Opens the date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Recipe')),
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
                      // Date Picker Field
                      TextFormField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Select Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                          text: _selectedDate != null
                              ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                              : '',
                        ),
                        onTap: () => _selectDate(context),
                        validator: (value) {
                          if (_selectedDate == null) {
                            return 'Please select a date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final recipe = Recipe(
                              id: -1, // Server will assign ID
                              date: DateFormat('yyyy-MM-dd').format(_selectedDate!),
                              title: _titleController.text,
                              ingredients: _ingredientsController.text,
                              category: _categoryController.text,
                              rating: double.parse(_ratingController.text),
                            );
                            recipeProvider.addRecipe(recipe).then((_) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Recipe added successfully!')),
                              );
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to add recipe: $error')),
                              );
                            });
                          }
                        },
                        child: const Text('Add Recipe'),
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
