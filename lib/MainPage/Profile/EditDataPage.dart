import 'package:flutter/material.dart';
import 'package:treecals/MainPage/NavigatorBar.dart';
import 'package:treecals/Services/User.dart';

class EditdataPage extends StatefulWidget {
  final String ID; // เปลี่ยน int เป็น String
  const EditdataPage({super.key, required this.ID});

  @override
  State<EditdataPage> createState() => _EditdataPageState();
}

class _EditdataPageState extends State<EditdataPage> {
  UserService userService = UserService();
  late String _ID; // เปลี่ยน int เป็น String
  TextEditingController Fname = TextEditingController();
  TextEditingController Lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  String firstname = "";
  String lastname = "";
  String email1 = "";
  String address1 = "";
  @override
  void initState() {
    super.initState();
    _ID = widget.ID;
    readData();
  }

  void readData() async {
    final userData = await userService.UserData(_ID); // ส่ง String
    if (userData != null) {
      Fname.text = "${userData['Firstname']}";
      Lname.text = "${userData['Lastname']}";
      email.text = "${userData['Email']}";
      address.text = "${userData['Address']}";
    }
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
                                        ID: _ID,
                                      ), // ส่ง String
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
                              "แก้ไขข้อมูลส่วนตัว",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 40, top: 30),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 50,
                        child: TextField(
                          controller: Fname,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "ชื่อ",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 40, top: 30),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 50,
                        child: TextField(
                          controller: Lname,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "นามสกุล",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 40, right: 40),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: email,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "อีเมล",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 40, right: 40),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 130,
                    child: TextField(
                      controller: address,
                      style: TextStyle(color: Colors.black),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "ที่อยู",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 0),
                          borderRadius: BorderRadius.circular(15),
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
                      String firstname = Fname.text.trim();
                      String lastname = Lname.text.trim();
                      String email1 = email.text.trim();
                      String address1 = address.text.toString();

                      final result = await userService.updateUserData(
                        _ID, // ส่ง String
                        firstname,
                        lastname,
                        email1,
                        address1,
                      );
                      if (result != null) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NavigatorPage(state1: 3, ID: _ID),
                          ),
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("ไม่สามารถอัปเดตข้อมูลได้")),
                        );
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
