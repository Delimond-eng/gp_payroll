import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilePickerBtn extends StatelessWidget {
  final Function onPicked;
  final bool isSigned;
  final double radius;
  const FilePickerBtn({
    Key key,
    this.onPicked,
    this.isSigned = false,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      dashPattern: const [8, 4],
      borderType: BorderType.RRect,
      strokeWidth: 1,
      color: Colors.grey[400],
      radius: Radius.circular(radius ?? 10.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(radius ?? 5.0),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPicked,
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 20.0,
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
              decoration: const BoxDecoration(
                color: Colors.cyan,
              ),
              child: Center(
                child: Icon(
                  isSigned ? CupertinoIcons.signature : Icons.add_a_photo,
                  color: Colors.white,
                  size: 12.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
