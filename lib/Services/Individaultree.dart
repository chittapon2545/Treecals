import 'package:firebase_database/firebase_database.dart';
// นำเข้าแพ็กเกจ firebase_database เพื่อใช้เชื่อมต่อและดึงข้อมูลจาก Firebase Realtime Database

class IndividaultreeService {
  // ประกาศคลาสชื่อ IndividaultreeService สำหรับจัดการข้อมูลต้นไม้แต่ละต้น

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  // สร้างตัวแปร _dbRef เพื่ออ้างอิง root ของ Firebase Database

  Future<List<Map<String, dynamic>>> getTreesAndCreditsByUser(
    dynamic userId,
  ) async {
    // ฟังก์ชันแบบ async รับ userId เพื่อค้นหาต้นไม้และเครดิตของผู้ใช้คนนั้น
    // คืนค่าเป็น Future ของ List ที่แต่ละรายการเป็น Map<String, dynamic>

    final treesSnapshot = await _dbRef.child('individualtrees').get();
    // ดึงข้อมูลทั้งหมดจาก node 'individualtrees' ใน Firebase

    final creditSnapshot = await _dbRef.child('creditindividualtrees').get();
    // ดึงข้อมูลทั้งหมดจาก node 'creditindividualtrees' ใน Firebase

    final groupsSnapshot = await _dbRef.child('groups').get();
    // ดึงข้อมูลทั้งหมดจาก node 'groups' ใน Firebase
    List<Map<String, dynamic>> result = [];
    // สร้างลิสต์เปล่าสำหรับเก็บผลลัพธ์

    // --- แปลง individualtrees เป็น Map ---
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

    // --- แปลง creditindividualtrees เป็น List ---
    List creditList = [];
    // สร้าง List เปล่าสำหรับเก็บข้อมูลเครดิต

    if (creditSnapshot.value is List) {
      creditList = creditSnapshot.value as List;
      // ถ้าข้อมูลเครดิตเป็น List ให้นำมาใช้ตรงๆ
    } else if (creditSnapshot.value is Map) {
      creditList = (creditSnapshot.value as Map).values.toList();
      // ถ้าเป็น Map ให้นำ value ทั้งหมดมาแปลงเป็น List
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

        Map<String, dynamic>? credit;

        // ใช้ key (Itree1, Itree2, ...) แทน value['TreeID']
        for (var c in creditList) {
          // วนลูปข้อมูลเครดิตแต่ละรายการ

          if (c is Map && c['TreeID']?.toString() == key.toString()) {
            // ถ้าเครดิตเป็น Map และ TreeID ตรงกับต้นไม้
            credit = Map<String, dynamic>.from(c);
            // แปลงเครดิตเป็น Map<String, dynamic> แล้วเก็บไว้
            break;
            // เจอแล้วหยุดวนลูป
          }
        }
        String groupName;
        var groupId = value['Group_ID'];
        final groupKey = "${groupId.toString()}";
        groupName = groupsData[groupKey]?['name'];

        result.add({'tree': value, 'credit': credit, 'groupName': groupName});
        // เพิ่ม Map ที่ประกอบด้วยข้อมูลต้นไม้และเครดิตลงใน result
      }
    });

    return result;
    // ส่งคืนผลลัพธ์ที่เป็น List ของ Map (แต่ละรายการมีข้อมูลต้นไม้และเครดิต)
  }
}
