import 'package:flutter/material.dart';
import 'package:treecals/Login/loginPage.dart';
import 'package:treecals/MainPage/Profile/EditChoicePage.dart';
import 'package:treecals/Services/User.dart';

class ProfilePage extends StatefulWidget {
  final int ID;
  const ProfilePage({super.key, required this.ID});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserService userService = UserService();
  late int _ID;
  String name = "";
  String username = "";
  String phone = "";
  String email = "";
  String address = "";
  @override
  void initState() {
    super.initState();
    _ID = widget.ID;
    readUserData();
  }

  void readUserData() async {
    final userData = await userService.UserData(_ID);
    if (userData != null) {
      setState(() {
        name = "${userData['Firstname']} ${userData['Lastname']}";
        username = "${userData['Username']}";
        phone = "${userData['Phone']}";
        email = "${userData['Email']}";
        address = "${userData['Address']}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),
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
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  "ข้อมูลผู้ใช้งาน",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 420,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Text(
                        "ชื่อ : ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(name),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Text(
                        "ชื่อผู้ใช้งาน : ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(username),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Text(
                        "เบอร์โทร : ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(phone),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Text(
                        "อีเมล : ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(email),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "ที่อยู่ : ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ), // ถ้าต้องการเน้นหัว
                        ),
                        TextSpan(text: address),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
        SizedBox(
          width: MediaQuery.of(context).size.width - 80,
          height: 50,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChoicePage(ID: _ID)),
              );
            },
            child: Text(
              "แก้ไขข้อมูล",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        SizedBox(
          width: MediaQuery.of(context).size.width - 130,
          height: 50,
          child: TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            },
            child: Text(
              "ออกจากระบบ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
