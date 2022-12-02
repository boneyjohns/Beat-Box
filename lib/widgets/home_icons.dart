import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homeicons extends StatefulWidget {
  final String playlistname;
  final dynamic imagepath;
  final Function() ontap;
  const Homeicons({
    super.key,
    required this.playlistname,
    required this.imagepath,
    required this.ontap,
  });

  @override
  State<Homeicons> createState() => _HomeiconsState();
}

class _HomeiconsState extends State<Homeicons> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.ontap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: SizedBox(
          width: 170,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: 140,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                child: Image.asset(
                  widget.imagepath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Childtext(widget: widget)
          ]),
        ),
      ),
    );
  }
}

class Childtext extends StatelessWidget {
  const Childtext({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final Homeicons widget;

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.playlistname,
      style: GoogleFonts.marckScript(
          color: Color.fromARGB(255, 0, 0, 0),
          fontWeight: FontWeight.bold,
          fontSize: 22),
    );
  }
}
