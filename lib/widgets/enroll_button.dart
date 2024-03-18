import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class EnrollFingerBtn extends StatefulWidget {
  final Function onEnroll;
  final String number;
  final bool isLoading;
  final String value;
  const EnrollFingerBtn({
    Key key,
    this.onEnroll,
    this.number,
    this.isLoading,
    this.value,
  }) : super(key: key);

  @override
  State<EnrollFingerBtn> createState() => _EnrollFingerBtnState();
}

class _EnrollFingerBtnState extends State<EnrollFingerBtn> {
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      dashPattern: const [8, 4],
      borderType: BorderType.RRect,
      strokeWidth: 1,
      color: Colors.grey[400],
      radius: const Radius.circular(10.0),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => widget.onEnroll(),
                child: widget.isLoading
                    ? Center(
                        child: Lottie.asset(
                          "assets/animated/fingerscan_2.json",
                          alignment: Alignment.center,
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.fingerprint_sharp,
                          color: widget.value.isEmpty
                              ? Colors.grey
                              : const Color.fromARGB(255, 0, 212, 0),
                          size: 40.0,
                        ),
                      ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 20.0,
              width: 20.0,
              decoration: BoxDecoration(
                color: widget.value.isEmpty
                    ? Colors.grey
                    : const Color.fromARGB(255, 0, 212, 0),
              ),
              child: Center(
                child: Text(
                  widget.number,
                  style: GoogleFonts.didactGothic(
                    color: Colors.white,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
