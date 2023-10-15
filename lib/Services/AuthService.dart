import 'package:chatappfirebasemit/Pages/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        return null; // Handle sign-in cancellation
      }

      GoogleSignInAuthentication gAuth = await gUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Check if the user already exists in your users collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();

      if (!userDoc.exists) {
        // User doesn't exist, create a new document for the user
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          // Add other user details as needed
        });
      }

      Get.snackbar('Success', 'Sign in with Google successful');
      Get.offAll(() => HomePage());
      return userCredential;
    } catch (error) {
      Get.snackbar('Error', 'Error signing in with Google: $error');
      return null;
    }
  }
}


