import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IdTile extends StatelessWidget {
  final String title, value;
  const IdTile({
    Key key,
    this.title,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      margin: const EdgeInsets.only(bottom: 5.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(.5),
            width: .5,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.didactGothic(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: Colors.cyan[800],
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            value.isEmpty ? "Non répertorié !" : value,
            style: GoogleFonts.didactGothic(
              fontSize: 15.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class PayTile extends StatelessWidget {
  final String title, value;
  final String currency;
  const PayTile({
    Key key,
    this.title,
    this.value,
    this.currency = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 5.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(.5),
            width: .5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.didactGothic(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFf16b01),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$value ",
                    style: currency.isNotEmpty
                        ? GoogleFonts.staatliches(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            color: Colors.black,
                          )
                        : GoogleFonts.didactGothic(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                  ),
                  if (currency.isNotEmpty)
                    TextSpan(
                      text: currency,
                      style: GoogleFonts.staatliches(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
