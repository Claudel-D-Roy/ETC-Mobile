import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:etc_claudel/ControleursSqflite/role_controleur.dart';
import 'package:etc_claudel/Models/role.dart';
import 'package:etc_claudel/DataBase/database.dart';

// Mock DatabaseHandler
class MockDatabaseHandler extends Mock implements DatabaseHandler {}

void main() {
  group('RoleControleur Tests', () {
    late MockDatabaseHandler mockDatabaseHandler;
    late RoleControleur roleControleur;

    setUp(() {
      mockDatabaseHandler = MockDatabaseHandler();
      roleControleur = RoleControleur();
    });

    test('Get roles by id utilisateur', () async {
      final idUtilisateur = 'userId';

      final roleListMap = [
        {'id': 1, 'id_utilisateur': idUtilisateur, 'nom': 'Role1'},
        {'id': 2, 'id_utilisateur': idUtilisateur, 'nom': 'Role2'},
      ];

      final expectedRoles = roleListMap.map((r) => Role.fromMap(r)).toList();

      when(mockDatabaseHandler.database!.query(
        'Role',
        where: 'id_utilisateur = ?',
        whereArgs: [idUtilisateur],
      )).thenAnswer((_) async => roleListMap);

      final result = await roleControleur.getRolesByIdUtilisateur(idUtilisateur);

      expect(result, equals(expectedRoles));

      verify(mockDatabaseHandler.database!.query(
        'Role',
        where: 'id_utilisateur = ?',
        whereArgs: [idUtilisateur],
      ));
    });

    test('Get roles by id utilisateur with empty result', () async {
      final idUtilisateur = 'userId';

      when(mockDatabaseHandler.database!.query(
        'Role',
        where: 'id_utilisateur = ?',
        whereArgs: [idUtilisateur],
      )).thenAnswer((_) async => []);

      final result = await roleControleur.getRolesByIdUtilisateur(idUtilisateur);

      expect(result, isEmpty);

      verify(mockDatabaseHandler.database!.query(
        'Role',
        where: 'id_utilisateur = ?',
        whereArgs: [idUtilisateur],
      ));
    });
  });
}