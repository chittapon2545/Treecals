import 'package:firebase_database/firebase_database.dart';
import 'package:bcrypt/bcrypt.dart';

class ConvertPassword {
  final DatabaseReference _userRef = FirebaseDatabase.instance.ref().child(
    "users",
  );

  Future<void> updatePasswordHash(String ID, String newPassword) async {
    final snapshot = await _userRef.child(ID).get();

    if (!snapshot.exists) return;

    final user = snapshot.value;
    if (user is Map<dynamic, dynamic>) {
      // Hash รหัสผ่านใหม่
      final hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

      // อัพเดตค่า Password_hash ในฐานข้อมูล
      await _userRef.child(ID).update({'Password_hash': hashedPassword});
    }
  }

  String hashPassword(String password) {
    final hashed = BCrypt.hashpw(password, BCrypt.gensalt());
    return hashed;
  }
}
