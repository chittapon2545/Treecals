import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddTreePage extends StatefulWidget {
  final String ID; // ต้องเป็น String
  const AddTreePage({super.key, required this.ID});

  @override
  State<AddTreePage> createState() => _AddTreePageState();
}

class _AddTreePageState extends State<AddTreePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _circumferenceController = TextEditingController();
  final _heightController = TextEditingController();
  final _groupIdController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<void> _addTree() async {
    try {
      if (_formKey.currentState!.validate()) {
        // 1. เพิ่ม locationindividualtrees ก่อน
        DatabaseReference locationRef = _dbRef.child('locationindividualtrees');
        DatabaseReference treesRef = _dbRef.child('individualtrees');

        // 2. อ่าน Itree ล่าสุด
        DataSnapshot snapshot = await treesRef.get();
        int newTreeNum = 1;
        if (snapshot.exists) {
          final keys = (snapshot.value as Map).keys
              .where((k) => k.toString().startsWith('Itree'))
              .map((k) => int.tryParse(k.toString().replaceFirst('Itree', '')))
              .where((n) => n != null)
              .toList();
          if (keys.isNotEmpty) {
            keys.sort();
            newTreeNum = keys.last! + 1;
          }
        }
        final newTreeKey = "Itree$newTreeNum";

        // 3. เพิ่ม locationindividualtrees แล้วเก็บ key
        DatabaseReference newLocationRef = locationRef.push();
        await newLocationRef.set({
          "TreeID": "Itree$newTreeNum",
          "Latitude": double.tryParse(_latitudeController.text) ?? 0,
          "Longitude": double.tryParse(_longitudeController.text) ?? 0,
        });
        String locationId = newLocationRef.key!;

        // 4. เพิ่ม individualtrees โดยใช้ key ที่กำหนดเอง
        await treesRef.child(newTreeKey).set({
          "Circumference": double.tryParse(_circumferenceController.text) ?? 0,
          "Group_ID": int.tryParse(_groupIdController.text) ?? 1,
          "Height": double.tryParse(_heightController.text) ?? 0,
          "LocationId": locationId,
          "UserID": widget.ID,
          "name": _nameController.text,
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('เพิ่มข้อมูลต้นไม้สำเร็จ')));
        Navigator.pop(context);
        _formKey.currentState!.reset();
      }
    } catch (e) {
      print('เกิดข้อผิดพลาด: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เพิ่มต้นไม้')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'ชื่อ'),
                validator: (value) => value!.isEmpty ? 'กรุณากรอกชื่อ' : null,
              ),
              TextFormField(
                controller: _circumferenceController,
                decoration: InputDecoration(labelText: 'เส้นรอบวง'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกเส้นรอบวง' : null,
              ),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'ความสูง'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกความสูง' : null,
              ),
              TextFormField(
                controller: _groupIdController,
                decoration: InputDecoration(labelText: 'ชนิด'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอก Group_ID' : null,
              ),
              TextFormField(
                controller: _latitudeController,
                decoration: InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอก Latitude' : null,
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอก Longitude' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _addTree, child: Text('บันทึก')),
            ],
          ),
        ),
      ),
    );
  }
}
