import 'package:flutter/material.dart';

import '../../models/friend_model.dart';

class FriendInfoPopup extends StatelessWidget {
  final Friend friend;
  final VoidCallback onUnfriend;
  final VoidCallback onBlock;

  const FriendInfoPopup({
    super.key,
    required this.friend,
    required this.onUnfriend,
    required this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      titlePadding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(friend.name),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(friend.avatarUrl),
          ),
          const SizedBox(height: 12),
          Text(
            friend.status,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onUnfriend();
          },
          child: const Text('UNFRIEND'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onBlock();
          },
          child: const Text(
            'BLOCK',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
