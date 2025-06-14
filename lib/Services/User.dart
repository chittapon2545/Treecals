import 'package:bcrypt/bcrypt.dart';
import 'package:firebase_database/firebase_database.dart';

class UserService {
  final DatabaseReference _userRef = FirebaseDatabase.instance.ref().child(
    "users",
  );

  Future<String?> login(String username, String password) async {
    final snapshot = await _userRef
        .get(); //ดึงข้อมูลจาก Firebase จากตาราง users
    if (!snapshot.exists) return null;
    final data = snapshot.value;
    if (data is Map<dynamic, dynamic>) {
      for (final entry in data.entries) {
        final user = entry.value;

        if (user != null && user['Username'] == username) {
          final storedHashedPassword = user['Password_hash'];
          if (storedHashedPassword is String &&
              BCrypt.checkpw(password, storedHashedPassword)) {
            return entry.key.toString(); // รหัสผ่านถูกต้อง
          }
        }
      }
    }

    return null; // ไม่พบ username หรือ password ไม่ถูกต้อง
  }

  Future<String?> checkPassword(String password) async {
    final snapshot = await _userRef.get();

    if (!snapshot.exists) return null;

    final data = snapshot.value;
    if (data is Map<dynamic, dynamic>) {
      try {
        final entry = data.entries.firstWhere(
          (entry) =>
              entry.value != null && entry.value['Password_hash'] == password,
        );
        return entry.value['Password_hash'];
      } catch (e) {
        return null;
      }
    } else if (data is List<dynamic>) {
      for (int i = 0; i < data.length; i++) {
        final check = data[i];
        if (check != null && check['Password_hash'] == password)
          return check['Password_hash'];
      }
    }
    return null;
  }

  Future<String?> checkPhone(String phone) async {
    final snapshot = await _userRef.get();

    if (!snapshot.exists) return null;

    final data = snapshot.value;
    if (data is Map<dynamic, dynamic>) {
      try {
        final entry = data.entries.firstWhere(
          (entry) => entry.value != null && entry.value['Phone'] == phone,
        );
        return entry.value['Phone'];
      } catch (e) {
        return null;
      }
    } else if (data is List<dynamic>) {
      for (int i = 0; i < data.length; i++) {
        final check = data[i];
        if (check != null && check['Phone'] == phone) return check['Phone'];
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> UserData(String ID) async {
    final snapshot = await _userRef.get();

    if (!snapshot.exists) return null;

    final data = snapshot.value;

    if (data is Map<dynamic, dynamic>) {
      try {
        final entry = data.entries.firstWhere(
          (entry) => entry.value != null && entry.key == ID,
        );
        return {
          'Firstname': entry.value['Firstname'],
          'Lastname': entry.value['Lastname'],
          'Address': entry.value['Address'],
          'Email': entry.value['Email'],
          'Phone': entry.value['Phone'],
          'Password_hash': entry.value['Password_hash'],
          'Username': entry.value['Username'],
        };
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<String?> Repassword(String ID, String oldPassword) async {
    final snapshot = await _userRef.get();
    if (!snapshot.exists) return null;
    final data = snapshot.value;
    if (data is Map<dynamic, dynamic>) {
      final user = data[ID];

      if (user != null) {
        final storedHashedPassword = user['Password_hash'];

        if (storedHashedPassword is String &&
            BCrypt.checkpw(oldPassword, storedHashedPassword)) {
          return oldPassword;
        }
      }
    } else if (data is List<dynamic>) {
      for (int i = 0; i < data.length; i++) {
        final user = data[i];
        if (user != null && user is Map) {
          final storedHashedPassword = user['Password_hash'];

          if (storedHashedPassword is String &&
              BCrypt.checkpw(oldPassword, storedHashedPassword)) {
            return oldPassword;
          }
        }
      }
    }
    return null;
  }

  Future<String?> updateUserData(
    String ID, // เปลี่ยน int เป็น String
    String firstname,
    String lastname,
    String email,
    String address,
  ) async {
    try {
      final userRef = _userRef.child(ID);
      final snapshot = await _userRef.get();
      if (!snapshot.exists) return null;

      await userRef.update({
        'Firstname': firstname,
        'Lastname': lastname,
        'Email': email,
        'Address': address,
      });

      return 'successfully';
    } catch (e) {
      return null;
    }
  }
}
