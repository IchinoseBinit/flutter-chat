import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat/shared_preferences.dart';
import 'package:flutter_chat/utilities/firestore_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticateProvider with ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _account;

  GoogleSignInAccount? get user => _account;

  Future authenticateWithGoogle() async {
    final user = await googleSignIn.signIn();
    if (user != null) {
      _account = user;

      final authentication = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      await addUser(userCredential.user!);

      notifyListeners();
    }
  }

  addUser(User user) async {
    final username = user.email!.replaceAll("@gmail.com", "");
    Map<String, String> userInfo = {
      'email': user.email!,
      'username': username,
      'image': user.photoURL!,
      'name': user.displayName!,
    };

    await MySharedPreferences.sharedPreferences
        .setString(MySharedPreferences.userNameKey, username);

    await FireStoreHelper().addUser(user.uid, userInfo);
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
