import 'dart:convert';

import 'package:flutter/material.dart';

class PreuveItem extends StatelessWidget {
  const PreuveItem({
    Key key,
    this.image,
    this.onDeleted,
  }) : super(key: key);

  final String image;
  final Function onDeleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        image: DecorationImage(
          fit: BoxFit.cover,
          alignment: Alignment.center,
          image: MemoryImage(
            base64Decode(
              image,
            ),
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.all(5.0),
            height: 25.0,
            width: 25.0,
            decoration: BoxDecoration(
              color: Colors.pink[200],
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10.0,
                  color: Colors.grey.withOpacity(.1),
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5.0),
              child: InkWell(
                onTap: onDeleted,
                borderRadius: BorderRadius.circular(5.0),
                child: const Center(
                  child: Icon(
                    Icons.close,
                    size: 10.0,
                    color: Colors.white,
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
