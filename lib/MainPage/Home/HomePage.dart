import 'package:flutter/material.dart';
import 'package:treecals/Services/User.dart';
import 'package:treecals/Services/Individaultree.dart';

class HomePage extends StatefulWidget {
  final int ID;
  const HomePage({super.key, required this.ID});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserService userService = UserService();
  IndividaultreeService treeService = IndividaultreeService();
  late int _ID;
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
    myTrees = await IndividaultreeService().getTreesAndCreditsByUser(
      _ID,
    ); // _ID คือ userId ที่ล็อกอิน
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
          child: _state == 2
              ? SingleChildScrollView(
                  child: Column(
                    children: myTrees.isEmpty
                        ? [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "ยังไม่มีข้อมูลต้นไม้เดี่ยว",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ]
                        : myTrees.map((tree) {
                            return Container(
                              width: MediaQuery.of(context).size.width - 100,
                              margin: EdgeInsets.only(
                                left: 0,
                                right: 8,
                                top: 8,
                                bottom: 8,
                              ),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "ชื่อ: ${tree['tree']?['name'] ?? '-'}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "เส้นรอบวง: ${tree['tree']?['Circumference'] ?? '-'} ซม.",
                                  ),
                                  Text(
                                    "ความสูง: ${tree['tree']?['Height'] ?? '-'} ม.",
                                  ),
                                  Text(
                                    "สายพันธุ์:  ${tree['groupName'] ?? '-'}",
                                  ),
                                  Text(
                                    "คาร์บอนเครดิต: ${tree['credit']?['Credit'] ?? '-'}",
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                  ),
                )
              : Container(), // กรณี _state != 2 ไม่แสดงอะไร
        ),
      ],
    );
  }
}
