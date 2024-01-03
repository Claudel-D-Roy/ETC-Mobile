import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:etc_claudel/ControleursSqflite/utilisateur_controleur.dart';
import 'package:etc_claudel/ControleursSqflite/role_controleur.dart';
import 'package:etc_claudel/Models/utilisateur.dart';
import 'package:etc_claudel/Models/role.dart';
import 'package:etc_claudel/DataBase/database.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Mock DatabaseHandler
class MockDatabaseHandler extends Mock implements DatabaseHandler {}

// Mock RoleControleur
class MockRoleControleur extends Mock implements RoleControleur {}

void main() {
  group('UtilisateurControleur Tests', () {
    late MockDatabaseHandler mockDatabaseHandler;
    late MockRoleControleur mockRoleControleur;
    late UtilisateurControleur utilisateurControleur;
    late RoleControleur roleController;

    setUp(() {
      mockDatabaseHandler = MockDatabaseHandler();
      mockRoleControleur = MockRoleControleur();
      utilisateurControleur = UtilisateurControleur();
      roleController = RoleControleur();
    });

    test('Get existing utilisateur from the database', () async {
      final existingUserId = 'existingUserId';
      final existingUserName = 'existingUserName';

      final existingUtilisateur = Utilisateur(existingUserId, existingUserName, []);

      when(mockDatabaseHandler.initDb()).thenAnswer((_) async {});
      when(mockDatabaseHandler.database!.query(
        'Utilisateur',
        where: 'id = ?',
        whereArgs: [existingUserId],
      )).thenAnswer((_) async => [existingUtilisateur.toMap()]);

      when(mockRoleControleur.getRolesByIdUtilisateur(existingUserId)).thenAnswer((_) async => []);

      final result = await utilisateurControleur.getOrInsertUtilisateur(existingUserId, existingUserName);

      expect(result, equals(existingUtilisateur));

      verify(mockDatabaseHandler.initDb());
      verify(mockDatabaseHandler.database!.query(
        'Utilisateur',
        where: 'id = ?',
        whereArgs: [existingUserId],
      ));
      verifyNever(mockDatabaseHandler.database!.insert('Utilisateur', any));
      verify(mockRoleControleur.getRolesByIdUtilisateur(existingUserId));
    });

    test('Insert new utilisateur into the database', () async {
      final newUserId = 'newUserId';
      final newUserName = 'newUserName';

      final newUtilisateur = Utilisateur(newUserId, newUserName, []);


      when(mockDatabaseHandler.initDb()).thenAnswer((_) async {});
      when(mockDatabaseHandler.database!.query(
        'Utilisateur',
        where: 'id = ?',
        whereArgs: [newUserId],
      )).thenAnswer((_) async => []);
      when(mockDatabaseHandler.database!.insert('Utilisateur', newUtilisateur.toMap()))
          .thenAnswer((_) async => 1);

      when(mockRoleControleur.getRolesByIdUtilisateur(newUserId)).thenAnswer((_) async => []);

      final result = await utilisateurControleur.getOrInsertUtilisateur(newUserId, newUserName);

      expect(result, equals(newUtilisateur));

      verify(mockDatabaseHandler.initDb());
      verify(mockDatabaseHandler.database!.query(
        'Utilisateur',
        where: 'id = ?',
        whereArgs: [newUserId],
      ));
      verify(mockDatabaseHandler.database!.insert('Utilisateur', newUtilisateur.toMap()));
      verify(mockRoleControleur.getRolesByIdUtilisateur(newUserId));
    });
  });
}