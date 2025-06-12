import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RePassWidget2 extends StatefulWidget {
  final TextEditingController phoneController;
  const RePassWidget2({super.key, required this.phoneController});

  @override
  State<RePassWidget2> createState() => _RePassWidget2State();
}

class _RePassWidget2State extends State<RePassWidget2> {
  Timer? _timer;
  int _timeSeconds = 180;
  late TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    _phone = widget.phoneController;
  }

  String _formatTime(int seconds) {
    final min = (seconds ~/ 60).toString();
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30, left: 40, right: 40),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: _phone,
                readOnly: true,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 40, top: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 6,
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "รหัสยืนยัน",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 40, top: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 80,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      if (_timeSeconds == 0) {
                        setState(() {
                          _timeSeconds = 180;
                        });
                      }
                      _timer?.cancel();
                      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
                        if (_timeSeconds == 0) {
                          timer.cancel();
                        } else {
                          setState(() {
                            _timeSeconds--;
                          });
                        }
                      });
                    },
                    child: Text(
                      "รับรหัสผ่าน",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.white, width: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 45),
            child: Container(
              width: 150,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              alignment: Alignment.center,
              child: Text(
                "เวลาคงเหลือ ${_formatTime(_timeSeconds)} นาที",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
