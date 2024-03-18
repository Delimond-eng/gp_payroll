import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsa_payroll/global/controllers.dart';
import 'package:gsa_payroll/models/site.dart';
import 'package:gsa_payroll/services/db_helper.dart';
import 'package:gsa_payroll/utilities/data_storage.dart';

class AgencyCard extends StatelessWidget {
  final Sites data;
  const AgencyCard({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 225, 238, 247),
          borderRadius: BorderRadius.circular(4.0)),
      child: Material(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4.0),
          onTap: () async {
            var json = await DBHelper.query(
                sql:
                    "SELECT * FROM sites INNER JOIN activites ON sites.site_id = activites.site_id WHERE sites.site_id='${data.siteId}'");
            storage.write("ags", json.first);
            userSessionController.refreshStorageData();
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.pop(context);
            });
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Row(
              children: [
                Image.asset(
                  "assets/svg/select.png",
                  height: 60.0,
                  width: 60.0,
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Site de ${data.siteNom}".toUpperCase(),
                        style: GoogleFonts.didactGothic(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.payments_sharp,
                                    color: Colors.cyan,
                                    size: 12.0,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Montant alloué",
                                    style: GoogleFonts.didactGothic(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${data.activite.montantBudget} ",
                                      style: GoogleFonts.staatliches(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.5,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: data.activite.devise,
                                      style: GoogleFonts.staatliches(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.grey[800],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 50.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.groups,
                                    color: Colors.blue,
                                    size: 12.0,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Nombre de bénéficiaires :",
                                    style: GoogleFonts.didactGothic(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                              FutureBuilder<int>(
                                future: countBeneficiaire(data.siteId),
                                initialData: 0,
                                builder: (context, snapshot) {
                                  return Text(
                                    "${snapshot.data}",
                                    style: GoogleFonts.staatliches(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                      color: Colors.black,
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<int> countBeneficiaire(String siteId) async {
    var count = await DBHelper.query(
        sql:
            "SELECT COUNT(*) as nbre FROM beneficiaires WHERE site_id = '$siteId'");

    if (count.isNotEmpty) {
      return int.parse(count.first['nbre'].toString());
    } else {
      return 0;
    }
  }
}
