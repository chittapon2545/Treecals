import 'package:firebase_database/firebase_database.dart';

class IndividaultreeService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<List<Map<String, dynamic>>> getTreesAndCreditsByUser(
    dynamic userId,
  ) async {
    final treesSnapshot = await _dbRef.child('individualtrees').get();
    final creditSnapshot = await _dbRef.child('creditindividualtrees').get();

    List<Map<String, dynamic>> result = [];

    // --- แปลง individualtrees เป็น Map ---
    Map<dynamic, dynamic> treesData = {};
    if (treesSnapshot.value is Map) {
      treesData = treesSnapshot.value as Map<dynamic, dynamic>;
    } else if (treesSnapshot.value is List) {
      final list = treesSnapshot.value as List;
      for (int i = 0; i < list.length; i++) {
        if (list[i] != null) {
          treesData[i.toString()] = list[i];
        }
      }
    }

    // --- แปลง creditindividualtrees เป็น List ---
    List creditList = [];
    if (creditSnapshot.value is List) {
      creditList = creditSnapshot.value as List;
    } else if (creditSnapshot.value is Map) {
      creditList = (creditSnapshot.value as Map).values.toList();
    }

    treesData.forEach((key, value) {
      if (value is Map &&
          value['UserID'] != null &&
          value['UserID'].toString() == userId.toString()) {
        Map<String, dynamic>? credit;
        if (value['TreeID'] != null) {
          for (var c in creditList) {
            if (c is Map &&
                c['TreeID']?.toString() == value['TreeID']?.toString()) {
              credit = Map<String, dynamic>.from(c);
              break;
            }
          }
        }
        result.add({'tree': value, 'credit': credit});
      }
    });

    return result;
  }
}
