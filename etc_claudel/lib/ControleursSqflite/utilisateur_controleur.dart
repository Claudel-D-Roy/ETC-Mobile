

import 'package:etc_claudel/ControleursSqflite/role_controleur.dart';
import '../DataBase/database.dart';

import '../Models/role.dart';
import '../Models/utilisateur.dart';

class UtilisateurControleur {
  final RoleControleur _roleControleur = const RoleControleur();

  Future<Utilisateur> getOrInsertUtilisateur(String userId, String? userName) async {
    DatabaseHandler _dbHandler = DatabaseHandler();
    await _dbHandler.initDb();

    var utilisateurMap = await _dbHandler.database!.query(
        "Utilisateur",
        where: "id = ?",
        whereArgs: [userId]);

    if(utilisateurMap.isEmpty) {
      var newUtilisateur = Utilisateur(userId, userName ?? "", List<Role>.empty());

      await _dbHandler.database!.insert("Utilisateur", newUtilisateur.toMap());

      utilisateurMap = await _dbHandler.database!.query(
          "Utilisateur",
          where: "id = ?",
          whereArgs: [userId]);
    }

    List<Role> roles = await _roleControleur.getRolesByIdUtilisateur(userId);

    return Utilisateur.fromMap(utilisateurMap.first, roles);
  }
}
