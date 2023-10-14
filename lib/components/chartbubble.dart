import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  const ChatBubble({
    super.key,
    required this.message
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.grey.withOpacity(0.7), // Adjust opacity here
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: 13, color: Colors.white),
      ),
    );

  }
}
