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
      // hello Googledsafaf updated
      //testing
      home: LoginPage(),
    );
  }
}
