import 'package:chatappfirebasemit/Pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

class AuthService{

  //Google Sign in
  signInWithGoogle() async{

    //begin interactive sign in process

    final GoogleSignInAccount? gUser=await GoogleSignIn().signIn();
    if(gUser==null){
      return ;
    }

    //obtain the details of the request

    final GoogleSignInAuthentication gAuth= await gUser!.authentication;

    //create a new credential for user

    final credential=GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken

    );

    // finally, let sign in

    await FirebaseAuth.instance.signInWithCredential(credential);
    Get.offAll(() => HomePage());

    //should solve the issue
  }
}
