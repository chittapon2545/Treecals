import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Addtreeinplot extends StatefulWidget {
  final String plotId;
  final String userId;
  final String group;
  const Addtreeinplot({
    super.key,
    required this.plotId,
    required this.userId,
    required this.group,
  });

  @override
  State<Addtreeinplot> createState() => _AddtreeinplotState();
}

class _AddtreeinplotState extends State<Addtreeinplot> {
  List<Map<String, dynamic>> samplePlots = [];
  final formKey = GlobalKey<FormState>();
  final treeDB = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    addSamplePlot(); // เริ่มต้นด้วย 1 แปลง
  }

  void addSamplePlot() {
    setState(() {
      samplePlots.add({
        "area": TextEditingController(),
        "trees": <Map<String, TextEditingController>>[
          {
            "name": TextEditingController(),
            "circumference": TextEditingController(),
            "height": TextEditingController(),
          },
        ],
      });
    });
  }

  void addTreeForm(int plotIndex) {
    setState(() {
      samplePlots[plotIndex]["trees"].add({
        "name": TextEditingController(),
        "circumference": TextEditingController(),
        "height": TextEditingController(),
      });
    });
  }

  Future<void> SaveSampleplot() async {
    final treesRef = treeDB.child("Normalplot/${widget.plotId}/samplePlots");
    final snapshot = await treesRef.get();
    int nextId = 1;
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      nextId = data.length + 1;
    }

    for (int i = 0; i < samplePlots.length; i++) {
      final plot = samplePlots[i];
      final sampleId = "SamplePlot${nextId + i}";
      final sampleData = {
        "plotArea": double.parse(plot["area"].text),
        "trees": {},
      };
      final trees = plot["trees"] as List<Map<String, TextEditingController>>;
      for (int j = 0; j < trees.length; j++) {
        final controller = trees[j];
        final treeId = "Tree${j + 1}";
        (sampleData["trees"] as Map)[treeId] = {
          "UserID": widget.userId,
          "name": controller["name"]!.text,
          "circumference": double.parse(controller["circumference"]!.text),
          "height": double.parse(controller["height"]!.text),
        };
      }
      await treesRef.child(sampleId).set(sampleData);
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('บันทึกแปลงตัวอย่างเรียบร้อยแล้ว')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("เพิ่มแปลงตัวอย่าง")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              ...samplePlots.asMap().entries.map((plotEntry) {
                int plotIndex = plotEntry.key;
                final plot = plotEntry.value;
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "แปลงตัวอย่างที่ ${plotIndex + 1}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextFormField(
                          controller: plot["area"],
                          decoration: InputDecoration(
                            labelText: "ขนาดแปลงตัวอย่าง (m²)",
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value!.isEmpty ? "กรุณากรอกขนาดแปลง" : null,
                        ),
                        ...plot["trees"].asMap().entries.map((treeEntry) {
                          int treeIndex = treeEntry.key;
                          final controllers = treeEntry.value;
                          return Card(
                            color: Colors.green[50],
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Text("ต้นไม้ตัวอย่างที่ ${treeIndex + 1}"),
                                  TextFormField(
                                    controller: controllers["name"],
                                    decoration: InputDecoration(
                                      labelText: "ชื่อพันธุ์ไม้",
                                    ),
                                  ),
                                  TextFormField(
                                    controller: controllers["circumference"],
                                    decoration: InputDecoration(
                                      labelText: "เส้นรอบวง (ซม.)",
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  TextFormField(
                                    controller: controllers["height"],
                                    decoration: InputDecoration(
                                      labelText: "ความสูง (เมตร)",
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => addTreeForm(plotIndex),
                            icon: Icon(Icons.add, color: Colors.green),
                            label: Text("เพิ่มต้นไม้ตัวอย่าง"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              ElevatedButton.icon(
                onPressed: addSamplePlot,
                icon: Icon(Icons.add_box, color: Colors.blue),
                label: Text("เพิ่มแปลงตัวอย่าง"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: SaveSampleplot,
                child: Text("บันทึกแปลงตัวอย่างทั้งหมด"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
