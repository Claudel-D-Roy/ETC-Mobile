
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:etc_claudel/ControleursSqflite/recipesIngredients_controleur.dart';
import 'package:etc_claudel/Models/recipesIngredients.dart';
import 'package:etc_claudel/DataBase/database.dart';

// Mock DatabaseHandler
class MockDatabaseHandler extends Mock implements DatabaseHandler {}

void main() {
  group('RecipesIngredientsController Tests', () {
    late MockDatabaseHandler mockDatabaseHandler;
    late RecipesIngredientsController recipesIngredientsController;
    late DatabaseHandler databaseHandler;

    setUp(() async {
      mockDatabaseHandler = MockDatabaseHandler();
      recipesIngredientsController = RecipesIngredientsController();
          databaseHandler = DatabaseHandler();
      await databaseHandler.initDb(); 
    });

   
       test('Add recipes ingredients', () async {
      final recipeId = 1;
      final updatedIngredients = [
        RecipesIngredients(id: 1, recipeId: recipeId, name: 'Ingredient1', quantity: '100g'),
        RecipesIngredients(id: 2, recipeId: recipeId, name: 'Ingredient2', quantity: '200g'),
      ];

      when(mockDatabaseHandler.database!.insert(
        'RecipesIngredients',
        any,
      )).thenAnswer((_) async => 1);

      await recipesIngredientsController.addRecipesIngredients(recipeId, updatedIngredients);

      verify(mockDatabaseHandler.database!.insert(
        'RecipesIngredients',
        any,
      )).called(updatedIngredients.length);
    });

    test('Update recipes ingredients', () async {
      final recipesIngredient = RecipesIngredients(id: 1, recipeId: 1, name: 'Ingredient1', quantity: '150g');

      
      when(mockDatabaseHandler.database!.update(
        'RecipesIngredients',
        recipesIngredient.toMap(),
        where: 'id = ?',
        whereArgs: [recipesIngredient.id],
      )).thenAnswer((_) async => 1);

      await recipesIngredientsController.updateRecipesIngredients(recipesIngredient);

   
      verify(mockDatabaseHandler.database!.update(
        'RecipesIngredients',
        recipesIngredient.toMap(),
        where: 'id = ?',
        whereArgs: [recipesIngredient.id],
      )).called(1);
    });

    test('Delete recipes ingredients', () async {
      final id = 1;

      when(mockDatabaseHandler.database!.delete(
        'RecipesIngredients',
        where: 'id = ?',
        whereArgs: [id],
      )).thenAnswer((_) async => 1);

      await recipesIngredientsController.deleteRecipesIngredients(id);


      verify(mockDatabaseHandler.database!.delete(
        'RecipesIngredients',
        where: 'id = ?',
        whereArgs: [id],
      )).called(1);
    });

    test('Get ingredients for recipe', () async {
      final recipeId = 1;
      final recipesIngredientsList = [
        {'id': 1, 'recipeId': recipeId, 'name': 'Ingredient1', 'quantity': '100g'},
        {'id': 2, 'recipeId': recipeId, 'name': 'Ingredient2', 'quantity': '200g'},
      ];

      final expectedIngredients = recipesIngredientsList.map((i) => RecipesIngredients.fromMap(i)).toList();


      when(mockDatabaseHandler.database!.query(
        'RecipesIngredients',
        where: 'recipeId = ?',
        whereArgs: [recipeId],
      )).thenAnswer((_) async => recipesIngredientsList);

      final result = await recipesIngredientsController.getIngredientsForRecipe(recipeId);

      verify(mockDatabaseHandler.database!.query(
        'RecipesIngredients',
        where: 'recipeId = ?',
        whereArgs: [recipeId],
      )).called(1);

 
      expect(result, equals(expectedIngredients));
    });

    test('Delete ingredients for recipe', () async {
      final recipeId = 1;


      when(mockDatabaseHandler.database!.delete(
        'RecipesIngredients',
        where: 'recipeId = ?',
        whereArgs: [recipeId],
      )).thenAnswer((_) async => 1);

      await recipesIngredientsController.deleteIngredientsForRecipe(recipeId);

      verify(mockDatabaseHandler.database!.delete(
        'RecipesIngredients',
        where: 'recipeId = ?',
        whereArgs: [recipeId],
      )).called(1);
    });

    test('Update ingredients for recipe', () async {
      final recipeId = 1;
      final updatedIngredients = [
        RecipesIngredients(id: 1, recipeId: recipeId, name: 'Ingredient1', quantity: '100g'),
        RecipesIngredients(id: 2, recipeId: recipeId, name: 'Ingredient2', quantity: '200g'),
      ];

      when(mockDatabaseHandler.database!.delete(
        'RecipesIngredients',
        where: 'recipeId = ?',
        whereArgs: [recipeId],
      )).thenAnswer((_) async => 1);

      when(mockDatabaseHandler.database!.insert(
        'RecipesIngredients',
        any,
      )).thenAnswer((_) async => 1);

      await recipesIngredientsController.updateIngredientsForRecipe(recipeId, updatedIngredients);

      verify(mockDatabaseHandler.database!.delete(
        'RecipesIngredients',
        where: 'recipeId = ?',
        whereArgs: [recipeId],
      )).called(1);

      verify(mockDatabaseHandler.database!.insert(
        'RecipesIngredients',
        any,
      )).called(updatedIngredients.length);
    });

  });
}