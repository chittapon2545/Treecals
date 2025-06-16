import 'package:flutter/material.dart';
import 'package:treecals/Services/Individaultree.dart';

class TreeWidget extends StatefulWidget {
  final String ID;
  const TreeWidget({super.key, required this.ID});

  @override
  State<TreeWidget> createState() => _TreeWidgetState();
}

class _TreeWidgetState extends State<TreeWidget> {
  IndividaultreeService treeService = IndividaultreeService();
  String _ID = "";
  List<Map<String, dynamic>> myTrees = [];

  @override
  void initState() {
    super.initState();
    _ID = widget.ID;
    loadTrees();
  }

  Future<void> loadTrees() async {
    final Tree = await IndividaultreeService().getTreesAndCreditsByUser(_ID);
    setState(() {
      myTrees = Tree;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: myTrees.isEmpty
            ? [
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 50, right: 50),
                  child: TextButton(
                    onPressed: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text("เพิ่มข้อมูลต้นไม้"),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]
            : myTrees.map((tree) {
                return Padding(
                  padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: TextButton(
                    onPressed: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width,

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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
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
                              Text("สายพันธุ์:  ${tree['groupName'] ?? '-'}"),
                              Text(
                                "คาร์บอนเครดิต: ${tree['credit']?['Credit'] ?? '-'}",
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(Icons.arrow_forward, size: 24),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
      ),
    );
  }
}
