
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:etc_claudel/ControleursSqflite/utilisateur_controleur.dart';
import 'package:etc_claudel/Models/role.dart';
import 'package:etc_claudel/Models/utilisateur.dart';
import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/foundation.dart';

class UtilisateurProvider extends ChangeNotifier {
  Credentials? _credentials;
  Utilisateur? _utilisateur;
  bool _isAuthenticating = false;
  late Auth0 _auth0;
  late Auth0Web _auth0Web;
  late UtilisateurControleur _utilisateurControleur;
  late String _errorMessage = '';

  List<Role>? get roles => _utilisateur?.roles;

  bool get isLoggedIn => _credentials != null;
  bool get isAuthenticating => _isAuthenticating;
  String get errorMessage => _errorMessage;
  Uri? get pictureUrl => _credentials?.user.pictureUrl;
  String? get name => _credentials?.user.name;
String? get userId => _credentials?.user.sub;
  

  bool hasRole(String role) {
    return roles?.any((r) => r.role == role) ?? false;
  }

  UtilisateurProvider(Auth0 auth0, Auth0Web auth0web, UtilisateurControleur utilisateurControleur) {
    _auth0 = auth0;
    _auth0Web = auth0web;
    _utilisateurControleur = utilisateurControleur;
    _errorMessage = '';
  }

  Future<void> loginAction() async {
    _isAuthenticating = true;
    _errorMessage = '';

    notifyListeners();

    try {
      if (kIsWeb) {
        return _auth0Web.loginWithRedirect(redirectUrl: 'http://localhost:3000');
      }

      var credentials = await _auth0
          .webAuthentication(scheme: 'com.auth0.sample')
          .login();

      Utilisateur utilisateur = await _utilisateurControleur.getOrInsertUtilisateur(
          credentials.user.sub,
          credentials.user.name,
         
      );

      _isAuthenticating = false;
      _credentials = credentials;
      _utilisateur = utilisateur;

      notifyListeners();
    } on Exception catch(e, s) {
      debugPrint('login error: $e - stack: $s');

      _isAuthenticating = false;
      _errorMessage = e.toString();

      notifyListeners();
    }
  }

  Future<void> logoutAction() async {
    if (kIsWeb) {
      await _auth0Web.logout(returnToUrl: 'http://localhost:3000');
    } else {
      await _auth0
          .webAuthentication(scheme: 'com.auth0.sample')
          .logout();
    }

    _credentials = null;
    _utilisateur = null;

    notifyListeners();
  }
}
