class RecipesIngredients {
  int? id;
  int? recipeId;
  String name; 
  String quantity;

  RecipesIngredients({
    this.id,
    this.recipeId,
    required this.name,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipeId': recipeId,
      'name': name,
      'quantity': quantity,
    };
  }

  
  RecipesIngredients.fromMap(Map<String, dynamic> recipesIngredientsMap):
       this.id = recipesIngredientsMap['id'],
       this.recipeId = recipesIngredientsMap['recipeId'],
       this.name = recipesIngredientsMap['name'],
       this.quantity = recipesIngredientsMap['quantity'];

  @override
  String toString() {
    return 'Message{id: $id, recipeId: $recipeId,  name: $name,  quantity: $quantity}';
  }
}

