import 'role.dart';

class Utilisateur {
  final String id;
  final String nom;

  final List<Role> roles;

  const Utilisateur (this.id, this.nom, this.roles);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom
    };
  }

  Utilisateur.fromMap(Map<String, dynamic> utilisateurMap, List<Role> listRoles):
        this.id = utilisateurMap['id'],
        this.nom = utilisateurMap['nom'],
        this.roles = listRoles;

  @override
  String toString() {
    return 'Message{id: $id, nom: $nom, rôles: {${roles.map((r) => r.toString()).join(", ")}}}';
  }
}
