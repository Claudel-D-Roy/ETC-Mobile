
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/utilisateur_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.account_circle,
              size: 120.0,
              color: Colors.white,
            ),
            const SizedBox(height: 20.0),
            Container(
              constraints: const BoxConstraints(
                maxWidth: 500.0,
                minWidth: 0.0,
              ),
              width: MediaQuery.of(context).size.width * 0.9, 
              child: ElevatedButton(
                onPressed: () async {
                  await loginAction();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15.0),
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loginAction() async {
    try {
      await Provider.of<UtilisateurProvider>(context, listen: false).loginAction();
    } catch (e, s) {
      debugPrint('login with credentials error: $e - stack: $s');
    }
  }
}