class Ingredients{

 int? id;
 String name;
 String type;


 Ingredients (
 {this.id, required this.name, required this.type});

Map<String, dynamic> toMap(){

  return{
      'id' : id,
      'name' : name,
      'type' : type
  };
} 

Ingredients.fromMap(Map<String, dynamic> ingrdientMap):
  this.id = ingrdientMap['id'],
  this.name = ingrdientMap['name'],
  this.type = ingrdientMap['type'];

  @override 
  String toString()
  {
    return 'Message{id: $id, name: $name, type: $type}';
  }


}