import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterWidget3 extends StatefulWidget {
  final File? profileImage;
  final Function(File?) onImageSelected;

  const RegisterWidget3({
    super.key,
    required this.profileImage,
    required this.onImageSelected,
  });

  @override
  State<RegisterWidget3> createState() => _RegisterWidget3State();
}

class _RegisterWidget3State extends State<RegisterWidget3> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.profileImage;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      widget.onImageSelected(_selectedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "เพิ่มรูปโปรไฟล์",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 30),
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: Colors.white.withOpacity(0.3),
            backgroundImage: _selectedImage != null
                ? FileImage(_selectedImage!)
                : null,
            child: _selectedImage == null
                ? Icon(Icons.account_circle, size: 120, color: Colors.white70)
                : null,
          ),
        ),
        SizedBox(height: 30),
        Text(
          _selectedImage == null
              ? "แตะเพื่อเลือกรูปภาพจากอุปกรณ์"
              : "เลือกรูปภาพแล้ว",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}
