import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:treecals/Services/User.dart';

class RegisWidget2 extends StatefulWidget {
  final TextEditingController phone;
  const RegisWidget2({super.key, required this.phone});

  @override
  State<RegisWidget2> createState() => _RegisWidget2State();
}

class _RegisWidget2State extends State<RegisWidget2> {
  UserService _userService = UserService();
  Timer? _timer;
  int _timeSeconds = 180;

  TextEditingController _PhoneEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _PhoneEditingController = widget.phone;
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
                controller: _PhoneEditingController,
                style: TextStyle(color: Colors.black),
                maxLength: 10,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "เบอร์โทร",
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
                    decoration: InputDecoration(
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
                  width: MediaQuery.of(context).size.width / 2 - 100,
                  height: 50,
                  child: TextButton(
                    onPressed: () async {
                      String phone = _PhoneEditingController.text.trim();
                      String? checkPhone = await _userService.checkPhone(phone);
                      if (checkPhone == null) {
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
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("หมายเลขโทรศัพท์มีผู้ใช้งานแล้ว"),
                          ),
                        );
                      }
                    },

                    child: Text(
                      "รับรหัสผ่าน",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
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
