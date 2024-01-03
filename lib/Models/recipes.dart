
import 'dart:convert';

import 'package:etc_claudel/Models/recipesIngredients.dart';

class Recipes {
   int? id;
   String name;
   String type;
   String description;
   String imagePath;

   String idUser;


    Recipes({
    this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.imagePath,
 
    required this.idUser,
  });

 Map<String, dynamic> toMap() {
  return {
    'id': id,
    'name': name,
    'type': type,
    'description': description,
    'imagePath': imagePath,
    
    'idUser': idUser,
  };
}

  Recipes.fromMap(Map<String, dynamic> RecipesMap):
        this.id = RecipesMap['id'],
        this.name = RecipesMap['name'],
        this.type = RecipesMap['type'],
        this.description = RecipesMap['description'],
        this.imagePath = RecipesMap['imagePath'],
      
        this.idUser = RecipesMap['idUser'];

  @override
  String toString() {
    return 'Message{id: $id, name: $name,  type: $type, description: $description,  imagePath: $imagePath,  idUser: $idUser}';
  }
}
