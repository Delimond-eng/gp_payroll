import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsa_payroll/api/api_manager.dart';
import 'package:gsa_payroll/api/models/sync_out_data.dart';
import 'package:gsa_payroll/components/top_bar.dart';
import 'package:gsa_payroll/global/controllers.dart';
import 'package:gsa_payroll/models/paie.dart';
import 'package:gsa_payroll/services/db_helper.dart';
import 'package:gsa_payroll/services/native_helper.dart';
import 'package:gsa_payroll/utilities/image_picker_service.dart';
import 'package:gsa_payroll/utilities/modals.dart';
import 'package:gsa_payroll/widgets/costum_btn.dart';
import 'package:gsa_payroll/widgets/file_picker_btn.dart';
import 'package:gsa_payroll/widgets/pay_infos_widgets.dart';
import 'package:gsa_payroll/widgets/preuve_item.dart';
import 'package:lottie/lottie.dart';

class PaymentPage extends StatefulWidget {
  final Beneficiaire data;
  const PaymentPage({Key key, this.data}) : super(key: key);
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<String> preuveImages = [];
  String avatar = "";

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
    setState(() {
      avatar = widget.data.photo ?? "";
    });
  }

  Future<void> makePaymnt(BuildContext ctx) async {
    var payData = PayModel(
      agentId: userSessionController.loggedUser.value.agentId,
      beneficiaireId: widget.data.beneficiaireId,
      paiementId: widget.data.paiementId,
      paiementMontant: widget.data.netapayer,
      preuves: preuveImages,
      siteId: userSessionController.selectedAgency.value.siteId,
    );
    await DBHelper.payerBeneficiaire(payData).then((res) {
      if (res != null) {
        Get.back();
        XDialog.showMessage(ctx,
            type: "success", message: "Le paiement est effectué avec succès !");
        userSessionController.refreshDatas();
      }
    });
    await ApiManagerService.inPutData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _header(),
          _body(),
        ],
      ),
    );
  }

  Widget _header() {
    return Stack(
      alignment: Alignment.center,
      children: [
        const SizedBox(
          height: 120.0,
          child: TopBar(),
        ),
        Positioned(
          top: 30.0,
          left: 10.0,
          child: Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.0),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 5.0,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/svg/back-svgrepo-com.svg",
                      color: Colors.white,
                      width: 25.0,
                      height: 25.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _body() {
    return Container(
      margin: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        bottom: 10.0,
        top: 70.0,
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          _identitiesInfos(),
          const SizedBox(
            width: 10.0,
          ),
          _paymentInfos(),
        ],
      ),
    );
  }

  Widget _paymentInfos() {
    return Expanded(
      flex: 8,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.8),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10.0,
                    color: Colors.grey.withOpacity(.1),
                    offset: const Offset(0, 3),
                  )
                ],
                border: const Border(
                  top: BorderSide(
                    color: Colors.blue,
                    width: 1.0,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  "Paiement bénéficiaire",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.didactGothic(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 6,
                            child: PayTile(
                              title: "Montant à payer",
                              value: widget.data.netapayer,
                              currency: widget.data.devise,
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Flexible(
                            flex: 6,
                            child: Row(
                              children: const [
                                Flexible(
                                  child: PayTile(
                                    title: "Mois",
                                    value: "Janvier",
                                  ),
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Flexible(
                                  child: PayTile(
                                    title: "Année",
                                    value: "2022",
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Veuillez prendre des captures des preuves de paiement ",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.didactGothic(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              "Une action obligatoire !",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.didactGothic(
                                fontSize: 12.0,
                                color: Colors.pink,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1.2,
                          crossAxisCount: 4,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        children: [
                          for (int i = 0; i < preuveImages.length; i++) ...[
                            PreuveItem(
                              image: preuveImages[i],
                              onDeleted: () {
                                preuveImages.removeAt(i);
                                setState(() {});
                              },
                            )
                          ],
                          FilePickerBtn(
                            radius: 5.0,
                            onPicked: () async {
                              var xfile = await takePhoto();
                              var result = File(xfile.path).readAsBytesSync();
                              var strImage = base64Encode(result);
                              preuveImages.add(strImage);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      CostumBtn(
                        label: "Valider paiement",
                        height: 50.0,
                        color: Colors.green,
                        onPressed: () {
                          if (preuveImages.isEmpty) {
                            EasyLoading.showToast(
                                "Les captures des preuves de paiement requises !");
                            return;
                          }
                          validePay(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _identitiesInfos() {
    return Expanded(
      flex: 4,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.8),
          border: const Border(
            top: BorderSide(color: Colors.blue),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 10.0,
              color: Colors.grey.withOpacity(.1),
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _userAvatar(),
              const SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      widget.data.nom ?? "",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.didactGothic(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              IdTile(
                title: "Date de naissance",
                value: widget.data.dateNaissance ?? "",
              ),
              IdTile(
                title: "Etat civil",
                value: widget.data.etatCivil ?? "",
              ),
              const IdTile(
                title: "Localité",
                value: "Nyingaroro Bikoro",
              ),
              const IdTile(
                title: "Adresse",
                value: "20, luefu, Kolwezi",
              ),
              IdTile(
                title: "Ayant droit",
                value: widget.data.ayantDroit ?? "",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userAvatar() {
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        decoration: BoxDecoration(
          color: Colors.cyan[100],
          image: avatar.isNotEmpty
              ? DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  image: MemoryImage(
                    base64Decode(avatar),
                  ),
                )
              : null,
          borderRadius: BorderRadius.circular(80.0),
        ),
        child: avatar.isEmpty
            ? const Center(
                child: Icon(
                  CupertinoIcons.person_fill,
                  color: Colors.white,
                ),
              )
            : const SizedBox(),
      ),
    );
  }

  validePay(BuildContext context) {
    bool isSCanning = false;
    int count = 1;
    showDialog(
        barrierColor: Colors.black12,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ), //this right here
            child: StatefulBuilder(builder: (context, setter) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DottedBorder(
                      dashPattern: const [8, 4],
                      borderType: BorderType.RRect,
                      strokeWidth: 1,
                      radius: const Radius.circular(20.0),
                      color: Colors.white,
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.cyan[100],
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20.0),
                            onTap: () async {
                              setter(() {
                                isSCanning = !isSCanning;
                              });
                              var empreintes = await DBHelper.getAllFingers(
                                  where: widget.data.empreinteId);
                              if (empreintes == null) {
                                setter(() {
                                  count++;
                                  isSCanning = !isSCanning;
                                  if (count > 3) {
                                    Get.back();
                                    return;
                                  }
                                });
                                EasyLoading.showToast(
                                    "Empreinte non reconnue, veuillez essayer une autre empreinte !");
                                return;
                              }
                              if (empreintes != null) {
                                int empreinteId = await NativeHelper.platform
                                    .invokeMethod(
                                        "match", {"empreintes": empreintes});
                                if (empreinteId >= 1) {
                                  setter(() {
                                    makePaymnt(context);
                                    isSCanning = !isSCanning;
                                  });
                                  return;
                                }
                              }
                            },
                            child: isSCanning
                                ? Lottie.asset(
                                    "assets/animated/fingerscan_2.json",
                                    alignment: Alignment.center,
                                    height: 60.0,
                                    width: 60.0,
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.fingerprint_sharp,
                                      color: Colors.white,
                                      size: 40.0,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
          );
        });
  }
}
