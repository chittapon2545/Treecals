import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';

class DisplayGraph extends StatefulWidget {
  final int state; // 1 = Normalplot + plotfast, 2 = individualtrees
  final String userId; // เพื่อกรองข้อมูลเฉพาะของ user

  const DisplayGraph({super.key, required this.state, required this.userId});

  @override
  State<DisplayGraph> createState() => _DisplayGraphState();
}

class _DisplayGraphState extends State<DisplayGraph> {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> graphData = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void didUpdateWidget(covariant DisplayGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state || oldWidget.userId != widget.userId) {
      loadData();
    }
  }

  Future<void> loadData() async {
    if (widget.state == 1) {
      await loadPlots();
    } else if (widget.state == 2) {
      await loadIndividualTrees();
    }
  }

  Future<void> loadPlots() async {
    List<Map<String, dynamic>> tempData = [];

    // Normalplot
    final normalPlotSnapshot = await _db.child("Normalplot").get();
    if (normalPlotSnapshot.exists) {
      final plots = Map<String, dynamic>.from(normalPlotSnapshot.value as Map);
      plots.forEach((key, value) {
        if (value["UserID"] == widget.userId) {
          tempData.add({
            "name": value["name"],
            "credit": (value["Credit"] as num).toDouble(),
          });
        }
      });
    }

    // Plotfast
    final plotFastSnapshot = await _db.child("plotfast").get();
    if (plotFastSnapshot.exists) {
      final plots = Map<String, dynamic>.from(plotFastSnapshot.value as Map);
      plots.forEach((key, value) {
        if (value["UserID"] == widget.userId) {
          tempData.add({
            "name": value["name"],
            "credit": (value["Credit"] as num).toDouble(),
          });
        }
      });
    }

    setState(() {
      graphData = tempData;
    });
  }

  Future<void> loadIndividualTrees() async {
    List<Map<String, dynamic>> tempData = [];

    final treeSnapshot = await _db.child("individualtrees").get();
    if (treeSnapshot.exists) {
      final trees = Map<String, dynamic>.from(treeSnapshot.value as Map);
      trees.forEach((key, value) {
        if (value["UserID"] == widget.userId) {
          tempData.add({
            "name": value["name"],
            "credit": (value["Credit"] as num).toDouble(),
          });
        }
      });
    }

    setState(() {
      graphData = tempData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (graphData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.all(10),
      child: widget.state == 1 ? _buildBarChart() : _buildPieChart(),
    );
  }

  Widget _buildBarChart() {
    double chartWidth = (graphData.length * 40).toDouble();
    int touchedIndex = -1;

    return StatefulBuilder(
      builder: (context, setInnerState) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: chartWidth < MediaQuery.of(context).size.width
                ? MediaQuery.of(context).size.width
                : chartWidth,
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < graphData.length) {
                          return SideTitleWidget(
                            meta: meta,
                            space: 6,
                            child: Text(
                              graphData[index]["name"],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()} tCO₂e',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${graphData[groupIndex]["name"]}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                '${graphData[groupIndex]["credit"].toStringAsFixed(2)} tCO₂e',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  touchCallback:
                      (FlTouchEvent event, BarTouchResponse? response) {
                        if (!event.isInterestedForInteractions ||
                            response == null ||
                            response.spot == null) {
                          setInnerState(() => touchedIndex = -1);
                          return;
                        }
                        setInnerState(
                          () => touchedIndex =
                              response.spot!.touchedBarGroupIndex,
                        );
                      },
                ),
                barGroups: graphData.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;
                  bool isTouched = index == touchedIndex;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: isTouched
                            ? item["credit"] *
                                  1.1 // ขยายขึ้น 10%
                            : item["credit"],
                        width: isTouched ? 26 : 20,
                        borderRadius: BorderRadius.circular(6),
                        color: isTouched
                            ? Colors.amber
                            : Colors.primaries[index % Colors.primaries.length],
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY:
                              (graphData
                                  .map((e) => e["credit"] as double)
                                  .reduce(max) *
                              1.2),
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              swapAnimationDuration: const Duration(
                milliseconds: 300,
              ), // อนิเมชันนุ่มๆ
              swapAnimationCurve: Curves.easeInOut,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: graphData.map((item) {
          int idx = graphData.indexOf(item);
          double credit = item["credit"];
          String name = item["name"];

          return PieChartSectionData(
            value: credit,
            // 🔹 แสดงชื่อ + ค่า credit ในวงกลม
            title: "$name\n${credit.toStringAsFixed(2)} ",
            color: Colors.primaries[idx % Colors.primaries.length],
            radius: 45,
            titleStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            titlePositionPercentageOffset:
                0.6, // ✅ ขยับข้อความออกมานิดให้ไม่ทับตรงกลาง
          );
        }).toList(),
        sectionsSpace: 2, // ระยะห่างระหว่างแต่ละชิ้น
        centerSpaceRadius: 30, // เว้นตรงกลางให้ดูโปร
      ),
    );
  }
}
