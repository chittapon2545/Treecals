import 'package:flutter/material.dart';
import 'package:treecals/Login/loginPage.dart';
import 'package:treecals/Register/Widget/registerWidget1.dart';
import 'package:treecals/Register/Widget/registerWidget2.dart';
import 'package:treecals/Services/ConvertPassword.dart';
import 'package:treecals/Services/User.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  ConvertPassword _convertPassword = ConvertPassword();
  UserService _userService = UserService();
  int _state = 1;

  TextEditingController _fname = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _password2 = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/images/colorbackground.jpg",
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Color(0xFF00F6FF),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(100),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color(0xFF0BF041),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(100),
                            ),
                          ),
                          padding: EdgeInsets.only(top: 35, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 50,
                                height: 20,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
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
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'สมัครสมาชิก',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 180,
                          decoration: BoxDecoration(
                            color: Color(0xFF007FFF),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(100),
                            ),
                          ),
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              Expanded(
                                child: _state == 1
                                    ? RegisWidget1(
                                        fname: _fname,
                                        lname: _lname,
                                        username: _username,
                                        password: _password,
                                        password2: _password2,
                                        address: _address,
                                        email: _email,
                                      )
                                    : RegisWidget2(phone: _phone),
                              ),
                              SizedBox(height: 40),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  height: 60,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2 -
                                            60,
                                        height: 50,
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              if (_state == 1) {
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage(),
                                                  ),
                                                  (route) => false,
                                                );
                                              } else {
                                                _state = 1;
                                              }
                                            });
                                          },
                                          child: Text(
                                            _state == 1 ? "ยกเลิก" : "ย้อนกลับ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            side: BorderSide(
                                              color: Colors.white,
                                              width: 0,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2 -
                                            60,
                                        height: 50,
                                        child: TextButton(
                                          onPressed: () async {
                                            String password = _password.text
                                                .trim();
                                            String fName = _fname.text.trim();
                                            String lname = _lname.text.trim();
                                            String username = _username.text
                                                .trim();
                                            String password2 = _password2.text
                                                .trim();
                                            String address = _address.text
                                                .trim();
                                            String email = _email.text.trim();
                                            String phone = _phone.text.trim();
                                            String? checkPassword =
                                                await _userService
                                                    .checkPassword(password);

                                            if (_state == 1) {
                                              if (checkPassword == null &&
                                                  fName.isNotEmpty &&
                                                  lname.isNotEmpty &&
                                                  username.isNotEmpty &&
                                                  password.isNotEmpty &&
                                                  password2.isNotEmpty &&
                                                  email.isNotEmpty &&
                                                  address.isNotEmpty &&
                                                  password == password2) {
                                                setState(() {
                                                  if (_state == 1) {
                                                    _state = 2;
                                                  } else {
                                                    Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginPage(),
                                                      ),
                                                      (route) => false,
                                                    );
                                                  }
                                                });
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "ข้อมูลไม่ถูกต้อง",
                                                    ),
                                                  ),
                                                );
                                              }
                                            } else {
                                              if (phone.length == 10) {
                                                password = _convertPassword
                                                    .hashPassword(password);
                                                _userService.insertUserAutoKey(
                                                  fName,
                                                  lname,
                                                  username,
                                                  password,
                                                  email,
                                                  address,
                                                  phone,
                                                );
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "ข้อมูลไม่ถูกต้อง",
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          child: Text(
                                            _state == 1 ? "ถัดไป" : "ยืนยัน",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            side: BorderSide(
                                              color: Colors.white,
                                              width: 0,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
