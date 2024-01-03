import 'package:etc_claudel/Models/ingredients.dart';
import 'package:sqflite/sqflite.dart';

import '../DataBase/database.dart';


class IngredientsController {
 
  Future<List<Ingredients>> getAllIngredients() async {
    DatabaseHandler _dbHandler = DatabaseHandler();
    List<Map<String, dynamic>> ingredientsListMap = await _dbHandler.database!.query("Ingredients");

    return ingredientsListMap.map((i) => Ingredients.fromMap(i)).toList();
  }

  Future<Ingredients?> getIngredientById(int id) async {
    DatabaseHandler _dbHandler = DatabaseHandler();
    List<Map<String, dynamic>> ingredientListMap = await _dbHandler.database!.query(
      "Ingredients",
      where: "id = ?",
      whereArgs: [id],
    );

    if (ingredientListMap.isNotEmpty) {
      return Ingredients.fromMap(ingredientListMap.first);
    } else {
      return null;
    }
  }

   Future<List<String>> getAllTypes() async {
  DatabaseHandler _dbHandler = DatabaseHandler();
  List<Map<String, dynamic>> types = await _dbHandler.database!.query(
    'Ingredients',
    distinct: true,
    columns: ['type'],
  );

  List<String> uniqueTypes = types.map((type) => type['type'].toString()).toList();
  return uniqueTypes;
}

    Future<Ingredients?> getIngredientByName(String name) async {
    DatabaseHandler _dbHandler = DatabaseHandler();
    List<Map<String, dynamic>> ingredientListMap = await _dbHandler.database!.query(
      "Ingredients",
      where: "name = ?",
      whereArgs: [name],
    );

    if (ingredientListMap.isNotEmpty) {
      return Ingredients.fromMap(ingredientListMap.first);
    } else {
      return null;
    }
  }

 Future<void> addIngredients(Ingredients ingredients) async {
    DatabaseHandler _dbHandler = DatabaseHandler();
    await _dbHandler.database!.insert(
      "Ingredients",
      ingredients.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteIngredients(int id) async {
    DatabaseHandler _dbHandler = DatabaseHandler();
    await _dbHandler.database!.delete(
      "Ingredients",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateIngredients(Ingredients ingredients) async {
    DatabaseHandler _dbHandler = DatabaseHandler();
    await _dbHandler.database!.update(
      "Ingredients",
      ingredients.toMap(),
      where: "id = ?",
      whereArgs: [ingredients.id],
    );
  }
}