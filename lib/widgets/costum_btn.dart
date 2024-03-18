import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CostumBtn extends StatelessWidget {
  final Function onPressed;
  final String label;
  final MaterialColor color;
  final double height, width;
  final IconData icon;
  const CostumBtn({
    Key key,
    this.onPressed,
    this.label,
    this.color,
    this.height,
    this.width,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 70.0,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFFf16b01),
        boxShadow: [
          BoxShadow(
            blurRadius: 10.0,
            color: Colors.black.withOpacity(.3),
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Row(
            children: [
              Container(
                height: height ?? 70.0,
                width: 70.0,
                decoration: BoxDecoration(
                  color:
                      color.shade600 ?? const Color.fromARGB(255, 172, 76, 2),
                ),
                child: Center(
                  child: Icon(
                    icon ?? CupertinoIcons.checkmark_alt,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.didactGothic(
                        color: Colors.white,
                        letterSpacing: 1.0,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
