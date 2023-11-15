import 'package:blink_talk/widgets/chat_messages.dart';
import 'package:blink_talk/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BlinkChat'), actions: [
        IconButton(
            onPressed: () {
              FirebaseAuth.instance
                  .signOut(); //Logs a user out , i.e Erases the token from the device andtherefore our StreamBuilder will get no data and it will display authScreen,
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ))
      ]),
      body: const Column(
          children: [Expanded(child: ChatMessages()), NewMessage()]),
    );
  }
}
