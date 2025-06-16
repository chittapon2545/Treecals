import 'package:flutter/material.dart';
import 'package:treecals/MainPage/Home/Widget/PlotWidget.dart';
import 'package:treecals/MainPage/Home/Widget/TreeWidget.dart';
import 'package:treecals/Services/User.dart';
import 'package:treecals/Services/Individaultree.dart';

class HomePage extends StatefulWidget {
  final String ID; // เปลี่ยนจาก int เป็น String
  const HomePage({super.key, required this.ID});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserService userService = UserService();
  IndividaultreeService treeService = IndividaultreeService();
  late String _ID; // เปลี่ยนจาก int เป็น String
  String name = "";
  int _state = 1;
  List<Map<String, dynamic>> myTrees = [];

  @override
  void initState() {
    super.initState();
    _ID = widget.ID;
    readName();
    loadTrees();
  }

  void readName() async {
    final userData = await userService.UserData(_ID);
    if (userData != null) {
      setState(() {
        name = "${userData['Firstname']} ${userData['Lastname']}";
      });
    }
  }

  Future<void> loadTrees() async {
    myTrees = await IndividaultreeService().getTreesAndCreditsByUser(_ID);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
          decoration: BoxDecoration(
            color: Color(0xFF4B1EFF),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 40, top: 30),
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Image.asset("assets/images/logo.png"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20, top: 30),
                    child: Container(
                      height: 50,
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "${name}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 220,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 40,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            setState(() {
                              _state = 1;
                            });
                          });
                        },
                        child: Text(
                          "แปลง",
                          style: TextStyle(
                            color: _state == 1 ? Colors.white : Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: _state == 1
                              ? Color(0xFF1D34FE)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 40,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            setState(() {
                              _state = 2;
                            });
                          });
                        },
                        child: Text(
                          "ต้นเดี่ยว",
                          style: TextStyle(
                            color: _state == 2 ? Colors.white : Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: _state == 2
                              ? Color(0xFF1D34FE)
                              : Colors.white,
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
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 435,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 231, 223, 223),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
          ),
          child: _state == 1 ? PlotWidget(ID: _ID) : TreeWidget(ID: _ID),
        ),
      ],
    );
  }
}
