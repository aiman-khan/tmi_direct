import 'package:flutter/material.dart';

Widget customTextField(
    String hinttext, keyBoardType, controller, obscureText, sicon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          width: double.maxFinite,
          height: 60,
          decoration: BoxDecoration(
              color: Color(0xff1E1E1E),
              borderRadius: BorderRadius.circular(15)),
          child: TextField(
            controller: controller,
            keyboardType: keyBoardType,
            style: TextStyle(color: Colors.white, fontFamily: "Rubik"),
            obscureText: obscureText,
            cursorColor: Color(0xffF89009),
            decoration: InputDecoration(
                hintText: hinttext,
                hintStyle: TextStyle(
                    fontSize: 15,
                    color: Color(0xff828282),
                    fontFamily: "Rubik"),
                border: InputBorder.none,
                suffixIcon: sicon),
          ),
        ),
      ],
    ),
  );
}
