import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Mylibrarybutton extends StatefulWidget {
  const Mylibrarybutton({
    super.key,
    required this.buttonname,
    required this.ontap,
  });
  final String buttonname;
  final Function() ontap;

  @override
  State<Mylibrarybutton> createState() => _MylibrarybuttonState();
}

class _MylibrarybuttonState extends State<Mylibrarybutton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 10, 141, 180),
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 108, 110, 110),
                offset: Offset(4.5, 4.5),
                blurRadius: 15.5,
                spreadRadius: 3),
            BoxShadow(
                color: Color.fromARGB(179, 36, 33, 33),
                offset: Offset(-4.5, -4.5),
                blurRadius: 15.5,
                spreadRadius: 3),
          ]),
      child: TextButton(
          onPressed: widget.ontap,
          child: Text(
            widget.buttonname,
            style: GoogleFonts.playball(fontSize: 20, color: Colors.black),
          )),
    );
  }
}
