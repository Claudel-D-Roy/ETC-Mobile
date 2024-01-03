
import 'package:etc_claudel/Providers/dark_theme_provider.dart';
import 'package:etc_claudel/Providers/utilisateur_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? email;
  String? name;
  String? role;

  @override
  Widget build(BuildContext context) {
    var utilisateurProvider = Provider.of<UtilisateurProvider>(context);
    bool admin = utilisateurProvider.hasRole('admin');
    email = utilisateurProvider.name;
    name = utilisateurProvider.name?.split('@')[0];
    if (admin) {
      role = 'Administrateur';
    } else {
      role = 'Utilisateur';
    }

    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: color,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              RichText(
                  text: TextSpan(
                    text: 'Bonjour, ',
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: name == null ? 'Anon' : name!,
                        style: TextStyle(
                          color: color,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5,),
                Text(
                  email == null ? 'Courriel' : email!,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(thickness: 2,),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: Text(
                    themeState.getDarkTheme ? 'Dark mode' : 'Light mode',
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  secondary: Icon(
                    themeState.getDarkTheme
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                  ),
                  onChanged: (bool value) {
                    setState(() {
                      themeState.setDarkTheme = value;
                    });
                  },
                  value: themeState.getDarkTheme,
                ),
            ],
          ),
        ),
      ),
      backgroundColor: themeState.getDarkTheme ? Colors.black : Colors.white,
    );
  }
}



