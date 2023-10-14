
import 'package:chatappfirebasemit/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier{

  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final FirebaseFirestore _fireStore=FirebaseFirestore.instance;

  //send message
  Future<void> sendMessage(String receiverId,String message) async{

    //get currentuser info
    final String currentUserId=_firebaseAuth.currentUser!.uid;
    final String currentUserEmail=_firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp=Timestamp.now();

    //create a message
    // A Message object is created using the provided data.
    Message newMessage=Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,);

    //Construct chat room id from current user id and reciever id (sorted to ensure uniqueness)
    List<String> ids=[currentUserId,receiverId];
    ids.sort();//sort the ids this ensures the chat room id is alwsy the same pair for any pair
    String chatRoomId=ids.join("_");//combine ids into single to use as a chatroomid

    //add new message to database
    // .collection('chat_rooms'): Chat rooms collection.
    //     .doc(chatRoomId): Specific chat room document.
    //     .collection('messages'): Subcollection for messages.
    await _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'senderId': currentUserId,
      'senderEmail': currentUserEmail,
      'receiverId': receiverId,
      'timestamp': FieldValue.serverTimestamp(), // Use server timestamp here
      'message': message,
    });
  }

  //geting message
  Stream<QuerySnapshot> getMessages(String userId,String otherUseId){
    // function takes the IDs of two users, userId and otherUserId, and
    // returns a stream of QuerySnapshot objects. A QuerySnapshot is a snapshot of query results from Firestore.
    //construct chat room id from user ids (sorted to ensrue it matches the user when sending msgs
    List<String> ids=[userId,otherUseId];//: Creates a list called ids containing the IDs of the two users.
    ids.sort();// Sorts the ids list. This is done to ensure consistency in the order of IDs

    String chatRoomId=ids.join("_");
    return _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')//Accesses the subcollection of messages within the specified chat room document.
        .orderBy('timestamp',descending: false)//This will retrieve the messages from oldest to newest.
        .snapshots();//This will retrieve the messages from oldest to newest.
  }


}