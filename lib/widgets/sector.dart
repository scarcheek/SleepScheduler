import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

List<PieChartSectionData> debugPieChartDataSet = [
  PieChartSectionData(value: 20, color: Color(0xFF3F348B), radius: 80),
  PieChartSectionData(value: 60, color: Color(0xFF4949B1), radius: 80),
  PieChartSectionData(value: 150, color: Color(0xFF4949B1), radius: 80),
  PieChartSectionData(value: 60, color: Color(0xFF3F348B), radius: 80),
];

class Sector extends StatefulWidget {
  @override
  _SectorState createState() => _SectorState();
}

class _SectorState extends State<Sector> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 260,
        child: PieChart(
          PieChartData(
            borderData: FlBorderData(
              show: false,
            ),
            centerSpaceRadius: 30,
            sections: debugPieChartDataSet,
          ),
        ));
  }
}
