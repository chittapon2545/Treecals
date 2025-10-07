import 'package:flutter/material.dart';
import 'package:treecals/MainPage/NavigatorBar.dart';
import 'package:treecals/Services/ConvertPassword.dart';
import 'package:treecals/Services/User.dart';

class EditpassPage extends StatefulWidget {
  final String ID; // เปลี่ยน int เป็น String
  const EditpassPage({super.key, required this.ID});

  @override
  State<EditpassPage> createState() => _EditpassPageState();
}

class _EditpassPageState extends State<EditpassPage> {
  UserService userService = UserService();
  ConvertPassword convert = ConvertPassword();
  TextEditingController _oldPasswordEditController = TextEditingController();
  TextEditingController _newPasswordEditController = TextEditingController();
  TextEditingController _checkPasswordEditController = TextEditingController();
  late String _ID; // เปลี่ยน int เป็น String
  String oldPassword = "";
  String newPassword = "";
  String checkPassword = "";
  bool _obscureText = true;
  @override
  void initState() {
    super.initState();
    _ID = widget.ID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/images/colorbackground.jpg",
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0xFF007FFF),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(100),
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 2, top: 30),
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NavigatorPage(
                                        state1: 3,
                                        ID: _ID.toString(),
                                      ),
                                    ),
                                    (route) => false,
                                  );
                                },
                                icon: Icon(Icons.arrow_back, size: 30),
                                style: ButtonStyle(
                                  iconColor: MaterialStateProperty.all<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 40, left: 15),
                            child: Text(
                              "เปลี่ยนรหัสผ่าน",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 40, right: 40),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: _oldPasswordEditController,
                      obscureText: _obscureText,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "รหัสผ่านปัจจุบัน",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 40, right: 40),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: _newPasswordEditController,
                      obscureText: _obscureText,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "รหัสผ่านใหม่",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 40, right: 40),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: _checkPasswordEditController,
                      obscureText: _obscureText,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "ยืนยันรหัสผ่านอีกครั้ง",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 70),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 150,
                  height: 50,
                  child: TextButton(
                    onPressed: () async {
                      setState(() {
                        oldPassword = _oldPasswordEditController.text.trim();
                        newPassword = _newPasswordEditController.text.trim();
                        checkPassword = _checkPasswordEditController.text
                            .trim();
                      });
                      if (oldPassword.isEmpty ||
                          newPassword.isEmpty ||
                          checkPassword.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("กรุณากรอกข้อมูลให้ครบถ้วน"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if (newPassword != checkPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("รหัสผ่านใหม่ไม่ตรงกัน"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      final passwordData = await userService.Repassword(
                        _ID,
                        oldPassword,
                      );
                      if (passwordData == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("รหัสผ่านปัจจุบันไม่ถูกต้อง"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if (passwordData != null &&
                          _newPasswordEditController.text.trim() ==
                              _checkPasswordEditController.text.trim()) {
                        convert.updatePasswordHash(_ID, newPassword);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("เปลี่ยนรหัสผ่านสำเร็จ"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "บันทึก",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 150,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "ย้อนกลับ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
