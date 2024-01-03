
import 'dart:convert';

import 'package:etc_claudel/DataBase/database.dart';
import 'package:etc_claudel/Models/recipes.dart';
import 'package:etc_claudel/Models/recipesIngredients.dart';  
import 'package:sqflite/sqflite.dart';

class RecipesController {
 
Future<List<Recipes>> getAllRecipes() async {
  DatabaseHandler _dbHandler = DatabaseHandler();

  List<Map<String, dynamic>> result = await _dbHandler.database!.query('Recipe');

  List<Recipes> recipesList = result.map((map) => Recipes.fromMap(map)).toList();

  return recipesList;
}


  Future<List<Recipes>> getRecipesByUserId(String userId) async {
    DatabaseHandler _dbHandler = DatabaseHandler();
    List<Map<String, dynamic>> recipeListMap = await _dbHandler.database!.query(
      "Recipe",
      where: "idUser = ?",
      whereArgs: [userId],
    );

    return recipeListMap.map((r) => Recipes.fromMap(r)).toList();
  }

 Future<void> updateRecipe(Recipes recipe) async {
  DatabaseHandler _dbHandler = DatabaseHandler();
  
  try {
   
    await _dbHandler.database!.update(
      "Recipe",
      recipe.toMap(),
      where: "id = ?",
      whereArgs: [recipe.id],
    );
  } catch (e) {
    print('Error updating recipe : $e');
  }
}
 Future<void> deleteRecipe(int id) async {
  DatabaseHandler _dbHandler = DatabaseHandler();
  try {

     
    await _dbHandler.database!.delete(
      "Recipe",
      where: "id = ?",
      whereArgs: [id],
    );
  } catch (e) {
    print('Error deleting recipe: $e');
  }
}

Future<int> addRecipe(Recipes recipe) async {
  DatabaseHandler _dbHandler = DatabaseHandler();

  try {
    int id = await _dbHandler.database!.insert('Recipe', recipe.toMap());
    return id;
  } catch (e) {
    print('Error adding recipe: $e');
    // Gérez l'erreur en conséquence
    throw Exception('Failed to add recipe');
  }
}


}