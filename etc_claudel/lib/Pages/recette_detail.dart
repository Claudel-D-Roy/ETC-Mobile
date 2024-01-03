import 'package:etc_claudel/ControleursSqflite/ingredient_controleur.dart';
import 'package:etc_claudel/ControleursSqflite/recipe_controleur.dart';
import 'package:etc_claudel/ControleursSqflite/recipesIngredients_controleur.dart';
import 'package:etc_claudel/Models/recipesIngredients.dart';
import 'package:etc_claudel/Models/ingredients.dart';
import 'package:etc_claudel/Models/recipes.dart';
import 'package:etc_claudel/Pages/edit_Ingredient.dart';
import 'package:etc_claudel/Pages/widget_camera.dart';
import 'package:etc_claudel/Providers/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class RecetteDetail extends StatefulWidget {
  final Recipes recette;
 final VoidCallback refreshRecipes;
  const RecetteDetail({Key? key, required this.recette, required this.refreshRecipes}) : super(key: key);

  @override
  State<RecetteDetail> createState() => _RecetteDetailState();
}

class _RecetteDetailState extends State<RecetteDetail> {

  bool _showIngredientList = false;
  bool isEditing = false;
  late IngredientsController _ingredientControllerBD;
  late RecipesIngredientsController _recipesIngredientsControllerBD;
  late RecipesController _recipesControllerBD;
  late DarkThemeProvider themeState;


 late TextEditingController _nameController;
 late TextEditingController _typeController;
 late TextEditingController _descriptionController;
 late TextEditingController _ingredientsController;
 late TextEditingController _ingredientsAajouterController;


  late  List<RecipesIngredients> _selectedIngredients = [];
  late List<RecipesIngredients> ingredients;
  List<bool> _ingredientCheckBoxStates = [];
  late List<Ingredients> allIngredients = [];
  late List<Ingredients> ingredientsList = [];
  bool get _isDark => themeState.getDarkTheme;

  @override
  void initState() {
      themeState = Provider.of<DarkThemeProvider>(context, listen: false);
    super.initState();
_loadEvent();
  }

  void _loadEvent() async
  {

    _ingredientControllerBD = IngredientsController();
    _recipesIngredientsControllerBD = RecipesIngredientsController();
    _recipesControllerBD = RecipesController();
_nameController = TextEditingController();
 _typeController = TextEditingController();
 _descriptionController = TextEditingController();
 _ingredientsController = TextEditingController();
 _ingredientsAajouterController = TextEditingController();
    ingredientsList = await _ingredientControllerBD.getAllIngredients();
    _selectedIngredients =  await _recipesIngredientsControllerBD.getIngredientsForRecipe(widget.recette.id!);
    setState(() {
      allIngredients = ingredientsList.where((ingredient) => ingredient.type == widget.recette.type).toList();
    });



    _nameController.text = widget.recette.name;
    _typeController.text = widget.recette.type;
    _descriptionController.text = widget.recette.description;
  }


  

  @override
Widget build(BuildContext context) {
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
 return Scaffold(
     backgroundColor: _isDark ? Colors.black: Colors.white,
    appBar: AppBar(
     foregroundColor:  _isDark ? Colors.white: Colors.black,  
      backgroundColor: _isDark ? Colors.black: Colors.white,
      title:const Text('Détails de la recette'),
    actions: [
  IconButton(
    icon: Icon(Icons.delete, color: color),
    onPressed: () {
      _showDeleteConfirmationDialog();
    },
  ),
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
   body: Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildEditableField(
                controller: _nameController,
                labelText: 'Nom de la recette',
                style: TextStyle(color: color,fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
             const SizedBox(height: 16.0),
              _buildPhotoSection(context),
             const SizedBox(height: 16.0),
              _buildEditableField(
                controller: _typeController,
                labelText: 'Type de recette',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                 color: color,
                ),
              ),
              const SizedBox(height: 16.0),
              _buildEditableField(
                controller: _descriptionController,
                labelText: 'Description de la recette',
                style: TextStyle(color: color,fontSize: 16.0),
              ),
             const SizedBox(height: 16.0),
              
        if (!isEditing && _selectedIngredients.isNotEmpty)
          Container(
            margin:const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ingrédients :',
                  style: TextStyle(color: color,fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount:_selectedIngredients.length,
                  itemBuilder: (context, index) {
                    RecipesIngredients ingredient = _selectedIngredients[index];
                    return Padding(
                      padding:const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text('• ${ingredient.name}, ${ingredient.quantity}', style: TextStyle(color: color,fontSize: 16.0)),
                    );
                  },
                ),
              ],
            ),
          ),
        if (isEditing) ...[
         _selectedIngredients.isNotEmpty
              ? _buildBulletedList()
              : Container(),
         const SizedBox(height: 16.0),
          _buildIngredientsList(context),
        ],
            ],
          ),
        ),
        _buildBottomSheet(),
      ],
    ),
    );
}

 
  Widget _buildEditableField({

    required TextEditingController controller,
    required String labelText,
    required TextStyle style,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      style: style,
      maxLines: maxLines,
      enabled: isEditing, 
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  Widget _buildPhotoSection(BuildContext context) {
 

    return GestureDetector(
      onTap: () {
        if (isEditing) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WidgetCamera()),
          ).then((result) {
            if (result != null && result is String) {
              widget.recette.imagePath = result;
              setState(() {});
            }
          });
        }
      },
      child: Container(
        height: 200.0,
        width: double.infinity,
        color:_isDark ? Colors.black: Colors.grey[100],
        child: widget.recette.imagePath != ""
            ? Image.file(
                File(widget.recette.imagePath),
                height: 200.0,
                width: double.infinity,
                fit: BoxFit.scaleDown,
              )
            : Image.asset(
              'assets/images/noImage.jpg',
              height: 60.0,
              width: double.infinity,
              fit: BoxFit.scaleDown,
            ),
      ),
    );
  }


