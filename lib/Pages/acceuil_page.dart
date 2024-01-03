import 'package:etc_claudel/Pages/gestion_admin.dart';
import 'package:etc_claudel/Providers/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:etc_claudel/Providers/utilisateur_provider.dart';
import 'package:etc_claudel/Pages/setting_page.dart';
import 'package:etc_claudel/Pages/creation_recette_page.dart';
import 'package:etc_claudel/Pages/recette_page.dart';
import 'package:etc_claudel/Pages/sous_cat_ingredient.dart';

class AcceuilPage extends StatefulWidget {
 const AcceuilPage({Key? key}) : super(key: key);
  @override
  State<AcceuilPage> createState() => _AcceuilPageState();
}

class _AcceuilPageState extends State<AcceuilPage> {
  @override
  Widget build(BuildContext context) {
    var utilisateurProvider = Provider.of<UtilisateurProvider>(context);
    bool admin = utilisateurProvider.hasRole('admin');
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    bool _isDark = themeState.getDarkTheme;


    return Scaffold(
      backgroundColor: _isDark ? Colors.black: Colors.white,
         

      body: Column(
          
        children: [
          Container(
          color: _isDark ? Colors.black : Colors.white,
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text(
              'Bienvenue ${utilisateurProvider.name!.split('@')[0]}',
              
              style: TextStyle(
                color: color,
                fontSize: 42.0,
                fontWeight: FontWeight.bold,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.60,
              padding: const EdgeInsets.all(16.0),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: <Widget>[
                _buildGridItem("Création de recette", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreationRecipe()));
                }),
                _buildGridItem("Liste de recette", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreatedRecipes()));
                }),
                _buildGridItem("Liste des ingrédients", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CategoriesPage()));
                }),
                SizedBox.expand(
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildGridItem("Déconnexion", () {
                          utilisateurProvider.logoutAction();
                          Navigator.popUntil(
                              context, (route) => route.isFirst);
                        }),
                      ),
                     const SizedBox(height: 6.0),
                      Expanded(
                        child: _buildGridItem("Paramètres", () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SettingsPage()));
                        }),
                      ),
                      SizedBox(height: admin ? 6.0 : 0.0),
                      if (admin)
                        Expanded(
                          child: _buildGridItem("Gestion ingrédients", () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const GestionIngredient()));
                          }),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(String title, VoidCallback onTap) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    bool _isDark = themeState.getDarkTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _isDark ? Colors.grey : Colors.blueGrey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            title,
            softWrap: true,
            style: TextStyle(
              color: color,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}