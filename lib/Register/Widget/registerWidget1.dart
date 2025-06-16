import 'package:flutter/material.dart';

class RegisWidget1 extends StatefulWidget {
  final TextEditingController fname;
  final TextEditingController lname;
  final TextEditingController username;
  final TextEditingController password;
  final TextEditingController password2;
  final TextEditingController address;
  final TextEditingController email;
  const RegisWidget1({
    super.key,
    required this.fname,
    required this.lname,
    required this.username,
    required this.password,
    required this.password2,
    required this.address,
    required this.email,
  });

  @override
  State<RegisWidget1> createState() => _RegisWidget1State();
}

class _RegisWidget1State extends State<RegisWidget1> {
  bool _obscureText = true;
  TextEditingController _PasswordEditingController = TextEditingController();
  TextEditingController _firstnameEditController = TextEditingController();
  TextEditingController _lastnameEditController = TextEditingController();
  TextEditingController _usernameEditController = TextEditingController();
  TextEditingController _password2EditController = TextEditingController();
  TextEditingController _addressEditController = TextEditingController();
  TextEditingController _emailEditController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _PasswordEditingController = widget.password;
    _firstnameEditController = widget.fname;
    _lastnameEditController = widget.lname;
    _usernameEditController = widget.username;
    _password2EditController = widget.password2;
    _addressEditController = widget.address;
    _emailEditController = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 40, top: 30),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 50,
                  child: TextField(
                    controller: _firstnameEditController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "ชื่อ",
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
                padding: EdgeInsets.only(right: 40, top: 30),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 50,
                  child: TextField(
                    controller: _lastnameEditController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "นามสกุล",
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
          Padding(
            padding: EdgeInsets.only(top: 10, left: 40, right: 40),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: _usernameEditController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "ชือผู้ใช้งาน",
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
            padding: EdgeInsets.only(top: 10, left: 40, right: 40),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: _PasswordEditingController,
                style: TextStyle(color: Colors.black),
                obscureText: _obscureText,
                decoration: InputDecoration(
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
            padding: EdgeInsets.only(top: 10, left: 40, right: 40),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: _password2EditController,
                style: TextStyle(color: Colors.black),
                obscureText: _obscureText,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "ยืนยันรหัสผ่าน",
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
            padding: EdgeInsets.only(top: 10, left: 40, right: 40),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: _emailEditController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "อีเมล",
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
            padding: EdgeInsets.only(top: 10, left: 40, right: 40),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: TextField(
                controller: _addressEditController,
                style: TextStyle(color: Colors.black),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "ที่อยู",
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
