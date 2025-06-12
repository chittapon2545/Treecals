import 'package:flutter/material.dart';
import 'package:treecals/Login/loginPage.dart';
import 'package:treecals/ResetPassword/Widget/RePassWidget1.dart';
import 'package:treecals/ResetPassword/Widget/RePassWidget2.dart';
import 'package:treecals/ResetPassword/Widget/RePassWidget3.dart';

class RePasswordPage extends StatefulWidget {
  const RePasswordPage({super.key});

  @override
  State<RePasswordPage> createState() => _RePasswordPageState();
}

class _RePasswordPageState extends State<RePasswordPage> {
  int _state = 1;
  final TextEditingController _phoneController = TextEditingController();

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
                        padding: EdgeInsets.only(top: 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 110,
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
                                  'กู้คืนรหัสผ่าน',
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
                                    ? RePassWidget1(
                                        phoneController: _phoneController,
                                      )
                                    : _state == 2
                                    ? RePassWidget2(
                                        phoneController: _phoneController,
                                      )
                                    : RePassWidget3(),
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
                                              } else if (_state == 2) {
                                                _state = 1;
                                              } else {
                                                _state = 2;
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
                                          onPressed: () {
                                            setState(() {
                                              if (_state == 1) {
                                                if (_phoneController.text
                                                        .trim()
                                                        .length ==
                                                    10) {
                                                  _state = 2;
                                                }
                                              } else if (_state == 2) {
                                                _state = 3;
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
                                          },
                                          child: Text(
                                            _state == 1 || _state == 2
                                                ? "ถัดไป"
                                                : "ยืนยัน",
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
