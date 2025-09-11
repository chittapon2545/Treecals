import 'package:firebase_database/firebase_database.dart';

class PlotfastService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref("plotfast");

  Future<List<Map<String, dynamic>>> getPlotsByUser(String userId) async {
    final snapshot = await _db.get();

    if (!snapshot.exists) return [];

    final plots = <Map<String, dynamic>>[];

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    data.forEach((key, value) {
      final plot = Map<String, dynamic>.from(value);
      if ((plot["UserID"] ?? "") == userId) {
        plots.add({"id": key, "plot": plot});
      }
    });

    return plots;
  }
}
