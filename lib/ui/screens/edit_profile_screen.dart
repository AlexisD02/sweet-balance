import 'dart:io';
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

  Widget _buildField(String label, String initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        TextField(
          controller: TextEditingController(text: initialValue),
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
        preferredCameraDevice: CameraDevice.front,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  // Avatar + Buttons
                  Container(
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
                              : null) as ImageProvider?,
                          backgroundColor: Colors.grey[200],
                          child: (widget.avatarUrl.isEmpty && _selectedImage == null)
                              ? const Icon(Icons.person, size: 50, color: Colors.grey)
                              : null,
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
                  ),

                  const SizedBox(height: 20),

                  // Editable Fields
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: _boxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildField("Name", widget.userName),
                        const SizedBox(height: 20),
                        _buildField("Email", widget.userEmail),
                        const SizedBox(height: 20),
                        _buildField("Gender", widget.userGender),
                        const SizedBox(height: 20),
                        _buildField("Date of Birth", widget.userDOB),
                        const SizedBox(height: 20),
                        _buildField("Height (cm)", widget.userHeight),
                        const SizedBox(height: 20),
                        _buildField("Weight (kg)", widget.userWeight),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          BottomActionButtons(
            onCancel: () => Navigator.pop(context),
            onSave: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Save Pressed')),
              );
            },
          ),
        ],
      ),
    );
  }
}
