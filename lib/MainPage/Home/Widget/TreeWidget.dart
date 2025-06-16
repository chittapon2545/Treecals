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
    if (myTrees.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 20, left: 32, right: 32),
        child: TextButton(
          onPressed: () {},
          child: Container(
            height: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
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
      );
    }

    // ถ้ามีข้อมูลต้นไม้
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: myTrees.length,
            itemBuilder: (context, index) {
              final tree = myTrees[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Container(
                    padding: const EdgeInsets.all(16),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ชื่อ: ${tree['tree']?['name'] ?? '-'}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                              Text(
                                "เส้นรอบวง: ${tree['tree']?['Circumference'] ?? '-'} ซม.",
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                              Text(
                                "ความสูง: ${tree['tree']?['Height'] ?? '-'} ม.",
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                              Text(
                                "สายพันธุ์:  ${tree['groupName'] ?? '-'}",
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                              Text(
                                "คาร์บอนเครดิต: ${tree['credit']?['Credit'] ?? '-'}",
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
