import 'package:flutter/material.dart';

class RePassWidget3 extends StatefulWidget {
  const RePassWidget3({super.key});

  @override
  State<RePassWidget3> createState() => _RePassWidget3State();
}

class _RePassWidget3State extends State<RePassWidget3> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30, left: 50, right: 50),
            child: Text(
              "ตั้งค่ารหัสผ่านใหม่",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 50, right: 50),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                obscureText: _obscureText,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "รหัสผ่าน",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50, top: 10),
            child: Text(
              "กรุณากรอกรหัสผ่าน ประกอบด้วย",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50, top: 0),
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontWeight: FontWeight.bold),
                children: [
                  TextSpan(text: "ตัว A - Z,  "),
                  TextSpan(text: "ตัว a - z,  "),
                  TextSpan(text: "และ 0 - 9"),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 50, right: 50),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                obscureText: _obscureText,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "รหัสผ่านอีกครั้ง",
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
        ],
      ),
    );
  }
}
