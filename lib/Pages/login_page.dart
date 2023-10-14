import 'package:chatappfirebasemit/Pages/homepage.dart';
import 'package:chatappfirebasemit/Pages/register_page.dart';
import 'package:chatappfirebasemit/Services/AuthService.dart';
import 'package:chatappfirebasemit/components/my_button.dart';
import 'package:chatappfirebasemit/components/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/my_elevatedbutton.dart';
import '../components/my_textbutton.dart';




class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  RxBool loading = false.obs;

  //instance of auth
  FirebaseAuth _auth=FirebaseAuth.instance;  //creaing instance for easier use through _auth

  //instance of firestore
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  //signin user
  final emailController =TextEditingController();
  final passController =TextEditingController();

  //signin logic
  Future<void> login(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );
      // after creating the user,create a new document  for the user in the users collection
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': emailController.text,
      });
      Get.snackbar('Success', 'Sign in successful');
      // Navigate to the next screen upon successful sign-in.
      Get.offAll(() => HomePage());
    } catch (error) {
      Get.snackbar('Error', 'Error signing in: $error');
    } finally {
      loading.value = false;
    }
  }


  //loginwithgoogle
  final AuthService _authService = AuthService();

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      UserCredential? userCredential = await _authService.signInWithGoogle();
      if (userCredential != null) {
        // Create a new document for the user in the 'users' collection
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          // Add other user details as needed
        });

        Get.snackbar('Success', 'Sign in with Google successful');

        // Navigate to the next screen upon successful sign-in.
        Get.offAll(() => HomePage());
      }
    } catch (error) {
      Get.snackbar('Error', 'Error signing in with Google: $error');
    } finally {
      loading.value = false;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea( // this will just avoid notch bit
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50,),

                  //logo
                  Icon(
                    Icons.message,
                    size: 90,
                    color: Colors.grey[800],
                  ),
                  const SizedBox(height: 50,),
                  //welcome back message
                  Text(
                    "Welcome back you've been missed",
                    style: TextStyle(
                        fontSize: 16
                    ),),
                  const SizedBox(height: 25,),

                  //email textfield
                  MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obsecureText: false),
                  const SizedBox(height: 10,),

                  //password textfield
                  MyTextField(
                      controller: passController,
                      hintText: 'Password',
                      obsecureText: true),
                  const SizedBox(height: 25,),

                  //sign in button
                  MyElevatedButton(onPressed: (){
                    login(context);
                  }, buttonText: 'Sign In',),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not a member?'),
                      const SizedBox(width:5,),
                      MyTextButton(onPressed: (){
                        Get.to(RegisterPage());
                      }, buttonText: 'Register Now'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          AuthService().signInWithGoogle();
                        },
                        child: Image.asset(
                          'lib/images/google.png', // Replace with your Google Sign-In button image
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



}