import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/infoCards/account_info_card.dart';
import '../widgets/collapsible_header.dart';
import '../widgets/profile_visibility.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScrollController _scrollController = ScrollController();
  User? _currentUser;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(250.0);
    });
    _loadUserData();
  }

  String _formatDate(dynamic dob) {
    try {
      DateTime date;
      if (dob is Timestamp) {
        date = dob.toDate();
      } else if (dob is String) {
        date = DateTime.parse(dob);
      } else {
        return 'N/A';
      }
      return "${date.day.toString().padLeft(2, '0')}/"
          "${date.month.toString().padLeft(2, '0')}/"
          "${date.year}";
    } catch (_) {
      return 'Invalid date';
    }
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        _currentUser = user;
      });

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          _userData = doc.data();
          _isLoading = false;
        });
      } else {
        setState(() {
          _userData = null;
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const CollapsibleHeader(title: "My Page"),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: ProfileVisibilityCard(),
            ),
          ),

          SliverToBoxAdapter(
            child: _isLoading
                ? const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            )
                : _userData == null
                ? const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("User data not found."),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: AccountInfoCard(
                height: 200,
                userName: _userData!['firstName'] ?? 'Unknown User',
                userEmail: _currentUser?.email ?? '',
                userDOB: _formatDate(_userData?['dob']),
                userGender: _userData?['gender'] ?? 'N/A',
                userCreatedAt: (_userData?['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? '',
                userHeight: _userData?['height']?.toString() ?? 'N/A',
                userWeight: _userData?['weight']?.toString() ?? 'N/A',
                avatarUrl: _userData?['avatarUrl'] ?? '',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
