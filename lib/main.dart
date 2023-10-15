import 'package:chatappfirebasemit/Pages/homepage.dart';
import 'package:chatappfirebasemit/Pages/register_page.dart';
import 'package:chatappfirebasemit/Pages/testing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Enable Firebase Authentication persistence
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // home: FirebaseAuth.instance.currentUser != null
      //     ? HomePage()
      //     : LoginPage(), // Check if user is logged in
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/testing', page: () => PostListPage())
      ],

      //testing
      home: StreamBuilder(
        // Listen to changes in the authentication state using the authStateChanges stream.
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Check if the connection to the stream is active.
          if (snapshot.connectionState == ConnectionState.active) {
            // Get the user object from the stream data. It could be null if the user is not authenticated.
            User? user = snapshot.data as User?;
            // If the user is null, redirect to the LoginPage. Otherwise, redirect to the HomePage.
            return user == null ? LoginPage() : HomePage(); // Redirect based on authentication state
          } else {
            // If the connection to the stream is not yet active, show a loading indicator.
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),

    );
  }
}
