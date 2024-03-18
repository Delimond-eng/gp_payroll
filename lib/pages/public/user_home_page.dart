// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsa_payroll/api/api_manager.dart';
import 'package:gsa_payroll/components/top_bar.dart';
import 'package:gsa_payroll/global/controllers.dart';
import 'package:gsa_payroll/models/session.dart';
import 'package:gsa_payroll/pages/public/scanning_page.dart';
import 'package:gsa_payroll/services/db_helper.dart';
import 'package:gsa_payroll/utilities/data_storage.dart';
import 'package:gsa_payroll/utilities/image_picker_service.dart';
import 'package:gsa_payroll/utilities/modals.dart';
import 'package:gsa_payroll/widgets/agency_card.dart';
import 'package:gsa_payroll/widgets/file_picker_btn.dart';
import 'package:percent_indicator/percent_indicator.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    /*SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (userSessionController.selectedAgency.value == null) {
        await userSessionController.refreshDatas();
        showAgencies(key.currentContext);
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: Stack(
        children: [
          _header(),
          _body(context),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        top: 100.0,
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _userStatusBar(context),
              const SizedBox(
                height: 10.0,
              ),
              if (userSessionController.selectedAgency.value != null) ...[
                _reportBox(),
                Container(
                  height: 80.0,
                  margin: const EdgeInsets.only(bottom: 10.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue[800],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.3),
                        blurRadius: 12.0,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    child: bottomStatusBar(context),
                  ),
                )
              ] else ...[
                Expanded(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Cliquez sur le boutton en bas pour \n afficher les sites de paiement qui vous sont attribués !",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.didactGothic(
                            fontWeight: FontWeight.w400,
                            color: Colors.pink,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0,
                            ),
                          ),
                          child: Text(
                            "Afficher les sites",
                            style: GoogleFonts.didactGothic(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            await userSessionController.refreshDatas();
                            showAgencies(context);
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ]
            ],
          )),
    );
  }

  Widget bottomStatusBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder<double>(
          future: countPaySum(),
          initialData: 0,
          builder: (context, snapshot) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircularPercentIndicator(
                  radius: 50.0,
                  lineWidth: 5.0,
                  percent: double.parse(double.parse(((100 * snapshot.data) /
                                  double.parse(userSessionController
                                      .selectedAgency.value.montantBudget))
                              .toString())
                          .toStringAsFixed(1)) /
                      100,
                  animation: true,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: Text(
                    "${double.parse(((100 * snapshot.data) / double.parse(userSessionController.selectedAgency.value.montantBudget)).toString()).toStringAsFixed(1)}%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                    ),
                  ),
                  progressColor: double.parse(((100 * snapshot.data) /
                                  double.parse(userSessionController
                                      .selectedAgency.value.montantBudget))
                              .toString()) <
                          60
                      ? Colors.greenAccent
                      : double.parse(((100 * snapshot.data) /
                                      double.parse(userSessionController
                                          .selectedAgency.value.montantBudget))
                                  .toString()) <
                              30
                          ? Colors.orange
                          : Colors.green,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Montant restant",
                      style: GoogleFonts.didactGothic(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.0,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${snapshot.data}  ",
                            style: GoogleFonts.staatliches(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: Colors.grey[200],
                            ),
                          ),
                          TextSpan(
                            text: userSessionController
                                .selectedAgency.value.montantDevise,
                            style: GoogleFonts.staatliches(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.cyan[200],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 10.0,
                color: Colors.black.withOpacity(.1),
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(30.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScanningPage(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 15.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Payer bénéficiaires",
                      style: GoogleFonts.didactGothic(
                        color: Colors.blue[800],
                        letterSpacing: 1.0,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _reportBox() {
    return Expanded(
      child: GridView(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2.0,
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        children: [
          DashCard(
            title: "Montant alloué",
            icon: Icons.monetization_on,
            currency:
                userSessionController.selectedAgency.value.activite.devise,
            value:
                "${userSessionController.selectedAgency.value.activite.montantBudget} ",
          ),
          FutureBuilder<int>(
            initialData: 0,
            future: countBeneficiaire(),
            builder: (context, snashot) {
              return DashCard(
                title: "Nombre des bénéficiaires",
                icon: Icons.groups_outlined,
                value: "${snashot.data}".padLeft(3, "0"),
              );
            },
          ),
          FutureBuilder<int>(
            initialData: 0,
            future: countSatisfied(),
            builder: (context, snashot) {
              return DashCard(
                title: "Bénéficiaires satisfaits",
                icon: Icons.groups_rounded,
                value: "${snashot.data}".padLeft(3, "0"),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _userStatusBar(BuildContext context) {
    return (userSessionController.selectedAgency.value == null)
        ? const SizedBox()
        : Container(
            height: 80.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.1),
                  blurRadius: 12.0,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          CupertinoIcons.home,
                          size: 45.0,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Site de ".toUpperCase(),
                              style: GoogleFonts.didactGothic(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.0),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              userSessionController.selectedAgency.value.siteNom
                                  .toUpperCase(),
                              style: GoogleFonts.didactGothic(
                                fontWeight: FontWeight.w900,
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                        const Separator(),
                        Flexible(
                          child: Text(
                            "Ordre alphabetique de paiement : (${userSessionController.selectedAgency.value.ordreAlphabetique})",
                            style: GoogleFonts.didactGothic(
                              fontWeight: FontWeight.w400,
                              color: Colors.pink,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange[600],
                      borderRadius: BorderRadius.circular(2.0),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(.1),
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(2.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(2.0),
                        onTap: () async {
                          //showAgencies(context);
                          XDialog.show(context,
                              message:
                                  "Etes-vous sûr de vouloir clôturer la session de paiement en cours ?",
                              onValidated: () {
                            closeSession(context);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 12.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                CupertinoIcons.clear_circled_solid,
                                color: Colors.white,
                                size: 15.0,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                "Clôturer",
                                style: GoogleFonts.didactGothic(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Widget _header() {
    return Stack(
      children: [
        const SizedBox(
          height: 120.0,
          child: TopBar(),
        ),
        Positioned(
          top: 30.0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "GSA",
                        style: GoogleFonts.bebasNeue(
                          color: Colors.white,
                          fontSize: 25.0,
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                        ),
                      ),
                      TextSpan(
                        text: " PayRoll",
                        style: GoogleFonts.bebasNeue(
                          color: Colors.black,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 2.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10.0,
                        color: Colors.grey.withOpacity(.3),
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 4.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 10.0,
                                  width: 10.0,
                                  color: Colors.green,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  "Connecté",
                                  style: GoogleFonts.didactGothic(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Obx(
                              () => Text(
                                "A. ${userSessionController.loggedUser.value.nom.capitalize}",
                                style: GoogleFonts.didactGothic(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18.0,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  /**
   * [modal] Pour voir les sites de paiement
   * **/
  showAgencies(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ), //this right here
            child: Stack(
              children: [
                Stack(
                  children: [
                    const SizedBox(
                      height: 70.0,
                      child: TopBar(color: Colors.pink),
                    ),
                    Positioned(
                      top: 10.0,
                      left: 10.0,
                      right: 10.0,
                      child: Row(
                        children: [
                          Text(
                            "Sélectionnez un site de paiement",
                            style: GoogleFonts.didactGothic(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.fromLTRB(0, 20.0, 0, 8.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(
                              top: 40.0,
                              left: 5.0,
                              right: 5.0,
                            ),
                            itemCount:
                                userSessionController.agenciesList.length,
                            itemBuilder: (context, index) {
                              var data =
                                  userSessionController.agenciesList[index];
                              return AgencyCard(
                                data: data,
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  /***
   * 
   * [modal] pour cloturer & capturer les preuves
   * d'une session en cours.
   */

  closeSession(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ), //this right here
            child: Stack(
              children: [
                Stack(
                  children: [
                    const SizedBox(
                      height: 70.0,
                      child: TopBar(color: Colors.orange),
                    ),
                    Positioned(
                      top: 10.0,
                      left: 10.0,
                      right: 10.0,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              "Prennez les captures de preuves de la clôturer de votre session de paiement !",
                              style: GoogleFonts.didactGothic(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Obx(
                  (() => Container(
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.fromLTRB(0, 40.0, 0, 8.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: GridView(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(
                                  top: 20.0,
                                  left: 5.0,
                                  right: 5.0,
                                ),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 1.0,
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                ),
                                children: [
                                  FilePickerBtn(
                                    radius: 5.0,
                                    onPicked: () async {
                                      var xfile = await takePhoto();
                                      var result =
                                          File(xfile.path).readAsBytesSync();
                                      var strImage = base64Encode(result);
                                      userSessionController.preuvesSessions
                                          .add(strImage);
                                    },
                                  ),
                                  ...userSessionController.preuvesSessions.map(
                                    (image) => ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: Image.memory(
                                        base64Decode(image),
                                        alignment: Alignment.center,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                    userSessionController.preuvesSessions
                                        .clear();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 15.0),
                                    backgroundColor: Colors.grey[800],
                                  ),
                                  child: Text(
                                    "Annuler",
                                    style: GoogleFonts.didactGothic(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (userSessionController
                                            .preuvesSessions.length <
                                        3) {
                                      XDialog.showMessage(context,
                                          type: "warning",
                                          message:
                                              "Vous devez au moins prendre trois captures de preuves !");
                                      return;
                                    }
                                    var session = Session(
                                      agentId: userSessionController
                                          .loggedUser.value.agentId,
                                      siteId: userSessionController
                                          .selectedAgency.value.siteId,
                                      activiteId: userSessionController
                                          .selectedAgency
                                          .value
                                          .activite
                                          .activiteId,
                                      preuves:
                                          userSessionController.preuvesSessions,
                                    );
                                    await DBHelper.insertSession(session)
                                        .then((value) async {
                                      debugPrint("lastInsert value $value");
                                      storage.remove("ags");
                                      userSessionController
                                          .refreshStorageData();
                                      userSessionController.preuvesSessions
                                          .clear();
                                      Get.back();
                                      await ApiManagerService.inPutData();
                                      XDialog.showMessage(
                                        context,
                                        type: "success",
                                        message:
                                            "Session de paiement clôturée !",
                                      );
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 15.0),
                                    backgroundColor: Colors.orange[800],
                                  ),
                                  child: Text(
                                    "Clôturer la session maintenant",
                                    style: GoogleFonts.didactGothic(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                )
              ],
            ),
          );
        });
  }

  Future<int> countBeneficiaire() async {
    var count = await DBHelper.query(
        sql:
            "SELECT COUNT(*) as nbre FROM beneficiaires WHERE site_id = '${userSessionController.selectedAgency.value.siteId}'");

    if (count.first['nbre'] != null) {
      return int.parse(count.first['nbre'].toString());
    } else {
      return 0;
    }
  }

  Future<int> countSatisfied() async {
    var count = await DBHelper.query(
        sql:
            "SELECT COUNT(*) as nbre FROM paiements WHERE agent_id = '${userSessionController.loggedUser.value.agentId}' AND site_id = '${userSessionController.selectedAgency.value.siteId}'");

    if (count.first['nbre'] != null) {
      return int.parse(count.first['nbre'].toString());
    } else {
      return 0;
    }
  }

  Future<double> countPaySum() async {
    var count = await DBHelper.query(
        sql:
            "SELECT SUM(paiement_montant) as sumpay FROM paiements WHERE agent_id = '${userSessionController.loggedUser.value.agentId}' AND site_id = '${userSessionController.selectedAgency.value.siteId}'");

    if (count.first['sumpay'] != null) {
      double amount = (double.parse(
              userSessionController.selectedAgency.value.montantBudget)) -
          (double.parse(count.first['sumpay'].toString()));
      return amount;
    } else {
      return double.parse(
          userSessionController.selectedAgency.value.montantBudget);
    }
  }
}

class DashCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final String currency;

  const DashCard({
    Key key,
    this.title,
    this.icon,
    this.currency = "",
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color =
        Colors.primaries[Random().nextInt(Colors.primaries.length)].shade900;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: color,
            width: 2.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.grey.withOpacity(.1),
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 18.0,
                  color: color,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Flexible(
                  child: Text(
                    title,
                    style: GoogleFonts.didactGothic(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "$value ",
                          style: GoogleFonts.staatliches(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            color: Colors.black,
                          ),
                        ),
                        if (currency.isNotEmpty)
                          TextSpan(
                            text: currency,
                            style: GoogleFonts.staatliches(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.cyan[800],
                            ),
                          )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Separator extends StatelessWidget {
  const Separator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      width: 2.0,
      color: Colors.grey,
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
    );
  }
}
