import 'package:chatappfirebasemit/Pages/homepage.dart';
import 'package:chatappfirebasemit/Pages/login_page.dart';
import 'package:chatappfirebasemit/components/my_elevatedbutton.dart';
import 'package:chatappfirebasemit/components/my_textbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController =TextEditingController();
  final passController =TextEditingController();
  final confirmController=TextEditingController();

  //instance of firestore
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  //signup user
  Future<void> registerWithEmailAndPassword(BuildContext context) async {
    try {
      if (passController.text == confirmController.text) {
        UserCredential userCredential=
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passController.text,
        );
        // after creating the user,create a new document  for the user in the users collection
        // if it doesn't already exists
        _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'emial': emailController.text
        },SetOptions(merge: true));
        Get.off(LoginPage());
      } else if(passController.text != confirmController.text) {
        Get.snackbar('','Password do not match...');
      }
    } catch (error) {
      print('Error registering user: $error');
      // Display an error message to the user.
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
                    "Let's create an account for you",
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
                  const SizedBox(height: 10,),
                  //confirm password
                  MyTextField(
                      controller: confirmController,
                      hintText: 'Confirm Password',
                      obsecureText: true),
                  const SizedBox(height: 25,),

                  //sign in button
                  MyElevatedButton(onPressed: (){
                    registerWithEmailAndPassword(context);
                  }, buttonText: 'Sign Up'),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already a member?'),
                      const SizedBox(width:5,),
                      MyTextButton(onPressed: (){
                        Get.to(LoginPage());
                      }, buttonText: 'Login Now'),
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
