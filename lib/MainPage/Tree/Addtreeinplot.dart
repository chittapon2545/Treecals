import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:treecals/Services/Calculator.dart';

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

  Future<void> CalCarbonCredit() async {
    final plotRef = treeDB.child("Normalplot/${widget.plotId}");
    final plotsnapshot = await plotRef.get();
    if (!plotsnapshot.exists) return;
    final plotdata = Map<String, dynamic>.from(plotsnapshot.value as Map);
    final double Rai = (plotdata["area"] as num).toDouble();
    final double plotAreaM2 = Rai * 1600;

    final sampleRef = plotRef.child("samplePlots");
    final snapshot = await sampleRef.get();
    if (!snapshot.exists) return;
    final data = Map<String, dynamic>.from(snapshot.value as Map);

    List<double> carbonDensityList = [];
    List<double> sampleAreaList = [];

    data.forEach((sampleId, sampleData) {
      final plotArea = (sampleData["plotArea"] as num).toDouble();
      final trees = Map<String, dynamic>.from(sampleData["trees"] ?? {});
      if (plotArea <= 0 || trees.isEmpty) return;
      double plotCarbon = 0.0;
      int treeCount = 0;
      trees.forEach((treeId, treeData) {
        final circumference = (treeData["circumference"] as num).toDouble();
        final height = (treeData["height"] as num).toDouble();
        final result = BiomassCalculator.calculate(
          widget.group,
          circumference,
          height,
        );
        if (result != null) {
          plotCarbon = result.carbon + plotCarbon;
          treeCount++;
        }
      });
      if (treeCount == 0) return;

      double density = trees.length / plotArea; //จำนวนต้น / ขนาดแปลง
      double avgCarbonPerTree = plotCarbon / trees.length; //คาร์บอนเฉลี่ยต่อต้น
      double carbonPerM2 =
          (avgCarbonPerTree / 1000) * density; //คาร์บอนต่อตารางเมตร

      carbonDensityList.add(carbonPerM2);
      sampleAreaList.add(plotArea);
    });
    // ===== คำนวณ meanCarbonDensity =====
    double meanCarbonDensity = 0.0;
    if (carbonDensityList.isNotEmpty) {
      double weightedSum = 0.0;
      double areaSum = 0.0;
      for (int i = 0; i < carbonDensityList.length; i++) {
        weightedSum += carbonDensityList[i] * sampleAreaList[i];
        areaSum += sampleAreaList[i];
      }
      if (areaSum > 0) {
        meanCarbonDensity = weightedSum / areaSum; // weighted mean
      } else {
        meanCarbonDensity =
            carbonDensityList.reduce((a, b) => a + b) /
            carbonDensityList.length;
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ไม่มีข้อมูลในแปลงตัวอย่าง')));
      return;
    }
    double totalCarbon = meanCarbonDensity * plotAreaM2; // tC
    double credits = totalCarbon * 3.67;
    await plotRef.update({"CS": totalCarbon, "Credit": credits});
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "แปลงตัวอย่างที่ ${plotIndex + 1}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  samplePlots.removeAt(plotIndex);
                                });
                              },
                            ),
                          ],
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "ต้นไม้ตัวอย่างที่ ${treeIndex + 1}",
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            samplePlots[plotIndex]["trees"]
                                                .removeAt(treeIndex);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
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
                onPressed: () async {
                  await SaveSampleplot();
                  await CalCarbonCredit();
                },
                child: Text("บันทึกแปลงตัวอย่างทั้งหมด"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
