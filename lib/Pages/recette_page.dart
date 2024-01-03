import 'package:etc_claudel/ControleursSqflite/recipe_controleur.dart';
import 'package:etc_claudel/Models/recipes.dart';
import 'package:etc_claudel/Pages/acceuil_page.dart';
import 'package:etc_claudel/Providers/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:etc_claudel/Providers/utilisateur_provider.dart';
import 'package:etc_claudel/Pages/recette_detail.dart';
import 'dart:io'; 

class CreatedRecipes extends StatefulWidget {
  const CreatedRecipes({Key? key}) : super(key: key);

  @override
  State<CreatedRecipes> createState() => _CreatedRecipesState();
}

class _CreatedRecipesState extends State<CreatedRecipes> {
  
  late RecipesController _recipesControllerBD;
  late String? userId;
  late List<Widget> _recipesItems = [];
  bool isSelectionMode = false;
  List<Recipes> selectedRecipes = [];
  late DarkThemeProvider themeState;
  bool get _isDark => themeState.getDarkTheme;
  @override
  void initState() {
    super.initState();
      themeState = Provider.of<DarkThemeProvider>(context, listen: false);

    _loadEvent();   
  }
  
void _loadEvent() async {
  var utilisateurProvider = Provider.of<UtilisateurProvider>(context, listen: false);

  if (utilisateurProvider.isLoggedIn && utilisateurProvider.userId != null) {
    userId = utilisateurProvider.userId;

    _recipesControllerBD = RecipesController();

   
   List<Recipes> userRecipes = await _recipesControllerBD.getRecipesByUserId(userId!);

    Set<int> uniqueKeys = Set();

    setState(() {
      _recipesItems.clear();
      _recipesItems = userRecipes
          .where((recipe) {
            bool isUnique = uniqueKeys.add(recipe.id!);
            return isUnique;
          })
         .map(
  (recipe) => _buildRecipesItems(
    recipe,
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecetteDetail(recette: recipe, refreshRecipes: refreshRecipes),
            ),
          );
        },
      ),
    )
    .toList();
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
      title:const Text('Recettes créées'),   
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
        ),
        onPressed: () =>  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AcceuilPage()
        ),
      )
    )
    ),
    body: _recipesItems.isEmpty
        ? Center(
            child: Text(
              'Aucune recette créée.',
              style: TextStyle(color: color,fontSize: 20.0),
            ),
          )
        : GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            padding: const EdgeInsets.all(16.0),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            children: _recipesItems,
          ),
  );
}

  Widget _buildRecipesItems(Recipes recipe, VoidCallback onTap) {
      final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _isDark ? Colors.grey[600] : Colors.blueGrey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (recipe.imagePath.isNotEmpty)
              Image.file(
                File(recipe.imagePath),
                height: 60.0,
                width: double.infinity,
                fit: BoxFit.scaleDown,
              )
            else
              Image.asset(
                'assets/images/noImage.jpg',
                height: 60.0,
                width: double.infinity,
                fit: BoxFit.scaleDown,
              ),
           const SizedBox(height: 8.0),
            Text(
              recipe.name ?? 'Nom non défini',
              style: TextStyle(
                color:color,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  void refreshRecipes() {
    _loadEvent();
  }

  
}