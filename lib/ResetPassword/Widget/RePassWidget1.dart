import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RePassWidget1 extends StatefulWidget {
  final TextEditingController phoneController;
  const RePassWidget1({super.key, required this.phoneController});

  @override
  State<RePassWidget1> createState() => _RePassWidget1State();
}

class _RePassWidget1State extends State<RePassWidget1> {
  late TextEditingController _phone;
  @override
  void initState() {
    super.initState();
    _phone = widget.phoneController;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: 30, left: 50, right: 50),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextField(
            controller: _phone,
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
    );
  }
}