Widget _buildIngredientsList(BuildContext context) {
  final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingrédients',
          style: TextStyle(color: color,fontSize: 16.0),
        ),
        SizedBox(height: _showIngredientList ? 1.0 : 8.0),
        _showIngredientList && isEditing
            ? _buildIngredientGridView()
            : _buildIngredientBoxes(context),
      ],
    ),
  );
}

Widget _buildIngredientBoxes(BuildContext context) {
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
  Set<String> addedTypes = Set<String>();
  List<Widget> boxes = [];

  for (int i = 0; i < ingredientsList.length; i++) {
    final ingredient = ingredientsList[i];
    if (!addedTypes.contains(ingredient.type)) {
      boxes.add(
        GestureDetector(
          onTap: () {
            _handleIngredientBoxClick(ingredient.type);
            setState(() {
              if (!addedTypes.contains(ingredient.type)) {
                _ingredientsController.text += '${ingredient.type}\n';
                addedTypes.add(ingredient.type);
              }
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 3 - 16.0, 
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: BoxDecoration(
              color:_isDark ? Colors.grey[600]: Colors.blueGrey,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                ingredient.type,
                style: TextStyle(color: color),
              ),
            ),
          ),
        ),
      );
      addedTypes.add(ingredient.type);
    }
  }

  return SingleChildScrollView(
    child: Column(
      children: [
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(), 
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0, 
            mainAxisSpacing: 8.0, 
          ),
          itemCount: boxes.length,
          itemBuilder: (BuildContext context, int index) {
            return boxes[index];
          },
        ),
      ],
    ),
  );
}

Widget _buildIngredientGridView() {  
   final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
  return Column(
    children: List.generate(
      _ingredientsController.text.split('\n').length - 1,
      (index) {
        final ingredient = _ingredientsController.text.split('\n')[index];
       
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Checkbox(
                value: _ingredientCheckBoxStates[index],
                onChanged: (bool? value) {
                  setState(() {
                    _ingredientCheckBoxStates[index] = value ?? false;
                  });
                },
              ),
             const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            ingredient,
                            style: TextStyle(color: color,fontSize: 18.0),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                       const SizedBox(width: 36.0),
                        Text(
                          'Quantité',
                          style: TextStyle(color: color,fontSize: 16.0),
                        ),
                       const  SizedBox(width: 6.0),
                        Container(
                            color: _isDark ? Colors.grey[400] : Colors.white,
                          width: 70.0, 
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              
                             _ingredientsAajouterController.text = value.trim();

                            },
                            decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Widget _buildBottomSheet() {
  return Visibility(
    visible: _showIngredientList,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
       children: [
    FloatingActionButton(
      onPressed: () {
        _handleReturnToType(addIngredients: false);
      },
      backgroundColor: _isDark ? Colors.grey[600] : Colors.blueGrey,
      child: const Icon(Icons.keyboard_return),
    ),
    const SizedBox(width: 16.0),
    FloatingActionButton(
      onPressed: () {
        _handleReturnToType(addIngredients: true);
      },
      backgroundColor:  _isDark ? Colors.grey[600] : Colors.blueGrey, 
      child: const Icon(Icons.add),
    ),
  ],
      ),
    ),
  );
}


void _handleReturnToType({required bool addIngredients}) async {
  setState(() {
    if (addIngredients) {
      List<RecipesIngredients> selectedIngredients = [];

      for (int i = 0; i < _ingredientCheckBoxStates.length; i++) {
        if (_ingredientCheckBoxStates[i]) {
          String ingredientName = _ingredientsController.text.split('\n')[i];
          String quantity = _ingredientsAajouterController.text.trim();

     
          RecipesIngredients ingredient = RecipesIngredients(name: ingredientName, quantity: quantity);

          selectedIngredients.add(ingredient);
        }
      }

      _selectedIngredients.addAll(selectedIngredients);
      _ingredientsAajouterController.text =
          _selectedIngredients.map((ingr) => '${ingr.name} - ${ingr.quantity}').join('\n');
      _showIngredientList = false;
    } else {
      _ingredientsAajouterController.text = '';
      _showIngredientList = false;
    }
  });
}

Widget _buildBulletedList() {
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Ingrédients à ajouter',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
              color: color,
        ),
      ),
     const SizedBox(height: 8.0),
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(), 
        shrinkWrap: true,
        itemCount: (_selectedIngredients.length / 2).ceil(),
        itemBuilder: (BuildContext context, int index) {
          final int firstIndex = index * 2;
          final int secondIndex = firstIndex + 1;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildIngredientItem(_selectedIngredients[firstIndex]),
                ),
               const SizedBox(width: 8.0),
                Expanded(
                  child: secondIndex < _selectedIngredients.length
                      ? _buildIngredientItem(_selectedIngredients[secondIndex])
                      : Container(),
                ),
              ],
            ),
          );
        },
      ),
     const SizedBox(height: 8.0),
      Align(
        alignment: Alignment.center,
        child: ElevatedButton(
          onPressed: () {
            _showEditIngredientsDialog();
          },
         style: ElevatedButton.styleFrom(
            backgroundColor: _isDark ? Colors.grey[600] : Colors.blueGrey,
          ),
            child: Text(
    'Modifier',
    style: TextStyle(
      color: color
      
    ),
    ),
        ),
      ),
    ],
  );
}

