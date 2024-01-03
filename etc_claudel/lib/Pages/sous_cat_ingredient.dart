import 'package:etc_claudel/ControleursSqflite/ingredient_controleur.dart';
import 'package:etc_claudel/Providers/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:etc_claudel/Pages/liste_ingredients.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {

  const CategoriesPage({ Key? key }) : super(key: key);
   @override
  State<CategoriesPage> createState() => _CategoriesPageState();
 
}
 
class _CategoriesPageState extends State<CategoriesPage> {
  late IngredientsController ingrdientsControllerBD;
  late List<String> typeIngredients = [];
  late DarkThemeProvider themeState;
  bool get _isDark => themeState.getDarkTheme;
  @override
  void initState() {
    super.initState();
      themeState = Provider.of<DarkThemeProvider>(context, listen: false);

    _loadEvent();
  }

  void _loadEvent() async {
    ingrdientsControllerBD = IngredientsController();
    typeIngredients = await ingrdientsControllerBD.getAllTypes();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
   return Scaffold(
      backgroundColor: _isDark ? Colors.black: Colors.white,
      appBar: AppBar(
          foregroundColor:  _isDark ? Colors.white: Colors.black,  
        backgroundColor: _isDark ? Colors.black: Colors.white,
        title: Text('Categories', style: TextStyle(color: color)),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        padding: const EdgeInsets.all(16.0),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        children: _buildCategoryItems(),
      ),
    );
  }

  List<Widget> _buildCategoryItems() {


    final Set<String> uniqueCategories = Set();

    for (int i = 0; i < typeIngredients.length; i++) {
      uniqueCategories.add(typeIngredients[i]);
    }

    return uniqueCategories.map((category) {
      return _buildCategoryItem(category, () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IngredientsList(category: category),
      ),
    );
  });
}).toList();
  }

  Widget _buildCategoryItem(String category, VoidCallback onTap) {
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color:  _isDark ? Colors.grey[600] : Colors.blueGrey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              color:color,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}