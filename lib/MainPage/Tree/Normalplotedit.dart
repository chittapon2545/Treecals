import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:treecals/MainPage/Tree/Mappolygon.dart';
import 'package:treecals/Services/Calculator.dart';

class Normalplotedit extends StatefulWidget {
  final String userID;
  final String plotID;
  final Map<String, dynamic> plotData;
  const Normalplotedit({
    super.key,
    required this.userID,
    required this.plotID,
    required this.plotData,
  });

  @override
  State<Normalplotedit> createState() => _NormalploteditState();
}

class _NormalploteditState extends State<Normalplotedit> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController areaController;

  List<Map<String, String>> groups = [];
  String? selectedGroupId;
  List<LatLng> polygonPoints = [];
  Map<String, dynamic> samplePlots = {};
  final db = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.plotData['name'] ?? '');
    areaController = TextEditingController(
      text: widget.plotData['area'].toString() ?? '',
    );
    selectedGroupId = widget.plotData['group'] ?? null;
    polygonPoints = (widget.plotData["polygon"] as List)
        .map((p) => LatLng(p["latitude"], p["longitude"]))
        .toList();
    samplePlots = Map<String, dynamic>.from(
      widget.plotData["samplePlots"] ?? {},
    );
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final groupRef = db.child('groups');
    final snapshot = await groupRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      setState(() {
        groups = data.entries
            .map<Map<String, String>>(
              (e) => {'id': e.key, 'name': e.value['name'] ?? ''},
            )
            .toList();
      });
    }
  }

  Future<void> pickPolygon() async {
    final selectedPoints = await Navigator.push<List<LatLng>>(
      context,
      MaterialPageRoute(builder: (context) => MapSample(userId: widget.userID)),
    );

    if (selectedPoints != null) {
      setState(() {
        polygonPoints = selectedPoints;
      });
    }
  }

  void deleteTree(String sampleId, String treeId) {
    setState(() {
      (samplePlots[sampleId]["trees"] as Map).remove(treeId);
    });
  }

  void addsampleplot() {
    setState(() {
      final id = "SamplePlot${samplePlots.length + 1}";
      samplePlots[id] = {"plotArea": 0.0, "trees": <String, dynamic>{}};
    });
  }

  void addTree(String sampleId) {
    setState(() {
      final trees = Map<String, dynamic>.from(
        samplePlots[sampleId]["trees"] ?? {},
      );
      final id = "Tree${trees.length + 1}";
      trees[id] = {"name": "", "circumference": 0.0, "height": 0.0};
      samplePlots[sampleId]["trees"] = trees;
    });
  }

  void deleteSamplePlot(String sampleId) {
    setState(() {
      samplePlots.remove(sampleId);
    });
  }

  void updatePlot() async {
    final normalplotdb = db.child("Normalplot/${widget.plotID}");

    //พื้นที่แปลงทั้งหมด (จากไร่ -> m²)
    final double rai =
        double.tryParse(areaController.text) ??
        (widget.plotData["area"] as num?)?.toDouble() ??
        0.0;
    final double plotAreaM2 = rai * 1600.0;

    //เก็บ carbon density ของแต่ละ samplePlot (tC / m²)
    List<double> carbonDensityList = [];
    List<double> sampleAreaList = [];

    samplePlots.forEach((sampleId, sampleData) {
      final double plotArea =
          (sampleData["plotArea"] as num?)?.toDouble() ?? 0.0;
      final trees = Map<String, dynamic>.from(sampleData["trees"] ?? {});

      if (plotArea <= 0 || trees.isEmpty) {
        return;
      }
      double plotCarbon = 0.0;
      int treeCount = 0;

      trees.forEach((treeId, treeData) {
        final double circumference =
            (treeData["circumference"] as num?)?.toDouble() ?? 0.0;
        final double height = (treeData["height"] as num?)?.toDouble() ?? 0.0;

        final result = BiomassCalculator.calculate(
          selectedGroupId ?? widget.plotData['group'] ?? '',
          circumference,
          height,
        );

        if (result != null) {
          plotCarbon += result.carbon;
          treeCount++;
        }
      });

      if (treeCount == 0) return;

      double density = treeCount / plotArea; //ความหนาแน่นต้นไม้
      double avgCarbonPerTree = plotCarbon / treeCount; //คาร์บอนเฉลี่ยต่อต้น
      double carbonPerM2 =
          (avgCarbonPerTree / 1000.0) * density; //คาร์บอนต่อตารางเมตร

      carbonDensityList.add(carbonPerM2);
      sampleAreaList.add(plotArea);
    });
    double meanCarbonDensity = 0.0;
    if (carbonDensityList.isNotEmpty) {
      // weighted mean
      double weightedSum = 0.0;
      double areaSum = 0.0;
      meanCarbonDensity = 0.0;
      for (int i = 0; i < carbonDensityList.length; i++) {
        weightedSum += (carbonDensityList[i] * sampleAreaList[i]);
        areaSum += sampleAreaList[i];
      }
      if (areaSum > 0) {
        meanCarbonDensity = weightedSum / areaSum;
      } else {
        meanCarbonDensity =
            carbonDensityList.reduce((a, b) => a + b) /
            carbonDensityList.length;
      }
    } else {
      meanCarbonDensity = 0.0;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่มีข้อมูลต้นไม้ในแปลงตัวอย่าง')),
      );
    }

    final double totalCarbon =
        meanCarbonDensity * plotAreaM2; //คาร์บอนรวมในแปลง (tC)
    final double credits = totalCarbon * 3.67; //คำนวณเป็น CO2e\

    final polygonJson = polygonPoints
        .map((p) => {"latitude": p.latitude, "longitude": p.longitude})
        .toList();
    await normalplotdb.update({
      "name": nameController.text,
      "area": rai,
      "group": selectedGroupId,
      "polygon": polygonJson,
      "samplePlots": samplePlots,
      "CS": totalCarbon, // tC
      "Credit": credits, // tCO2e
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'บันทึกเสร็จ — CS: ${totalCarbon.toStringAsFixed(3)}, Credit: ${credits.toStringAsFixed(3)}',
        ),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final SamplePlots = samplePlots.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Scaffold(
      appBar: AppBar(title: Text('แก้ไขแปลงปกติ')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'ชื่อแปลง'),
            validator: (value) =>
                value == null || value.isEmpty ? "กรุณากรอกชื่อแปลง" : null,
          ),
          TextFormField(
            controller: areaController,
            decoration: InputDecoration(labelText: 'ขนาดแปลง (ไร่)'),
            keyboardType: TextInputType.number,
            validator: (value) =>
                value == null || value.isEmpty ? "กรุณากรอกขนาดไร่" : null,
          ),
          DropdownButtonFormField(
            value: selectedGroupId,
            decoration: InputDecoration(labelText: 'ชนิด (Group)'),
            items: groups
                .map(
                  (group) => DropdownMenuItem<String>(
                    value: group['id'],
                    child: Text(group['name'] ?? ''),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedGroupId = value;
              });
            },
            validator: (value) => value == null ? 'กรุณาเลือกชนิด' : null,
          ),
          ListTile(
            title: Text('ตำแหน่งที่ตั้ง (Location)'),
            trailing: Icon(Icons.map),
            onTap: pickPolygon,
          ),
          Divider(
            color: Colors.grey, // สีของเส้น
            thickness: 5, // ความหนา
            indent: 10, // ระยะห่างจากซ้าย
            endIndent: 10, // ระยะห่างจากขวา
            height: 40, // ความสูงรวม (มีผลกับ spacing)
          ),
          Text(
            "Sample Plots",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          ...SamplePlots.asMap().entries.map((entry) {
            final index = entry.key;
            final sp = entry.value;
            final sampleID = sp.key;
            final sampleData = Map<String, dynamic>.from(sp.value);
            final trees = Map<String, dynamic>.from(sampleData['trees'] ?? {});

            return ExpansionTile(
              title: Text(
                "แปลงตัวอย่างที่ ${index + 1} (พื้นที่ ${sampleData["plotArea"]} m²)",
              ),
              children: [
                TextFormField(
                  initialValue: sampleData["plotArea"]?.toString() ?? "0",
                  decoration: InputDecoration(labelText: 'ขนาดแปลง (m²)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      samplePlots[sampleID]["plotArea"] =
                          double.tryParse(value) ?? 0.0;
                    });
                  },
                ),

                ...trees.entries.map((t) {
                  final treeID = t.key;
                  final treeData = Map<String, dynamic>.from(t.value);
                  return Card(
                    child: ListTile(
                      title: TextFormField(
                        decoration: InputDecoration(labelText: "ชื่อต้นไม้"),
                        initialValue: treeData["name"] ?? "",
                        onChanged: (val) {
                          setState(() {
                            samplePlots[sampleID]["trees"][treeID]["name"] =
                                val;
                          });
                        },
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'เส้นรอบวง (ซม.)',
                            ),
                            initialValue: (treeData["circumference"] ?? 0)
                                .toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                samplePlots[sampleID]["trees"][treeID]["circumference"] =
                                    double.tryParse(value) ?? 0.0;
                              });
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'ความสูง (ม.)',
                            ),
                            initialValue: (treeData["height"] ?? 0).toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                samplePlots[sampleID]["trees"][treeID]["height"] =
                                    double.tryParse(value) ?? 0.0;
                              });
                            },
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteTree(sampleID, treeID),
                      ),
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: () => addTree(sampleID),
                  icon: Icon(Icons.add, color: Colors.green),
                  label: Text("เพิ่มต้นไม้"),
                ),
                TextButton.icon(
                  onPressed: () => deleteSamplePlot(sampleID),
                  icon: Icon(Icons.delete, color: Colors.red),
                  label: Text("ลบ แปลงตัวอย่างนี้"),
                ),
              ],
            );
          }),
          ElevatedButton.icon(
            onPressed: () => addsampleplot(),
            label: Text("เพิ่มแปลงตัวอย่าง"),
            icon: Icon(Icons.add, color: Colors.white),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => updatePlot(),
            label: Text("บันทึก"),
            icon: Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
