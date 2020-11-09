import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseController {
  static Future signIn({
    String email,
    String password,
  }) async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return user.user;
  }

  static Future<void> signUp(
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

    } catch (e) {
      print(e.message ?? e.toString());
    }
  }

  static Future<void> signOut(User user) async {
    await FirebaseAuth.instance.signOut();
  }

  /* static Future<User> googleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      GoogleSignInAccount googleAccount = await googleSignIn.signIn();

      GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAccount.id);

      UserCredential userResult = await auth.signInWithCredential(credential);
      print('after signInWithCredential(credential) ${userResult.user}');

      print('User ${userResult.user}');
      return userResult.user;
    } catch (e) {
      print(e.message ?? e.toString());
    }
  } */
}
