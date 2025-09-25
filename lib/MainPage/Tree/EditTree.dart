import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:treecals/MainPage/Tree/Mappick.dart';
import 'package:treecals/Services/Calculator.dart';
import 'package:treecals/Services/Individaultree.dart';

class EditTree extends StatefulWidget {
  final String userId;
  final String treeId;
  final Map<String, dynamic> tree;
  const EditTree({
    super.key,
    required this.userId,
    required this.treeId,
    required this.tree,
  });
  @override
  State<EditTree> createState() => _EditTreeState();
}

class _EditTreeState extends State<EditTree> {
  final formKey = GlobalKey<FormState>();
  final IndividaultreeService treeService = IndividaultreeService();

  late TextEditingController nameController;
  late TextEditingController circumferenceController;
  late TextEditingController heightController;
  late String treeName;
  String? groupId;
  LatLng? Location;

  @override
  void initState() {
    super.initState();
    final treeData = widget.tree['tree'] ?? {};
    treeName = treeData['name']?.toString() ?? '';

    nameController = TextEditingController(
      text: treeData['name']?.toString() ?? '',
    );
    circumferenceController = TextEditingController(
      text: treeData['Circumference']?.toString() ?? '',
    );
    heightController = TextEditingController(
      text: treeData['Height']?.toString() ?? '',
    );
    groupId = treeData['Group_ID']?.toString() ?? 'G1';

    if (treeData['Latitude'] != null && treeData['Longitude'] != null) {
      Location = LatLng(
        double.tryParse(treeData['Latitude'].toString()) ?? 0,
        double.tryParse(treeData['Longitude'].toString()) ?? 0,
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    circumferenceController.dispose();
    heightController.dispose();
    super.dispose();
  }

  Future<void> _saveTree() async {
    if (!formKey.currentState!.validate()) return;

    final double circumference =
        double.tryParse(circumferenceController.text) ?? 0;
    final double height = double.tryParse(heightController.text) ?? 0;

    if (groupId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("กรุณาเลือกกลุ่ม")));
      return;
    }

    final biomass = BiomassCalculator.calculate(
      groupId!,
      circumference,
      height,
    );
    if (biomass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ไม่สามารถคำนวณค่าคาร์บอนได้")),
      );
      return;
    }

    final updatedData = {
      'name': nameController.text,
      'Circumference': circumference,
      'Height': height,
      'Group_ID': groupId,
      'Credit': biomass.carbon,
      'Latitude': Location?.latitude,
      'Longitude': Location?.longitude,
    };

    await treeService.updateTree(widget.userId, widget.treeId, updatedData);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("แก้ไขข้อมูลเรียบร้อย")));
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('แก้ไขต้นไม้ $treeName')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'ชื่อ'),
                validator: (value) =>
                    value == null || value.isEmpty ? "กรุณากรอกชื่อ" : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: groupId,
                items: const [
                  DropdownMenuItem(
                    value: 'G1',
                    child: Text("G1 - พรรณไม้ทั่วไป"),
                  ),
                  DropdownMenuItem(value: 'G2', child: Text("G2 - ปาล์ม")),
                  DropdownMenuItem(value: 'G3', child: Text("G3 - เถาวัลย์")),
                  DropdownMenuItem(value: 'G4', child: Text("G4 - ไผ่")),
                ],
                onChanged: (v) => setState(() => groupId = v),
                decoration: const InputDecoration(labelText: "กลุ่มพรรณไม้"),
                validator: (v) => v == null ? "กรุณาเลือกกลุ่ม" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: circumferenceController,
                decoration: const InputDecoration(labelText: "เส้นรอบวง (ซม.)"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? "กรุณากรอกเส้นรอบวง" : null,
              ),
              TextFormField(
                controller: heightController,
                decoration: const InputDecoration(labelText: "ความสูง (ม.)"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? "กรุณากรอกความสูง" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  final selectedlocation = await Navigator.push<LatLng?>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapPickerPage(
                        initialPosition: Location,
                        userId: widget.userId,
                      ),
                    ),
                  );
                  if (selectedlocation != null) {
                    setState(() {
                      Location = selectedlocation;
                    });
                  }
                },
                icon: Icon(Icons.map),
                label: Text(
                  Location == null ? "เลือกตำแหน่งที่ตั้ง" : "แก้ไขตำแหน่ง",
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // ปุ่มบันทึก (ซ้าย)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _saveTree,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'บันทึกการแก้ไข',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12), // ใช้ width เพื่อเว้นระยะปุ่ม
                  // ปุ่มลบ (ขวา)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("ยืนยันการลบ"),
                            content: const Text(
                              "คุณแน่ใจว่าต้องการลบต้นไม้นี้หรือไม่?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("ยกเลิก"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  "ลบ",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm != null && confirm) {
                          await treeService.deleteTree(
                            widget.userId,
                            widget.treeId,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("ลบต้นไม้เรียบร้อย")),
                          );

                          Navigator.pop(context, true);
                        }
                      },
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text(
                        "ลบต้นไม้",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
