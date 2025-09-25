import 'package:firebase_database/firebase_database.dart';
// นำเข้าแพ็กเกจ firebase_database เพื่อใช้เชื่อมต่อและดึงข้อมูลจาก Firebase Realtime Database

class IndividaultreeService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<List<Map<String, dynamic>>> getTreesAndCreditsByUser(
    dynamic userId,
  ) async {
    // ฟังก์ชันแบบ async รับ userId เพื่อค้นหาต้นไม้และเครดิตของผู้ใช้คนนั้น
    // คืนค่าเป็น Future ของ List ที่แต่ละรายการเป็น Map<String, dynamic>
    final treesSnapshot = await _dbRef.child('individualtrees').get();
    final groupsSnapshot = await _dbRef.child('groups').get();
    List<Map<String, dynamic>> result = [];

    Map<dynamic, dynamic> treesData = {};
    // สร้าง Map เปล่าสำหรับเก็บข้อมูลต้นไม้

    if (treesSnapshot.value is Map) {
      treesData = treesSnapshot.value as Map<dynamic, dynamic>;
      // ถ้าข้อมูลที่ได้เป็น Map ให้นำมาใช้ตรงๆ
    } else if (treesSnapshot.value is List) {
      final list = treesSnapshot.value as List;
      // ถ้าข้อมูลที่ได้เป็น List ให้นำมาแปลงเป็น Map
      for (int i = 0; i < list.length; i++) {
        if (list[i] != null) {
          treesData[i.toString()] = list[i];
          // ใส่ข้อมูลแต่ละรายการใน List ลงใน Map โดยใช้ index เป็น key
        }
      }
    }

    Map<dynamic, dynamic> groupsData = {};
    if (groupsSnapshot.value is Map) {
      groupsData = groupsSnapshot.value as Map<dynamic, dynamic>;
    }
    treesData.forEach((key, value) {
      // วนลูปข้อมูลต้นไม้แต่ละรายการใน treesData

      if (value is Map &&
          value['UserID'] != null &&
          value['UserID'].toString() == userId.toString()) {
        // ตรวจสอบว่า value เป็น Map และมี UserID ตรงกับ userId ที่รับเข้ามา
        String groupName;
        var groupId = value['Group_ID'];
        final groupKey = "${groupId.toString()}";
        groupName = groupsData[groupKey]?['name'];

        result.add({
          'id': key,
          'tree': value,
          'credit': value['Credit'],
          'groupName': groupName,
        });
        // เพิ่ม Map ที่ประกอบด้วยข้อมูลต้นไม้และเครดิตลงใน result
      }
    });

    return result;
    // ส่งคืนผลลัพธ์ที่เป็น List ของ Map (แต่ละรายการมีข้อมูลต้นไม้และเครดิต)
  }

  Future<void> updateTree(
    String userId,
    String treeId,
    Map<String, dynamic> data,
  ) async {
    await _dbRef.child("individualtrees/$treeId").update(data);
  }

  Future<void> deleteTree(String userId, String treeId) async {
    await _dbRef.child("individualtrees/$treeId").remove();
  }
}
