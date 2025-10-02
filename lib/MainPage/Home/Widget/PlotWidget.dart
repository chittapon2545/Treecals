import 'package:flutter/material.dart';
import 'package:treecals/MainPage/Tree/Normalplotedit.dart';
import 'package:treecals/MainPage/Tree/Plotfastedit.dart';
import 'package:treecals/Services/PlotService.dart';

class PlotWidget extends StatefulWidget {
  final String ID;
  const PlotWidget({super.key, required this.ID});

  @override
  State<PlotWidget> createState() => _PlotWidgetState();
}

class _PlotWidgetState extends State<PlotWidget> {
  PlotfastService plotService = PlotfastService();
  List<Map<String, dynamic>> myPlots = [];

  @override
  void initState() {
    super.initState();
    loadPlots();
  }

  Future<void> loadPlots() async {
    final plots = await plotService.getAllPlotsByUser(widget.ID);
    print("📌 Loaded plots: $plots");
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
              final type = myPlots[index]["type"]; // "แปลงเร็ว" หรือ "แปลงปกติ"

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
                              if (type == "แปลงปกติ") ...{
                                Text("ชนิดแปลง: ปกติ"),
                                Text("ขนาดแปลง: ${plot['area'] ?? '-'} ไร่"),
                                Text("Credit: ${plot['Credit'] ?? '-'}"),
                              } else if (type == "แปลงเร็ว") ...{
                                Text("ชนิดแปลง: เร็ว"),
                                Text("ขนาดแปลง: ${plot['area'] ?? '-'} ไร่"),
                                Text("เวลา: ${plot['time']} ปี"),
                                Text("Credit: ${plot['Credit'] ?? '-'}"),
                              },
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () async {
                            if (type == "แปลงเร็ว") {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Plotfastedit(
                                    userID: widget.ID,
                                    plotID: myPlots[index]["id"],
                                    plotData: plot,
                                  ),
                                ),
                              );
                              if (result == true) {
                                setState(() {
                                  loadPlots();
                                });
                              }
                            } else if (type == "แปลงปกติ") {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Normalplotedit(
                                    userID: widget.ID,
                                    plotID: myPlots[index]["id"],
                                    plotData: plot,
                                  ),
                                ),
                              );
                              if (result == true) {
                                setState(() {
                                  loadPlots();
                                });
                              }
                            }
                          },
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
