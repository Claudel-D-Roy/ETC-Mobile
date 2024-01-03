import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:etc_claudel/Pages/acceuil_page.dart';
import 'package:etc_claudel/Providers/dark_theme_provider.dart';
import 'package:etc_claudel/Providers/utilisateur_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ControleursSqflite/utilisateur_controleur.dart';
import 'DataBase/database.dart';
import 'Pages/login_page.dart';


void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  bool isLoading = false;
  late DatabaseHandler _db;
  DarkThemeProvider themeChanger = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChanger.setDarkTheme = await themeChanger.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
      getCurrentAppTheme();

    super.initState();

    _db = DatabaseHandler();

    if(_db.database == null) {
      isLoading = true;
      _initDatabase();
    } else {
      isLoading = false;
    }
  }

  void _initDatabase() async {
    await _db.initDb();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
     return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: UtilisateurProvider(Auth0('dev-peuakffutdt577hg.us.auth0.com', 'ULDFbDbTYyjpHK9old2PzbSmfj2LHpJz'), Auth0Web('dev-peuakffutdt577hg.us.auth0.com', 'ULDFbDbTYyjpHK9old2PzbSmfj2LHpJz'), UtilisateurControleur()),
        ),
        ChangeNotifierProvider.value(value: themeChanger),
      ],
      child: Consumer2<DarkThemeProvider, UtilisateurProvider>(
        builder: (context, themeProvider, utilisateurProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primaryColor: Colors.grey),
            home: DefaultTabController(
              length: 3,
              child: Scaffold(
                body: Center(
                  child: utilisateurProvider.isAuthenticating
                      ? const CircularProgressIndicator()
                      : utilisateurProvider.isLoggedIn
                          ? AcceuilPage()
                          : LoginPage(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}