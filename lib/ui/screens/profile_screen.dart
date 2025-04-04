import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:sweet_balance/ui/screens/sign_in_screen.dart';
import 'package:sweet_balance/ui/screens/welcome_screen.dart';

import '../../service/auth_service.dart';
import '../widgets/collapsible_header.dart';
import '../widgets/infoCards/account_info_card.dart';

// Profile screen where user can view their personal details and manage their account
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScrollController _scrollController = ScrollController();

  // Centralized auth logic is abstracted into AuthService for better testability and separation of concerns
  final AuthService _authService = AuthService();

  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Jump to some scroll offset so that header animation is visible on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(250.0);
    });

    _loadUserData(); // Load current user data from Firestore
  }

  // Fetch the user's document from Firestore using their UID
  Future<void> _loadUserData() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _userData = doc.exists ? doc.data() : null;
        _isLoading = false;
      });
    }
  }

  // Format a stored date (String or Timestamp) to dd/mm/yyyy
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

  // Logs out the current user and redirects to sign-in screen
  Future<void> _signOut() async {
    await _authService.signOut();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SignInScreen()),
          (route) => false,
    );
  }

  // Starts the account deletion process: confirms password, then deletes user data
  Future<void> _deleteAccountFlow() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account permanently? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final user = _authService.getCurrentUser();
    if (user == null) return;

    final email = user.email;
    final passwordController = TextEditingController();

    if(!mounted) return;

    // Ask for password confirmation before destructive action
    final confirmPassword = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Please enter your password to delete your account."),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Confirm")),
        ],
      ),
    );

    if (confirmPassword != true) return;

    try {
      final password = passwordController.text.trim();

      // Re-authenticate before deletion for security purposes
      if (email != null && password.isNotEmpty) {
        final credential = EmailAuthProvider.credential(email: email, password: password);
        await user.reauthenticateWithCredential(credential);

        // Remove user data from Firestore and FirebaseAuth
        await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
        await user.delete();

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete account: ${e.toString()}")),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.getCurrentUser();

    return Container(
      color: Colors.grey[200],
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const CollapsibleHeader(title: "My Page"),

          // Show loading spinner or data based on loading state
          SliverToBoxAdapter(
            child: _isLoading
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            )
                : _userData == null
                ? const Padding(
              padding: EdgeInsets.all(16),
              child: Text("User data not found."),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: AccountInfoCard(
                height: 200,
                userName: _userData!['firstName'] ?? 'Unknown User',
                userEmail: user?.email ?? '',
                userDOB: _formatDate(_userData?['dob']),
                userGender: _userData?['gender'] ?? 'N/A',
                userCreatedAt: (_userData?['createdAt'] as Timestamp?)
                    ?.toDate()
                    .toIso8601String() ??
                    '',
                userHeight: _userData?['height']?.toString() ?? 'N/A',
                userWeight: _userData?['weight']?.toString() ?? 'N/A',
                avatarUrl: _userData?['avatarUrl'] ?? '',
                onRefresh: _loadUserData,
              ),
            ),
          ),

          // Log out tile
          SliverToBoxAdapter(
            child: _buildTile(
              icon: Icons.logout,
              text: 'Log Out',
              onTap: _signOut,
              iconColor: Colors.red[400],
            ),
          ),

          // Delete account tile
          SliverToBoxAdapter(
            child: _buildTile(
              icon: Icons.delete_forever,
              text: 'Delete Account',
              onTap: _deleteAccountFlow,
              iconColor: Colors.red[400],
            ),
          ),
        ],
      ),
    );
  }

  // UI helper method to render a settings-style option tile
  Widget _buildTile({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Icon(icon, size: 28, color: iconColor ?? Colors.black),
                const SizedBox(width: 15),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
