import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CostumInput extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool isPwdField;
  final Function(String value) onSubmitted;
  const CostumInput(
      {Key key,
      this.hintText,
      this.icon,
      this.controller,
      this.isPwdField = false,
      this.onSubmitted})
      : super(key: key);

  @override
  State<CostumInput> createState() => _CostumInputState();
}

class _CostumInputState extends State<CostumInput> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200].withOpacity(.7),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFf16b01), width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            color: Colors.grey.withOpacity(.2),
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: 15.0,
              color: Colors.grey,
            ),
            const SizedBox(
              width: 10.0,
            ),
            if (widget.isPwdField) ...[
              Flexible(
                child: TextField(
                  obscureText: _isObscure,
                  controller: widget.controller,
                  style: GoogleFonts.didactGothic(fontSize: 15.0),
                  keyboardType: TextInputType.text,
                  onSubmitted: widget.onSubmitted,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: GoogleFonts.didactGothic(
                      fontSize: 15.0,
                      color: Colors.grey[700],
                    ),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                ),
              ),
              IconButton(
                color: Colors.black,
                icon: Icon(
                  _isObscure
                      ? CupertinoIcons.eye_fill
                      : CupertinoIcons.eye_slash_fill,
                ),
                iconSize: 15.0,
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            ] else ...[
              Flexible(
                child: TextField(
                  controller: widget.controller,
                  style: GoogleFonts.didactGothic(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: GoogleFonts.didactGothic(
                      fontSize: 15.0,
                      color: Colors.grey[700],
                    ),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
