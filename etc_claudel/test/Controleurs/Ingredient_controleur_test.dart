import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:etc_claudel/ControleursSqflite/ingredient_controleur.dart';
import 'package:etc_claudel/Models/ingredients.dart';
import 'package:etc_claudel/DataBase/database.dart';
import 'package:sqflite/sqflite.dart';


// Mock DatabaseHandler
class MockDatabaseHandler extends Mock implements DatabaseHandler {}
void main() {
  group('IngredientsController Tests', () {
    late MockDatabaseHandler mockDatabaseHandler;
    late IngredientsController ingredientControleur;
    late DatabaseHandler databaseHandler;

    setUp(() async {
       mockDatabaseHandler = MockDatabaseHandler();
      ingredientControleur = IngredientsController();
      databaseHandler = DatabaseHandler();
      await databaseHandler.initDb(); 
     
    });
      test('Get all ingredients', () async {
      final ingredientsListMap = [
        {'id': 1, 'name': 'Ingredient1', 'type': 'Type1'},
        {'id': 2, 'name': 'Ingredient2', 'type': 'Type2'},
      ];

      final expectedIngredients = ingredientsListMap.map((i) => Ingredients.fromMap(i)).toList();

      when(mockDatabaseHandler.database!.query('Ingredients')).thenAnswer((_) async => ingredientsListMap);

      final result = await ingredientControleur.getAllIngredients();

      expect(result, equals(expectedIngredients));

   
      verify(mockDatabaseHandler.database!.query('Ingredients'));
    });

    test('Get ingredient by ID', () async {
      final id = 1;
      final ingredientMap = {'id': id, 'name': 'Ingredient1', 'type': 'Type1'};
      final expectedIngredient = Ingredients.fromMap(ingredientMap);

   
      when(mockDatabaseHandler.database!.query('Ingredients', where: 'id = ?', whereArgs: [id]))
          .thenAnswer((_) async => [ingredientMap]);

      final result = await ingredientControleur.getIngredientById(id);

      expect(result, equals(expectedIngredient));

      verify(mockDatabaseHandler.database!.query('Ingredients', where: 'id = ?', whereArgs: [id]));
    });

    test('Get all types', () async {
      final typesListMap = [
        {'type': 'Type1'},
        {'type': 'Type2'},
      ];

      final expectedTypes = typesListMap.map((t) => t['type'].toString()).toList();

      when(mockDatabaseHandler.database!.query('Ingredients', distinct: true, columns: ['type']))
          .thenAnswer((_) async => typesListMap);

      final result = await ingredientControleur.getAllTypes();

      expect(result, equals(expectedTypes));

      verify(mockDatabaseHandler.database!.query('Ingredients', distinct: true, columns: ['type']));
    });

    test('Get ingredient by name', () async {
      final name = 'Ingredient1';
      final ingredientMap = {'id': 1, 'name': name, 'type': 'Type1'};
      final expectedIngredient = Ingredients.fromMap(ingredientMap);

      when(mockDatabaseHandler.database!.query('Ingredients', where: 'name = ?', whereArgs: [name]))
          .thenAnswer((_) async => [ingredientMap]);

      final result = await ingredientControleur.getIngredientByName(name);

      expect(result, equals(expectedIngredient));

    
      verify(mockDatabaseHandler.database!.query('Ingredients', where: 'name = ?', whereArgs: [name]));
    });

    test('Add ingredient', () async {
      final ingredients = Ingredients(id: 1, name: 'Ingredient1', type: 'Type1');

     
      when(mockDatabaseHandler.database!.insert('Ingredients', ingredients.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace))
          .thenAnswer((_) async => 1);

      await ingredientControleur.addIngredients(ingredients);

     
      verify(mockDatabaseHandler.database!
          .insert('Ingredients', ingredients.toMap(), conflictAlgorithm: ConflictAlgorithm.replace));
    });

    test('Delete ingredient', () async {
      final id = 1;

      
      when(mockDatabaseHandler.database!.delete('Ingredients', where: 'id = ?', whereArgs: [id]))
          .thenAnswer((_) async => 1);

      await ingredientControleur.deleteIngredients(id);

      verify(mockDatabaseHandler.database!.delete('Ingredients', where: 'id = ?', whereArgs: [id]));
    });

    test('Update ingredient', () async {
      final ingredients = Ingredients(id: 1, name: 'Ingredient1', type: 'Type1');

     
      when(mockDatabaseHandler.database!.update('Ingredients', ingredients.toMap(),
              where: 'id = ?', whereArgs: [ingredients.id]))
          .thenAnswer((_) async => 1);

      await ingredientControleur.updateIngredients(ingredients);

      verify(mockDatabaseHandler.database!.update('Ingredients', ingredients.toMap(),
          where: 'id = ?', whereArgs: [ingredients.id]));
    });


  });
}