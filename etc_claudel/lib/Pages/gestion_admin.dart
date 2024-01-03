import 'package:etc_claudel/ControleursSqflite/ingredient_controleur.dart';
import 'package:etc_claudel/Models/ingredients.dart';
import 'package:etc_claudel/Providers/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GestionIngredient extends StatefulWidget {

  const GestionIngredient({ Key? key }) : super(key: key);
   @override
  State<GestionIngredient> createState() => _GestionIngredientState();
 
}
 
class _GestionIngredientState extends State<GestionIngredient> {
  late IngredientsController ingrdientsControllerBD;
  late List<String> typeIngredients = [];
  late List<Ingredients> ingredientsList = [];
  late List<Ingredients> filteredIngredients = [];
  late List<Ingredients> modifiedIngredients = [];
 late TextEditingController _editingController;

  late DarkThemeProvider themeState;
  bool get _isDark => themeState.getDarkTheme;
  bool isEditing = false;
  List<Ingredients> newIngredient = [];
  
  @override
  void initState() {
    super.initState();
    themeState = Provider.of<DarkThemeProvider>(context, listen: false);
    _loadEvent();
  }

  void _loadEvent() async {
    ingrdientsControllerBD = IngredientsController();
     _editingController = TextEditingController();
    typeIngredients = await ingrdientsControllerBD.getAllTypes();
    ingredientsList = await ingrdientsControllerBD.getAllIngredients();
    setState(() {});
  }


  Future<void> _showAddIngredientDialog(String type) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return _AddIngredientDialog(category: type, ingredientsController: ingrdientsControllerBD);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final Color color = _isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: _isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        foregroundColor: _isDark ? Colors.white : Colors.black,
        backgroundColor: _isDark ? Colors.black : Colors.white,
        title: const Text('Gestion des Ingrédients'),
               actions: [
          IconButton(
            icon: Icon(
              isEditing ? Icons.check : Icons.edit,
              color: color,
            ),
            onPressed: () {
              setState(() {
                if (isEditing) {
                  saveChangesToDatabase();
                }
                isEditing = !isEditing;
              });
            },
          ),
        ],
      ),
  body: ListView.builder(
      itemCount: typeIngredients.length,
      itemBuilder: (BuildContext context, int index) {
        String type = typeIngredients[index];
        List<Ingredients> filteredIngredients = _filterIngredients(type, ingredientsList);
        return ExpansionTile(
          title: Text(
            type,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
         trailing: isEditing
          ? IconButton(
              onPressed: () {
                _showAddIngredientDialog(type);
              },
              icon:const Icon(Icons.add),
              color: _isDark ? Colors.grey[600] : Colors.blueGrey,
              tooltip: 'Ajouter un ingrédient',
            )
          : null,
          children: [   Column(
                children: filteredIngredients.map((ingredient) {
                  TextEditingController editingController =
                      TextEditingController(text: ingredient.name);

                  return ListTile(
                    title: isEditing
                        ? Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: editingController,
                                  style: TextStyle(color: color),
                                )  
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.check,
                                  color: color,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _editingController.text = editingController.text;
                                    saveChangesToModifiedIngredients(
                                        ingredient, _editingController.text);
                                  });
                                },
                              ),
                            ],
                          )
                        : Text(
                            ingredient.name,
                            style: TextStyle(color: color),
                          ),
                    leading: isEditing
                        ? IconButton(
                            icon: Icon(Icons.delete, color: color),
                            onPressed: () {
                              setState(() {
                                deleteIngredient(ingredient);
                              });
                            },
                          )
                        : null,
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  void saveChangesToModifiedIngredients(
      Ingredients ingredient, String newName) {
    setState(() {
      ingredient.name = newName;
      if (!modifiedIngredients.contains(ingredient)) {
        modifiedIngredients.add(ingredient);
      }
    });
  }
  
List<Ingredients> _filterIngredients(
    String type, List<Ingredients> allIngredients) {
  return allIngredients.where((ingredient) => ingredient.type == type).toList();
}


void saveChangesToDatabase() async {
if(newIngredient.isNotEmpty)
{
  for (Ingredients ingredients in newIngredient)
  {
    await ingrdientsControllerBD.addIngredients(ingredients);
  }

  newIngredient.clear();
}


   for (Ingredients ingredient in modifiedIngredients) {

      ingredient.name = _editingController.text;
      await ingrdientsControllerBD.updateIngredients(ingredient);
  }
   modifiedIngredients.clear();

    _loadEvent();
   setState(() {
     
   });
}

void deleteIngredient(Ingredients ingredient) async {

  await ingrdientsControllerBD.deleteIngredients(ingredient.id!);
  setState(() {
    ingredientsList.remove(ingredient);
  });
}

}


class _AddIngredientDialog extends StatefulWidget {
  final String category;
  final IngredientsController ingredientsController;

  const _AddIngredientDialog({Key? key, required this.category, required this.ingredientsController}) : super(key: key);

  @override
  State<_AddIngredientDialog> createState() => _AddIngredientDialogState();
}

class _AddIngredientDialogState extends State<_AddIngredientDialog> {
  late TextEditingController ingredientNameController;
  late bool ingredientExists;
late DarkThemeProvider themeState;
  bool get _isDark => themeState.getDarkTheme;
  @override
  void initState() {
    super.initState();
      themeState = Provider.of<DarkThemeProvider>(context, listen: false);

    ingredientNameController = TextEditingController();
    ingredientExists = false;
  }

  @override
  Widget build(BuildContext context) {
  final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

  return AlertDialog(
    backgroundColor:  _isDark ? Colors.black: Colors.white,
    title: Text('Ajouter un ingrédient', style: TextStyle(color: color)),
    content: Container(
      height: 130.0,
    
      child: Column(
        children: [
          Text('Entrez le nom de l\'ingrédient :', style: TextStyle(color: color)),
          TextField(
            controller: ingredientNameController,
            style: TextStyle(color: color),
            decoration: const InputDecoration(labelText: 'Nom de l\'ingrédient'),
          ),
          if (ingredientExists)
            Wrap(
              children: [
                Text(
                  'Cet ingrédient existe déjà. ',
                  style: TextStyle(color: _isDark ? const Color.fromARGB(255, 255, 4, 0) : Colors.red),
                ),
                Text(
                  'Veuillez entrer un nom différent.',
                  style: TextStyle(color: _isDark ? const Color.fromARGB(255, 255, 4, 0)  : Colors.red),
                ),
              ],
            ),
        ],
      ),
    ),
    actions: <Widget>[
      TextButton(
        child: Text('Annuler',
           style: TextStyle(
        color: color
      ),),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: Text('Ajouter',   style: TextStyle(
        color: color
      ),),
        onPressed: () async {
          String ingredientName = ingredientNameController.text.trim().toLowerCase();
          if (ingredientName.isNotEmpty && !(await _ingredientExists(ingredientName))) {
            widget.ingredientsController.addIngredients(Ingredients(name: ingredientName, type: widget.category));
            Navigator.of(context).pop();
          } else {
            setState(() {
              ingredientExists = true;
            });
          }
        },
      ),
    ],
  );
}

  Future<bool> _ingredientExists(String name) async {
    List<Ingredients> ingredientsList = await widget.ingredientsController.getAllIngredients();
    return ingredientsList.any((ingredient) => ingredient.name.toLowerCase() == name.toLowerCase());
  }
}