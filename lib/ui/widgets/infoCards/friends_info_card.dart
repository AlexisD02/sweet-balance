import 'package:flutter/material.dart';

import '../../../models/friend_model.dart';
import '../../screens/all_friends_screen.dart';
import '../friend_info_popup.dart';

class FriendsCard extends StatelessWidget {
  final double height;
  final List<Friend> friends;

  const FriendsCard({
    super.key,
    this.height = 250,
    this.friends = const [],
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 12, 20, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Friends',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllFriendsScreen(
                              allFriends: friends,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (friends.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'No friends yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Start connecting with other users',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final friend = friends[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListTile(
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(friend.avatarUrl),
                          backgroundColor: Colors.grey[200],
                        ),
                        title: Text(
                          friend.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          friend.status,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),

                        onTap: () {
                          _showFriendInfoPopup(context, friend);
                        },

                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'unfriend') {
                              // todo Handle unfriend logic
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Unfriended ${friend.name}'),
                                ),
                              );
                            } else if (value == 'block') {
                              // todo Handle block logic
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Blocked ${friend.name}'),
                                ),
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem<String>(
                                value: 'unfriend',
                                child: Text('Unfriend'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'block',
                                child: Text('Block'),
                              ),
                            ];
                          },
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }

  void _showFriendInfoPopup(BuildContext context, Friend friend) {
    showDialog(
      context: context,
      builder: (ctx) {
        return FriendInfoPopup(
          friend: friend,
          onUnfriend: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Unfriended ${friend.name}'),
              ),
            );
          },
          onBlock: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Blocked ${friend.name}'),
              ),
            );
          },
        );
      },
    );
  }
}