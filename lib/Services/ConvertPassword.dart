import 'package:firebase_database/firebase_database.dart';
import 'package:bcrypt/bcrypt.dart';

class ConvertPassword {
  final DatabaseReference _userRef = FirebaseDatabase.instance.ref().child(
    "users",
  );

  Future<bool> updatePasswordHash(int ID, String newPassword) async {
    final snapshot = await _userRef.child(ID.toString()).get();

    if (!snapshot.exists) return false;

    final user = snapshot.value;
    if (user is Map<dynamic, dynamic>) {
      // Hash รหัสผ่านใหม่
      final hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

      // อัพเดตค่า Password_hash ในฐานข้อมูล
      await _userRef.child(ID.toString()).update({
        'Password_hash': hashedPassword,
      });

      return true;
    }

    return false;
  }
}