Widget _buildIngredientItem(RecipesIngredients ingredient) {
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text('• ', style: TextStyle(fontSize: 16.0, color:color)),
          Text(
            ingredient.name,
            style: TextStyle(fontSize: 16.0, color:color),
          ),
        ],
      ),
      const SizedBox(width: 8.0),
      Text(
        '( ${ingredient.quantity} )',
        style: TextStyle(fontSize: 14.0, color:color),
      ),
    ],
  );
}

void _showEditIngredientsDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return EditIngredientsDialog(initialIngredients: List.from(_selectedIngredients));
    },
  ).then((updatedIngredients) {
    if (updatedIngredients != null) {
      setState(() {
        _selectedIngredients = List.from(updatedIngredients);
      });
    }
  });
}

void _handleIngredientBoxClick(String ingredientType) {
  setState(() {
    List<String> ingredientsOfType = [];

    for (int i = 0; i < ingredientsList.length; i++) {
      final ingredient = ingredientsList[i];
      if (ingredient.type == ingredientType) {
        ingredientsOfType.add(ingredient.name);
      }
    }

    _showIngredientList = true;
    
    _ingredientCheckBoxStates = List.generate(ingredientsOfType.length, (index) => false);
    _ingredientsController.text = ingredientsOfType.join('\n') + '\n';
  });


  _ingredientsAajouterController.clear();
}



void saveChangesToDatabase() async {
    widget.recette.name = _nameController.text;
    widget.recette.type = _typeController.text;
    widget.recette.description = _descriptionController.text;
   
  setState(() {
    _showIngredientList = false;
  });

   _recipesIngredientsControllerBD.updateIngredientsForRecipe(widget.recette.id!, _selectedIngredients);
   _recipesControllerBD.updateRecipe(widget.recette); 


    widget.refreshRecipes();
    Navigator.pop(context);

  }
  

void deleteRecipe() async {
  try {
     _recipesIngredientsControllerBD.deleteIngredientsForRecipe(widget.recette.id!);
    _recipesControllerBD.deleteRecipe(widget.recette.id!);
  setState(() {

    });

     widget.refreshRecipes();

    Navigator.pop(context);

  } catch (e) {
    print('Error deleting recipe: $e');
  }
}

  void _showDeleteConfirmationDialog() {
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
               backgroundColor: _isDark ? Colors.black: Colors.white,
          title: Text('Supprimer les recettes sélectionnées', style: TextStyle(color: color)),
          content: Text('Êtes-vous sûr de vouloir supprimer les recettes sélectionnées ?', style: TextStyle(color: color)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
             child: Text('Annuler',
           style: TextStyle(
        color: color
            ),
             )
            ),
            TextButton(
              onPressed: () {
               
                deleteRecipe();
                Navigator.pop(context);
              },
              child: Text('Supprimer',  
               style: TextStyle(
        color: color
      ),
      ),
             ),
          ],
        );
      },
    );
  }
 
}
