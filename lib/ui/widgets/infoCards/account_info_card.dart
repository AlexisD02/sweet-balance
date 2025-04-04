import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../screens/edit_profile_screen.dart';

class AccountInfoCard extends StatelessWidget {
  final double height;
  final String userName;
  final String userEmail;
  final String userDOB;
  final String userGender;
  final String userCreatedAt;
  final String userHeight;
  final String userWeight;
  final String avatarUrl;
  final void Function()? onRefresh;

  const AccountInfoCard({
    super.key,
    required this.height,
    required this.userName,
    required this.userEmail,
    required this.userDOB,
    required this.userGender,
    required this.userCreatedAt,
    required this.userHeight,
    required this.userWeight,
    required this.avatarUrl,
    this.onRefresh,
  });

  Widget _buildInfoRow(IconData icon, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        )
      ],
    );
  }

  String _getTimeAgo(String createdAt) {
    try {
      final createdDate = DateTime.parse(createdAt);
      return timeago.format(createdDate, allowFromNow: false);
    } catch (e) {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final joinedTimeAgo = _getTimeAgo(userCreatedAt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              color: Colors.white10,
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(26.0),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: (avatarUrl.isNotEmpty)
                            ? NetworkImage(avatarUrl)
                            : null,
                        child: (avatarUrl.isEmpty)
                            ? const Icon(Icons.person, size: 40, color: Colors.grey)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            final shouldRefresh = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                  userName: userName,
                                  userEmail: userEmail,
                                  userDOB: userDOB,
                                  userGender: userGender,
                                  userHeight: userHeight,
                                  userWeight: userWeight,
                                  avatarUrl: avatarUrl,
                                ),
                              ),
                            );

                            if (shouldRefresh == true && onRefresh != null) {
                              onRefresh!();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.edit, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            userName,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 7.5),
                            _buildInfoRow(Icons.email, userEmail),
                            const SizedBox(height: 7.5),
                            _buildInfoRow(Icons.cake, userDOB),
                            const SizedBox(height: 7.5),
                            _buildInfoRow(Icons.person, userGender),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(25)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        joinedTimeAgo,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Joined',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
