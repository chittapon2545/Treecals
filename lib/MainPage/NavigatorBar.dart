import 'package:flutter/material.dart';
import 'package:treecals/MainPage/Home/HomePage.dart';
import 'package:treecals/MainPage/Profile/ProfilePage.dart';
import 'package:treecals/MainPage/Tree/TreePage.dart';

class NavigatorPage extends StatefulWidget {
  final int state1;
  final int ID;
  const NavigatorPage({super.key, required this.state1, required this.ID});

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  late int _ID;
  int _state = 0;
  @override
  void initState() {
    super.initState();
    _state = widget.state1;
    _ID = widget.ID;
  }

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
            child: Column(
              children: [
                Container(
                  child:
                      _state == 1
                          ? TreePage(ID: _ID)
                          : _state == 2
                          ? HomePage(ID: _ID)
                          : ProfilePage(ID: _ID),
                ),
                SizedBox(height: 90),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 90,
              color: Color(0xFF022BF9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _state == 1 ? Color(0xFF08FF14) : Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _state = 1;
                        });
                      },
                      icon: Icon(Icons.add),
                      color: Colors.black,
                      iconSize: 40,
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _state == 2 ? Color(0xFF08FF14) : Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _state = 2;
                        });
                      },
                      icon: Icon(Icons.home),
                      color: Colors.black,
                      iconSize: 40,
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _state == 3 ? Color(0xFF08FF14) : Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _state = 3;
                        });
                      },
                      icon: Icon(Icons.person),
                      color: Colors.black,
                      iconSize: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
