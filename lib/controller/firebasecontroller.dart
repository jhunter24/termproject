import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:platformsOfEndurance/model/leaderboard.dart';


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
    
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
   
  }

  static Future<void> signOut(User user) async {
    await FirebaseAuth.instance.signOut();
  }

  

  static Future<void> updateUsername(User user, String username) async { 
     await user.updateProfile(displayName: username);  
     user.reload();
     return user;
  }

  static Future<void> updatePassword({String password,User user}) async{
    await user.updatePassword(password);
    user.reload();
  
  }

  static Future<List<Leaderboard>> getLeaderboard() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Leaderboard.COLLECTION_NAME)
        .orderBy(Leaderboard.SCORE, descending: true)
        .get();

    var results = <Leaderboard>[];

    if (querySnapshot.docs.length != 0) {
      for (var pos in querySnapshot.docs) {
        results.add(Leaderboard.deserialize(pos.data(), pos.id));
      }
    }
    return results;
  }
}
