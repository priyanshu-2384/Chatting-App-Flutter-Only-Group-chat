import 'package:blink_talk/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return Center(
      //whenever there will be any change in the collection than builder will be called again and we can see the added chat messages
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); //while we are fetching the data
          }

          if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages yet'),
            );
          }

          if (chatSnapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          //list of data
          final loadedMessages = chatSnapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
            reverse: true, //will display from bottom
            itemCount: loadedMessages.length,
            itemBuilder: (ctx, index) {
              final chatMessage = loadedMessages[index].data();
              final nextChatMessage = index + 1 < loadedMessages.length
                  ? loadedMessages[index + 1].data()
                  : null;
              final currMessageUserId = chatMessage['userId'];
              final nextMessageUserId =
                  nextChatMessage != null ? nextChatMessage['userId'] : null;
              final nextUserIsSame = currMessageUserId == nextChatMessage;

              if (nextUserIsSame) {
                return MessageBubble.next(
                    message: chatMessage['message'],
                    isMe: authenticatedUser.uid == currMessageUserId);
              }
              return MessageBubble.first(
                  userImage: chatMessage['imageUrl'],
                  username: chatMessage['username'],
                  message: chatMessage['message'],
                  isMe: authenticatedUser.uid == currMessageUserId);
            },
          );
        },
      ),
    );
  }
}
