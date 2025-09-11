import 'package:flutter/material.dart';
import 'package:treecals/Services/PlotfastService.dart';

class PlotfastWidget extends StatefulWidget {
  final String ID;
  const PlotfastWidget({super.key, required this.ID});

  @override
  State<PlotfastWidget> createState() => _PlotfastWidgetState();
}

class _PlotfastWidgetState extends State<PlotfastWidget> {
  PlotfastService plotService = PlotfastService();
  List<Map<String, dynamic>> myPlots = [];

  @override
  void initState() {
    super.initState();
    loadPlots();
  }

  Future<void> loadPlots() async {
    final plots = await plotService.getPlotsByUser(widget.ID);
    setState(() {
      myPlots = plots;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (myPlots.isEmpty) {
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
                  child: Text("เพิ่มข้อมูลแปลง"),
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

    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: myPlots.length,
            itemBuilder: (context, index) {
              final plot = myPlots[index]["plot"];
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
                                "ชื่อแปลง: ${plot['name'] ?? '-'}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                              Text("ชนิดแปลง: แปลงเร็ว"),
                              Text("ระยะเวลา: ${plot['time'] ?? '-'} ปี"),
                              Text(
                                "จำนวนต้นไม้: ${plot['treenum'] ?? '-'} ต้น",
                              ),
                              Text(
                                "CTT: ${(plot['CTT'] as num?)?.toStringAsFixed(2) ?? '-'}",
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
