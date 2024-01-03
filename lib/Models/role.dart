

class Role {
  final int? id;
  final String idUtilisateur;
  final String role;

  const Role (this.id, this.idUtilisateur, this.role);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_utilisateur': idUtilisateur,
      'role': role
    };
  }

  Role.fromMap(Map<String, dynamic> roleMap):
        this.id = roleMap['id'],
        this.idUtilisateur = roleMap['id_utilisateur'],
        this.role = roleMap['role'];

  @override
  String toString() {
    return 'Message{id: $id, id utilisateur: $idUtilisateur, role: $role}';
  }
}
