
import 'dart:io';
import 'package:etc_claudel/ControleursSqflite/ingredient_controleur.dart';
import 'package:etc_claudel/ControleursSqflite/recipe_controleur.dart';
import 'package:etc_claudel/ControleursSqflite/recipesIngredients_controleur.dart';
import 'package:etc_claudel/Models/recipesIngredients.dart';
import 'package:etc_claudel/Models/ingredients.dart';
import 'package:etc_claudel/Models/recipes.dart';
import 'package:etc_claudel/Pages/widget_camera.dart';
import 'package:etc_claudel/Providers/dark_theme_provider.dart';
import 'package:etc_claudel/Providers/utilisateur_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:etc_claudel/Pages/edit_Ingredient.dart';


class CreationRecipe extends StatefulWidget {
  const CreationRecipe({Key? key}) : super(key: key);

  @override
  State<CreationRecipe> createState() => _CreationRecipeState();
}


class _CreationRecipeState extends State<CreationRecipe> {
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _descriptionController;
  late TextEditingController _ingredientsController;
  late TextEditingController _ingredientsAajouterController;


late RecipesController recipeControllerBD;
late IngredientsController ingredientsControllerBD;
late RecipesIngredientsController recipesIngredientsControllerBD;
late DarkThemeProvider themeState;

  List<Recipes> allRecipes = [];
   List<Ingredients> allIngredient = [];

  String? _imagePath;
  var _idUser;
  
  bool _showIngredientList = false;
  List<RecipesIngredients> _selectedIngredients = [];
  List<bool> _ingredientCheckBoxStates = [];
  bool get _isDark => themeState.getDarkTheme;
  
  @override
  void initState() {
    super.initState();
      themeState = Provider.of<DarkThemeProvider>(context, listen: false);

    _loadEvent();
  }

  void _loadEvent() async {


    recipeControllerBD = RecipesController();
    ingredientsControllerBD = IngredientsController();
    recipesIngredientsControllerBD = RecipesIngredientsController();


    _nameController = TextEditingController();
    _typeController = TextEditingController();
    _descriptionController = TextEditingController();
    _ingredientsController = TextEditingController();
    _ingredientsAajouterController = TextEditingController();



    allIngredient = await ingredientsControllerBD.getAllIngredients();
    allRecipes = await recipeControllerBD.getAllRecipes();
    await Future.delayed(Duration.zero);

      var utilisateurProvider =
        Provider.of<UtilisateurProvider>(context, listen: false);
    if (utilisateurProvider.isLoggedIn && utilisateurProvider.userId != null) {
      setState(() {
        _idUser = utilisateurProvider.userId!;
      });
    }
    


  }

  @override
  Widget build(BuildContext context) {
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
   

    return Scaffold(
      backgroundColor: _isDark ? Colors.black: Colors.white,

      appBar: AppBar(
          foregroundColor:  _isDark ? Colors.white: Colors.black,  
      backgroundColor: _isDark ? Colors.black: Colors.white,
    title: Text('Nouvelle recette'),
    actions: [
      Row(
        children: [
          ElevatedButton(
            onPressed: () {
              _saveNewRecipe();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isDark ? Colors.grey[600] : Colors.white,
            ),
            child: _isDark
                ? Icon(
                    Icons.save,
                    color: Colors.white,
                  )
                : Icon(Icons.save),
          ),
        ],
      )
    ],
  ),
  body: WillPopScope(
    onWillPop: () async {
      if (_showIngredientList) {
        setState(() {
          _showIngredientList = false;
        });
        return false; 
      }
      return true; 
    },
    child: Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(16.0),
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
                  color: color,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  
                ),
              ),
              const SizedBox(height: 16.0),
              _buildEditableField(
                controller: _descriptionController,
                labelText: 'Description de la recette',
                style: TextStyle(color: color,fontSize: 16.0),
              ),
             const SizedBox(height: 16.0),
              
              
               _ingredientsAajouterController.text.isNotEmpty 
            ? _buildBulletedList()
            : Container(),
             const SizedBox(height: 16.0),
              _buildIngredientsList(context),
            ],
          ),
        ),
        _buildBottomSheet(),
      ],
    ),
  )
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
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  Widget _buildPhotoSection(BuildContext context) {

    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WidgetCamera()),
        );

        if (result != null && result is String) {
          setState(() {
            _imagePath = result;
          });
        }
      },
      child: Container(
        height: 200.0,
        width: double.infinity,
        color: _isDark ? Colors.black: Colors.grey[100],
        child: _imagePath != null
            ? Image.file(
                File(_imagePath!),
                height: 200.0,
                width: double.infinity,
                fit: BoxFit.scaleDown,
              )
            : Center(
                child: Text(
                  'Ajouter une photo',
                  style: TextStyle(color: color,fontSize: 18.0),
                ),
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
        _showIngredientList
            ? _buildIngredientGridView(context)
            : _buildIngredientBoxes(context),
      ],
    ),
  );
}

Widget _buildIngredientBoxes(BuildContext context) {
  
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

  Set<String> addedTypes = Set<String>();
  List<Widget> boxes = [];

  for (int i = 0; i < allIngredient.length; i++) {
    final ingredient = allIngredient[i]!;
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
              color: _isDark ? Colors.grey[600]: Colors.blueGrey,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                ingredient.type,
                style: TextStyle(color: color,),
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
          physics:  const NeverScrollableScrollPhysics(), 
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

Widget _buildIngredientGridView(BuildContext context) {

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
                        const SizedBox(width: 6.0),
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
        style: TextStyle(fontSize: 14.0, color: color,),
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

    for (int i = 0; i < allIngredient.length; i++) {
      final ingredient = allIngredient[i]!;
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

  void _saveNewRecipe() async {
  _imagePath ??= "";

  Recipes newRecipe = Recipes(
    name: _nameController.text,
    type: _typeController.text,
    description: _descriptionController.text,
    idUser: _idUser,
    imagePath: _imagePath!

  );


    int recipeId = await recipeControllerBD.addRecipe(newRecipe);



 await recipesIngredientsControllerBD.addRecipesIngredients(recipeId, _selectedIngredients);


  _nameController.clear();
  _typeController.clear();
  _descriptionController.clear();
  _selectedIngredients.clear();
  _imagePath = null;

  setState(() {
    _showIngredientList = false;
  });

  Navigator.pop(context);
}
}