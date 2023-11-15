import 'package:blink_talk/screens/friends_list_screen.dart';
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
  var _currIndex = 0;
  String _appBarTitle = "Blink GroupChat";

  void _selectTab(int index) {
    setState(() {
      _currIndex = index;
      _appBarTitle = "Blink GroupChat";
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currScreen =
        const Column(children: [Expanded(child: ChatMessages()), NewMessage()]);

    Widget currentAction = IconButton(
        onPressed: () {
          FirebaseAuth.instance
              .signOut(); //Logs a user out , i.e Erases the token from the device andtherefore our StreamBuilder will get no data and it will display authScreen,
        },
        icon: Icon(
          Icons.exit_to_app,
          color: Theme.of(context).colorScheme.primary,
        ));

    if (_currIndex == 1) {
      currScreen = const FriendsListScreen();
      _appBarTitle = "Blink Friends";
      currentAction = IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          //add new friends
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_appBarTitle), actions: [currentAction]),
      body: currScreen,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currIndex,
          onTap: (index) => _selectTab(index),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.chat), label: 'Global Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Friends')
          ]),
    );
  }
}
