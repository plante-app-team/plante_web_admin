import 'package:google_sign_in/google_sign_in.dart';
import 'package:plante/outside/identity/google_user.dart';

class GoogleAuthorizer {
  static Future<GoogleUser> auth() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        clientId:
            "84481772151-aisj7p71ovque8tbsi8ribpc5iv7bpjd.apps.googleusercontent.com");

    final account = await googleSignIn.signIn();
    final authentication = await account!.authentication;
    final idToken = authentication.idToken;
    return GoogleUser(account.displayName ?? "", account.email, idToken!,
        DateTime.now().toUtc());
  }
}
