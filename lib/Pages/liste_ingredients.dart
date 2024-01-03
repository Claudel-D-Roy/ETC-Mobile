import 'package:etc_claudel/ControleursSqflite/ingredient_controleur.dart';
import 'package:etc_claudel/Models/ingredients.dart';
import 'package:etc_claudel/Providers/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class IngredientsList extends StatefulWidget {
  final String category;

  const IngredientsList({Key? key, required this.category}) : super(key: key);

  @override
  State<IngredientsList> createState() => _IngredientsListState();
}

class _IngredientsListState extends State<IngredientsList> {
  late IngredientsController _ingredientsController;
  late List<Ingredients> filteredIngredients = [];
  late DarkThemeProvider themeState;
  bool get _isDark => themeState.getDarkTheme;
  @override
  void initState() {
    super.initState();
      themeState = Provider.of<DarkThemeProvider>(context, listen: false);

    _ingredientsController = IngredientsController();
    _filterIngredients();
  }

  void _filterIngredients() async {
    List<Ingredients> ingredientsList = await _ingredientsController.getAllIngredients();
    setState(() {
      filteredIngredients = ingredientsList.where((ingredient) => ingredient.type == widget.category).toList();
    });
  }

  Future<void> _showAddIngredientDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return _AddIngredientDialog(category: widget.category, ingredientsController: _ingredientsController);
      },
    );

    _filterIngredients();
  }


  @override
  Widget build(BuildContext context) {
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: _isDark ? Colors.black: Colors.white,
      appBar: AppBar(
          foregroundColor:  _isDark ? Colors.white: Colors.black,  
        backgroundColor: _isDark ? Colors.black: Colors.white,
        title: Text('Liste des ingrédients - ${widget.category}', style: TextStyle(color: color)),
      ),
      body: _buildIngredientsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddIngredientDialog();
        }, backgroundColor: _isDark ? Colors.grey[600] : Colors.blueGrey,
        tooltip: 'Ajouter un ingrédient',
        child: const Icon(Icons.add),
      ),
    );
  }

Widget _buildIngredientsList() {
      final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
  if (filteredIngredients.isEmpty) {
    return Center(
      child: Text('Aucun ingrédient trouvé pour la catégorie ${widget.category}.', style: TextStyle(color: color)),
    );
  }

  filteredIngredients.sort((a, b) => a.name.compareTo(b.name));

  return ListView.builder(
    itemCount: filteredIngredients.length,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text(filteredIngredients[index].name, style: TextStyle(color: color)),
      );
    },
  );
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