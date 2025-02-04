class Recipe {
  int id;
  String date;
  String title;
  String ingredients;
  String category;
  double rating;

  Recipe({
    required this.id,
    required this.date,
    required this.title,
    required this.ingredients,
    required this.category,
    required this.rating,
  });

  //json serialization & deserialization

  //convert json object into a recipe object
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      date: json['date'],
      title: json['title'],
      ingredients: json['ingredients'],
      category: json['category'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
  //converting recipe object to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'title': title,
      'ingredients': ingredients,
      'category': category,
      'rating': rating,
    };
  }
}