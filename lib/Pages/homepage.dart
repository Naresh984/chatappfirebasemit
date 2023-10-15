import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../Services/chatservice.dart';
import 'chatpage.dart';
import 'login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService(); // Add this line

  //Create a Map to store the latest messages for each user
  Map<String, String> latestMessages = {}; // Map to store latest messages


  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      // Clear the latestMessages map when signing out
      latestMessages.clear();
      Get.snackbar('Success', 'Sign out successful');
      Get.offAll(() => LoginPage());
    } catch (error) {
      Get.snackbar('Error', 'Error signing out: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF21215E).withOpacity(0.5),
      // Set the status bar color
      statusBarIconBrightness: Brightness.light,
      // Set the status bar icons color
      systemNavigationBarColor: Color(0xFF21215E).withOpacity(0.7),
      // Set the navigation bar color
      systemNavigationBarDividerColor: Colors
          .transparent, // Set the navigation bar divider color
    ));
    return WillPopScope(
      onWillPop: () async {
        // Override the back button behavior to prevent going back to LoginPage.
        Get.offAll(HomePage());
        return false; // Return false to prevent default back navigation.
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[20],
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Message',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ),
            ),
            backgroundColor: Color(0xFF21215E).withOpacity(0.7),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  _signOut(context);
                },
              ),
            ],
          ),
          body: _buildUserList(),
        ),
      ),
    );
  }

  Widget _buildUserList() {
    Random random = Random();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: FutureBuilder(
        future: _fetchUserList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error'));
          }

          List<Widget> userItems = [];
          snapshot.data!.forEach((userData) {
            String email = userData['email'] ?? '';
            String displayName = email.split('@').first;

            String profileImage;
            int randomImageIndex = random.nextInt(3);

            if (randomImageIndex == 0) {
              profileImage = 'lib/images/man.png';
            } else if (randomImageIndex == 1) {
              profileImage = 'lib/images/woman.png';
            } else {
              profileImage = 'lib/images/businessman.png'; // Add your third image path here
            }


            userItems.add(
              GestureDetector(
                onTap: () {
                  // Navigating to user's chat page and also giving receiver email and uid
                  Get.to(ChatPage(
                    receiveruserEmail: userData['email'],
                    receiverUserID: userData['uid'],
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                  child: ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.deepPurpleAccent[300],
                      child: Image.asset(profileImage), // Use randomly selected profile image
                    ),
                    title: Text(
                      displayName,
                      style: TextStyle(fontSize: 15, color: Color(0xFF21215E).withOpacity(0.7)),
                    ),
                    subtitle: Text(latestMessages[userData['uid']] ?? ''),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
              ),
            );
          });

          return ListView(
            children: userItems,
          );
        },
      ),
    );
  }



  Future<List<Map<String, dynamic>>> _fetchUserList() async {
    List<Map<String, dynamic>> userList = [];

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(
        'users').get();

    Map<String, String> userNames = {};

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (_auth.currentUser!.email != data['email']) {
        QuerySnapshot latestSnapshot = await _chatService
            .getMessages(
          _auth.currentUser!.uid,
          data['uid'],
        )
            .first;

        String latestMessage = '';
        if (latestSnapshot.docs.isNotEmpty) {
          latestMessage = latestSnapshot.docs.last['message'];
        }

        String profilePictureUrl = data['profilePictureUrl'] ??
            ''; // Retrieve profile picture URL from Firestore data

        latestMessages[data['uid']] = latestMessage;
        userList.add({
          'uid': data['uid'],
          'email': data['email'],
          'profilePictureUrl': profilePictureUrl,
          // Add the profile picture URL to the user list
        });
      }
    }

    return userList;
  }
}
