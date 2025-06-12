import 'package:firebase_database/firebase_database.dart';

class GroupServices {
  final DatabaseReference _groupRef = FirebaseDatabase.instance.ref().child(
    "groups",
  );
  void readData() async {
    final snapshot = await _groupRef.get();

    if (snapshot.exists) {
      final data = snapshot.value;

      if (data is Map<dynamic, dynamic>) {
        print("Data is a Map:");
        data.forEach((key, value) {
          print("Key: $key → Value: $value");
        });
      } else if (data is List<dynamic>) {
        print("Data is a List:");
        for (int i = 0; i < data.length; i++) {
          final value = data[i];
          if (value != null) {
            print("Index $i → Value: $value");
          }
        }
      } else {
        print("Unknown data type: $data");
      }
    } else {
      print("No Data available at Group node.");
    }
  }
}
