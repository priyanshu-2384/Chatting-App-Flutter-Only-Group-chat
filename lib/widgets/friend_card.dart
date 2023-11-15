import 'package:flutter/material.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //navigate to Personal Chat screen
      },
      child: Card(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey,
            ),
            const SizedBox(width: 10),
            Text(
              "Priyanshu",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary, fontSize: 18),
            )
          ],
        ),
      )),
    );
  }
}
