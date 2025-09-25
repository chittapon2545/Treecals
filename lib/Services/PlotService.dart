import 'package:firebase_database/firebase_database.dart';

class PlotfastService {
  final DatabaseReference db = FirebaseDatabase.instance.ref();

  //รวมแปลงเร็วและปกติ
  Future<List<Map<String, dynamic>>> getAllPlotsByUser(String userId) async {
    List<Map<String, dynamic>> plots = [];

    final normalSnapshot = await db
        .child('Normalplot')
        .orderByChild('UserID')
        .equalTo(userId)
        .get();

    if (normalSnapshot.exists) {
      for (final child in normalSnapshot.children) {
        final plot = Map<String, dynamic>.from(child.value as Map);
        plots.add({"id": child.key, "plot": plot, "type": "แปลงปกติ"});
      }
    }

    final fastSnapshot = await db
        .child("plotfast")
        .orderByChild("UserID")
        .equalTo(userId)
        .get();

    if (fastSnapshot.exists) {
      for (final child in fastSnapshot.children) {
        final plot = Map<String, dynamic>.from(child.value as Map);
        plots.add({"id": child.key, "plot": plot, "type": "แปลงเร็ว"});
      }
    }

    print('Total plots for user $userId: ${plots.length}');
    print('Plots data: $plots');
    return plots;
  }
}
