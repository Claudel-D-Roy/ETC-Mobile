import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:etc_claudel/ControleursSqflite/recipe_controleur.dart';
import 'package:etc_claudel/Models/recipes.dart';
import 'package:etc_claudel/DataBase/database.dart';

class MockDatabaseHandler extends Mock implements DatabaseHandler {}

void main() {
  group('RecipesController Tests', () {
    late MockDatabaseHandler mockDatabaseHandler;
    late RecipesController recipesController;
    late DatabaseHandler databaseHandler;

    setUp(() async{
      mockDatabaseHandler = MockDatabaseHandler();
      recipesController = RecipesController();
        databaseHandler = DatabaseHandler();
        await databaseHandler.initDb(); 
    });

   test('Get all recipes', () async {
      final recipesListMap = [
        {'id': 1, 'name': 'Recipe1', 'idUser': 'user1'},
        {'id': 2, 'name': 'Recipe2', 'idUser': 'user1'},
      ];

      final expectedRecipes = recipesListMap.map((r) => Recipes.fromMap(r)).toList();

      when(mockDatabaseHandler.database!.query('Recipe')).thenAnswer((_) async => recipesListMap);

      final result = await recipesController.getAllRecipes();

      expect(result, equals(expectedRecipes));

      verify(mockDatabaseHandler.database!.query('Recipe'));
    });

    test('Get recipes by user ID', () async {
      final userId = 'user1';
      final recipeListMap = [
        {'id': 1, 'name': 'Recipe1', 'idUser': userId},
        {'id': 2, 'name': 'Recipe2', 'idUser': userId},
      ];

      final expectedRecipes = recipeListMap.map((r) => Recipes.fromMap(r)).toList();

 
      when(mockDatabaseHandler.database!.query('Recipe', where: 'idUser = ?', whereArgs: [userId]))
          .thenAnswer((_) async => recipeListMap);

      final result = await recipesController.getRecipesByUserId(userId);

      expect(result, equals(expectedRecipes));


      verify(mockDatabaseHandler.database!.query('Recipe', where: 'idUser = ?', whereArgs: [userId]));
    });

    test('Update recipe', () async {
      final recipe = Recipes(id: 1, name: 'Recipe1', idUser: 'user1', type: "", description: "", imagePath: "");


      when(mockDatabaseHandler.database!.update('Recipe', recipe.toMap(), where: 'id = ?', whereArgs: [recipe.id]))
          .thenAnswer((_) async => 1);

      await recipesController.updateRecipe(recipe);

     
      verify(mockDatabaseHandler.database!.update('Recipe', recipe.toMap(), where: 'id = ?', whereArgs: [recipe.id]));
    });

    test('Delete recipe', () async {
      final id = 1;

  
      when(mockDatabaseHandler.database!.delete('Recipe', where: 'id = ?', whereArgs: [id]))
          .thenAnswer((_) async => 1);

      await recipesController.deleteRecipe(id);

      verify(mockDatabaseHandler.database!.delete('Recipe', where: 'id = ?', whereArgs: [id]));
    });

    test('Add recipe', () async {
      final recipe = Recipes(id: 1, name: 'Recipe1', idUser: 'user1', type: "", description: "", imagePath: "");

  
      when(mockDatabaseHandler.database!.insert('Recipe', recipe.toMap())).thenAnswer((_) async => 1);

      final result = await recipesController.addRecipe(recipe);

      expect(result, equals(1));


      verify(mockDatabaseHandler.database!.insert('Recipe', recipe.toMap()));
    });


  });
}