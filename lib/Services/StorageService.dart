import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class StorageService {
  Future<String?> uploadProfileImage(String userId, File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
        "profile_images/$userId.jpg",
      );

      await storageRef.putFile(imageFile);

      final downloadUrl = await storageRef.getDownloadURL();

      // บันทึก URL ลง Realtime Database
      await FirebaseDatabase.instance.ref('users/$userId').update({
        "ProfileURL": downloadUrl,
      });

      return downloadUrl;
    } catch (e) {
      print("Error uploading profile image: $e");
      return null;
    }
  }
}
