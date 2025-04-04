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
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  late TextEditingController _nameController;
  late TextEditingController _genderController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _genderController = TextEditingController(text: widget.userGender);
    _heightController = TextEditingController(text: widget.userHeight);
    _weightController = TextEditingController(text: widget.userWeight);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      String? avatarUrl = widget.avatarUrl;

      if (_selectedImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_avatars')
            .child('${user.uid}.jpg');

        final uploadTask = await ref.putFile(_selectedImage!);
        avatarUrl = await uploadTask.ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'firstName': _nameController.text.trim(),
        'gender': _genderController.text.trim(),
        'height': double.tryParse(_heightController.text.trim()) ?? 0.0,
        'weight': double.tryParse(_weightController.text.trim()) ?? 0.0,
        'avatarUrl': avatarUrl,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
      log('Failed to update profile: $e');
    }
  }

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

  Widget _buildAvatarSection() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          CircleAvatar(
            radius: 110,
            backgroundImage: _selectedImage != null
                ? FileImage(_selectedImage!)
                : (widget.avatarUrl.isNotEmpty
                ? NetworkImage(widget.avatarUrl)
                : const AssetImage('assets/images/avatar_placeholder.png'))
            as ImageProvider,
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(height: 20),
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

  ButtonStyle _buttonStyle() => ElevatedButton.styleFrom(
    backgroundColor: Colors.grey[300],
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
  );

  Future<void> _openGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
      if (image != null) {
        setState(() => _selectedImage = File(image.path));
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _openCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (photo != null) {
        setState(() => _selectedImage = File(photo.path));
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

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
          BottomActionButtons(
            onCancel: () => Navigator.pop(context),
            onSave: _saveProfile,
          ),
        ],
      ),
    );
  }
}
