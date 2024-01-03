import 'package:etc_claudel/DataBase/database.dart';
import 'package:etc_claudel/Models/recipes.dart';
import 'package:etc_claudel/Models/recipesIngredients.dart';
import 'package:sqflite/sqflite.dart';

class RecipesIngredientsController {
 
   Future<void> addRecipesIngredients(int recipeId, List<RecipesIngredients> updatedIngredients) async {
      DatabaseHandler _dbHandler = DatabaseHandler();
    try {




        for (RecipesIngredients ingredient in updatedIngredients) {
      await _dbHandler.database!.insert(
        'RecipesIngredients',
        {
          'recipeId': recipeId,
          'name': ingredient.name,
          'quantity': ingredient.quantity,
        },
      );
    }
    } catch (e) {
      print('Error adding recipes ingredients: $e');
    }
  }

  Future<void> updateRecipesIngredients(RecipesIngredients recipesing) async {
    DatabaseHandler _dbHandler = DatabaseHandler();
    try {
      await _dbHandler.database!.update(
        'RecipesIngredients',
        recipesing.toMap(),
        where: 'id = ?',
        whereArgs: [recipesing.id],
      );
    } catch (e) {
      print('Error updating recipes ingredients: $e');
    }
  }

  Future<void> deleteRecipesIngredients(int id) async {
     DatabaseHandler _dbHandler = DatabaseHandler();
    try {
      await _dbHandler.database!.delete(
        'RecipesIngredients',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting recipes ingredients: $e');
    }
  }

  Future<List<RecipesIngredients>> getIngredientsForRecipe(int recipeId) async {
     DatabaseHandler _dbHandler = DatabaseHandler();
    try {
      final List<Map<String, dynamic>> maps = await _dbHandler.database!.query(
        'RecipesIngredients',
        where: 'recipeId = ?',
        whereArgs: [recipeId],
      );
      return List.generate(maps.length, (i) {
        return RecipesIngredients.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error getting recipes ingredients: $e');
      return [];
    }
  }

Future<void> deleteIngredientsForRecipe(int recipeId) async {
  DatabaseHandler _dbHandler = DatabaseHandler();
  try {
    // Supprimer les RecipesIngredients associés à la recette
    await _dbHandler.database!.delete(
      'RecipesIngredients',
      where: 'recipeId = ?',
      whereArgs: [recipeId],
    );
  } catch (e) {
    print('Error deleting recipes ingredients: $e');
  }
}

Future<void> updateIngredientsForRecipe(int recipeId, List<RecipesIngredients> updatedIngredients) async {
  DatabaseHandler _dbHandler = DatabaseHandler();
  try {
    // Supprimer les RecipesIngredients associés à la recette
    await _dbHandler.database!.delete(
      'RecipesIngredients',
      where: 'recipeId = ?',
      whereArgs: [recipeId],
    );

    // Insérer les nouvelles RecipesIngredients
    for (RecipesIngredients ingredient in updatedIngredients) {
      await _dbHandler.database!.insert(
        'RecipesIngredients',
        {
          'recipeId': recipeId,
          'name': ingredient.name,
          'quantity': ingredient.quantity,
        },
      );
    }
  } catch (e) {
    print('Error updating recipes ingredients: $e');
  }
}
}




  