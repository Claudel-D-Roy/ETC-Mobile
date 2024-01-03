

import '../DataBase/database.dart';
import '../Models/role.dart';

class RoleControleur {
  const RoleControleur();

  Future<List<Role>> getRolesByIdUtilisateur(String idUtilisateur) async{
    DatabaseHandler _dbHandler = DatabaseHandler();

    List<Map<String, dynamic>> roleListMap = await _dbHandler.database!.query(
        "Role",
        where: "id_utilisateur = ?",
        whereArgs: [idUtilisateur]);

    return roleListMap.map((r) => Role.fromMap(r)).toList();
  }
}
