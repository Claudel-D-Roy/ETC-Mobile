import 'package:auth0_flutter/auth0_flutter.dart';

class Auth0MockManuel implements Auth0 {
  @override
  // TODO: implement api
  AuthenticationApi get api => throw UnimplementedError();

  @override
  // TODO: implement credentialsManager
  CredentialsManager get credentialsManager => throw UnimplementedError();

  @override
  WebAuthentication webAuthentication({String? scheme, bool useCredentialsManager = true}) {
    // TODO: implement webAuthentication
    throw UnimplementedError();
  }

}