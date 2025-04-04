import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/bottom_action_buttons.dart';

class EditProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userDOB;
  final String userGender;
  final String userHeight;
  final String userWeight;
  final String avatarUrl;

  const EditProfileScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userDOB,
    required this.userGender,
    required this.userHeight,
    required this.userWeight,
    required this.avatarUrl,
  });

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _pickedImageFile;

  late TextEditingController _nameController;
  late TextEditingController _genderController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();

    // Initialize input fields with values from the user profile,
    // only those that can be modified
    _nameController = TextEditingController(text: widget.userName);
    _genderController = TextEditingController(text: widget.userGender);
    _heightController = TextEditingController(text: widget.userHeight);
    _weightController = TextEditingController(text: widget.userWeight);
  }

  @override
  void dispose() {
    // Clean up controllers to prevent memory leaks
    _nameController.dispose();
    _genderController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // Saves profile info and optionally uploads avatar to Firebase Storage
  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      String? newAvatarUrl = widget.avatarUrl;

      // If user picked a new image, upload it and get download URL
      if (_pickedImageFile != null) {
        final avatarRef = FirebaseStorage.instance
            .ref()
            .child('user_avatars')
            .child('${user.uid}.jpg');

        final uploadTask = await avatarRef.putFile(_pickedImageFile!);
        newAvatarUrl = await uploadTask.ref.getDownloadURL();
      }

      // Update profile data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'firstName': _nameController.text.trim(),
        'gender': _genderController.text.trim(),
        'height': double.tryParse(_heightController.text.trim()) ?? 0.0,
        'weight': double.tryParse(_weightController.text.trim()) ?? 0.0,
        'avatarUrl': newAvatarUrl,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      // Basic error handling — logs issue and alerts user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
      log('Failed to update profile: $e');
    }
  }

  // Builds a text input field with a label
  Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  // Profile picture section — displays current avatar and image selection options
  Widget _buildAvatarSection() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          CircleAvatar(
            radius: 110,
            backgroundImage: _pickedImageFile != null
                ? FileImage(_pickedImageFile!)
                : (widget.avatarUrl.isNotEmpty
                ? NetworkImage(widget.avatarUrl)
                : const AssetImage('assets/images/avatar_placeholder.png'))
            as ImageProvider,
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(height: 20),

          // Image selection buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _openGallery,
                icon: const Icon(Icons.photo, color: Colors.black),
                label: const Text("Gallery", style: TextStyle(color: Colors.black)),
                style: _buttonStyle(),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: _openCamera,
                icon: const Icon(Icons.camera, color: Colors.black),
                label: const Text("Camera", style: TextStyle(color: Colors.black)),
                style: _buttonStyle(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Shows editable profile fields (except for email & DOB, which are fixed)
  Widget _buildEditableFields() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Email", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
          const SizedBox(height: 8),
          Text(widget.userEmail, style: const TextStyle(fontSize: 16.0, color: Colors.black87)),

          const SizedBox(height: 20),
          const Text("Date of Birth", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
          const SizedBox(height: 8),
          Text(widget.userDOB, style: const TextStyle(fontSize: 16.0, color: Colors.black87)),

          const SizedBox(height: 15),
          const Divider(thickness: 2.5, color: Colors.black),
          const SizedBox(height: 15),

          // Editable fields
          _buildField("Name", _nameController),
          const SizedBox(height: 20),

          _buildField("Gender", _genderController),
          const SizedBox(height: 20),

          _buildField("Height (cm)", _heightController),
          const SizedBox(height: 20),

          _buildField("Weight (kg)", _weightController),
        ],
      ),
    );
  }

  // Shared decoration for card-style sections
  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: const [
      BoxShadow(
        color: Colors.white10,
        spreadRadius: 2,
        blurRadius: 5,
      ),
    ],
  );

  // Consistent style for action buttons
  ButtonStyle _buttonStyle() => ElevatedButton.styleFrom(
    backgroundColor: Colors.grey[300],
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
  );

  // Opens gallery to select a new image
  Future<void> _openGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600);
      if (image != null) {
        setState(() => _pickedImageFile = File(image.path));
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  // Opens camera to capture a new profile photo
  Future<void> _openCamera() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (photo != null) {
        setState(() => _pickedImageFile = File(photo.path));
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  // Displays an error as a snackbar
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $msg')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildAvatarSection(),
                  const SizedBox(height: 20),
                  _buildEditableFields(),
                ],
              ),
            ),
          ),
          // Cancel and Save buttons at bottom
          BottomActionButtons(
            onCancel: () => Navigator.pop(context),
            onSave: _saveProfile,
          ),
        ],
      ),
    );
  }
}
