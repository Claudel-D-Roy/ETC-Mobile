import 'package:provider/provider.dart';
import 'package:etc_claudel/Models/recipesIngredients.dart';
import 'package:flutter/material.dart';
import 'package:etc_claudel/Providers/dark_theme_provider.dart';


class EditIngredientsDialog extends StatefulWidget {
  final List<RecipesIngredients> initialIngredients;

 const EditIngredientsDialog({required this.initialIngredients});

  @override
  State<EditIngredientsDialog> createState() =>
      _EditIngredientsDialogState(initialIngredients: initialIngredients);
}

class _EditIngredientsDialogState extends State<EditIngredientsDialog> {
  late List<RecipesIngredients> tempSelectedIngredients;

  _EditIngredientsDialogState({required List<RecipesIngredients> initialIngredients})
      : tempSelectedIngredients = List.from(initialIngredients);

  @override
  Widget build(BuildContext context) {

    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    bool _isDark = themeState.getDarkTheme;
    return AlertDialog(
        backgroundColor: _isDark ? Colors.black: Colors.white,
      title: Text('Modifier les ingrédients',
      style: TextStyle(
        color: color,
      )),
        content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              children: List.generate(
                tempSelectedIngredients.length,
                (index) {
                  final ingredient = tempSelectedIngredients[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(ingredient.name,
                                   style: TextStyle(color: color)
                                   ),
                                   
                                ),
                               const SizedBox(width: 10.0),
                                Container(
                            
                                  width: 75.0,
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: _isDark ?Colors.grey[600] : Colors.white,
                                  ),
                                  child: TextField(
                                    controller: TextEditingController(text: ingredient.quantity),
                                    keyboardType: TextInputType.number,
                                     style: TextStyle(color: color),
                                    onChanged: (value) {
                                      setState(() {
                                        tempSelectedIngredients[index] = RecipesIngredients(
                                          id: ingredient.id,
                                          name: ingredient.name,
                                          quantity: value.trim(),
                                        );
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 6.0),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_forever,
                        color: color),
                        onPressed: () {
                          setState(() {
                            tempSelectedIngredients.removeAt(index);
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                 },
          style: ElevatedButton.styleFrom(
            backgroundColor: _isDark ? Colors.grey[600] : Colors.blueGrey,
          ),
            child: Text(
    'Annuler',
    style: TextStyle(
      color: color
      
    ),
    ),
              ),
              ElevatedButton(
                onPressed: () {
                  tempSelectedIngredients.removeWhere((ingredient) =>
                      (double.tryParse(ingredient.quantity) ?? 0) <= 0);

                  Navigator.pop(context, List.from(tempSelectedIngredients));
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: _isDark ? Colors.grey[600] : Colors.blueGrey,
          ),
            child: Text(
    'Enregistrer',
    style: TextStyle(
      color: color
      
    ),
    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
