import 'package:blink_talk/widgets/friend_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FriendsListScreenState();
  }
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (ctx, index) {
        return const FriendCard();
      },
    );
  }
}
