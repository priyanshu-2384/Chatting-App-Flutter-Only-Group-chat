import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  final _messageController =
      TextEditingController(); //whenever dealing with controllers do't forget to call dispose

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    _messageController
        .clear(); //after sending to firebase clearing all that messages , as we are going to use the same screen again
    FocusScope.of(context).unfocus(); //close keyboard

    final user = FirebaseAuth.instance.currentUser!; //getting  current user
    final userInfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get(); //getting info of current user(form our firestore database)(by our user uid)
    //storing the chat data in the firebase firestore in a new chat folder
    //add -> firebase give unique name to file an you can add in that
    FirebaseFirestore.instance.collection('chats').add({
      'message': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userInfo.data()!['username'],
      'imageUrl': userInfo.data()!['imageUrl'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 2, bottom: 19),
        child: Row(
          children: [
            Expanded(
                child: TextField(
              //capitalize the start of every new sentence
              controller:
                  _messageController, //to control the messages entered in it
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'Send a Message...'),
            )),
            IconButton(
              onPressed: _submitMessage,
              icon: const Icon(Icons.send),
              color: Theme.of(context).colorScheme.primary,
            )
          ],
        ));
  }
}
