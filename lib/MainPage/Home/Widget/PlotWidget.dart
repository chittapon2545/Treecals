import 'package:flutter/material.dart';

class PlotWidget extends StatefulWidget {
  final String ID;
  const PlotWidget({super.key, required this.ID});

  @override
  State<PlotWidget> createState() => _PlotWidgetState();
}

class _PlotWidgetState extends State<PlotWidget> {
  String _ID = '';

  @override
  void initState() {
    super.initState();
    _ID == widget.ID;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
