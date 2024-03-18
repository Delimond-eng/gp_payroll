import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/api/api_manager.dart';
import '/api/models/sync_out_data.dart';
import '/components/top_bar.dart';
import '/pages/public/payment_page.dart';
import '/services/db_helper.dart';
import '/services/native_helper.dart';
import '/utilities/image_picker_service.dart';
import '/utilities/modals.dart';
import '/widgets/costum_btn.dart';
import '/widgets/enroll_button.dart';
import '/widgets/file_picker_btn.dart';
import '/widgets/pay_infos_widgets.dart';
import '/widgets/preuve_item.dart';

class EnrollBeneficiairePage extends StatefulWidget {
  final Beneficiaire? data;
  const EnrollBeneficiairePage({super.key, this.data});

  @override
  State<EnrollBeneficiairePage> createState() => _EnrollBeneficiairePageState();
}

class _EnrollBeneficiairePageState extends State<EnrollBeneficiairePage> {
  List<String> captures = [];
  String avatar = "";
  var empreinte1 = "";
  var empreinte2 = "";
  var empreinte3 = "";

  bool isLoading1 = false;
  bool isLoading2 = false;
  bool isLoading3 = false;

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
    avatar = widget.data.photo ?? "";
    if (widget.data.signatureCapture.isNotEmpty) {
      captures.add(widget.data.signatureCapture);
    }
    setState(() {});
  }

  cleanAllFields() {
    empreinte1 = "";
    empreinte2 = "";
    empreinte3 = "";
    avatar = "";
    captures.clear();
    setState(() {});
  }

  // ignore: slash_for_doc_comments
  /// Method pour enregistrer localement les details
  /// supplementaires de l'enrollment d'un agent.

  Future<void> enrollerBeneficiaire(BuildContext ctx) async {
    if (avatar.isEmpty) {
      EasyLoading.showToast("La photo du bénéficaire requise !");
      return;
    }
    if (captures.isEmpty) {
      EasyLoading.showToast(
          "La capture de la signature du bénéficiaire requise !");
      return;
    }
    String beneficiaireId = widget.data.beneficiaireId;
    var empreintes = Empreintes(
      empreinte1: empreinte1,
      empreinte2: empreinte2,
      empreinte3: empreinte3,
    );
    var beneficaire = Beneficiaire(
      photo: avatar,
      signatureCapture: captures.first,
      beneficiaireId: widget.data!.beneficiaireId,
    );
    var res = await DBHelper.enrollerBeneficiaire(
      empreintes: empreintes,
      beneficiaire: beneficaire,
    );
    if (res != null) {
      var query = await DBHelper.query(
        sql:
            "SELECT * FROM beneficiaires WHERE beneficiaire_id=$beneficiaireId",
      );
      var foundBeneficiaire = Beneficiaire.fromJson(query.first);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => PaymentPage(data: foundBeneficiaire),
        ),
      );

      XDialog.showMessage(
        ctx,
        type: "success",
        message: "Enrollement bénéficiaire effectué avec succès !",
      );
      await ApiManagerService.inPutData();
    }
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _identitiesInfos(),
          const SizedBox(
            width: 10.0,
          ),
          _enrollInfos()
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
          top: 40.0,
          child: Text(
            "Enrollement bénéficiaire".toUpperCase(),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16.0,
              letterSpacing: 1.5,
            ),
          ),
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

  Widget _identitiesInfos() {
    return Expanded(
      flex: 4,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: const Border(
            top: BorderSide(
              color: Colors.blue,
              width: 1.0,
            ),
          ),
          color: Colors.white.withOpacity(.8),
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
                height: 15.0,
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

  Widget _enrollInfos() {
    return Expanded(
      flex: 8,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const TitleTile(
              title: "Enrollement empreintes digitales",
              icon: Icons.fingerprint,
            ),
            GridView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: .9,
                crossAxisCount: 4,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              children: [
                EnrollFingerBtn(
                  number: "1",
                  isLoading: isLoading1,
                  value: empreinte1,
                  onEnroll: () {
                    try {
                      setState(() {
                        isLoading1 = !isLoading1;
                      });
                      _enrollFinger().then((value) {
                        setState(() {
                          empreinte1 = value;
                          isLoading1 = false;
                        });
                        EasyLoading.showToast(
                            "Empreinte 1 enrollée avec succès .");
                      });
                    } catch (e) {
                      setState(() {
                        isLoading1 = !isLoading1;
                      });
                    }
                  },
                ),
                EnrollFingerBtn(
                  number: "2",
                  isLoading: isLoading2,
                  value: empreinte2,
                  onEnroll: () {
                    try {
                      setState(() {
                        isLoading2 = !isLoading2;
                      });
                      _enrollFinger().then((value) {
                        setState(() {
                          empreinte2 = value;
                          isLoading2 = false;
                        });
                        EasyLoading.showToast(
                            "Empreinte 2 enrollée avec succès .");
                      });
                    } catch (e) {
                      setState(() {
                        isLoading2 = !isLoading2;
                      });
                    }
                  },
                ),
                EnrollFingerBtn(
                  number: "3",
                  isLoading: isLoading3,
                  value: empreinte3,
                  onEnroll: () {
                    try {
                      setState(() {
                        isLoading3 = !isLoading3;
                      });
                      _enrollFinger().then((value) {
                        setState(() {
                          empreinte3 = value;
                          isLoading3 = false;
                        });
                        EasyLoading.showToast(
                            "Empreinte 3 enrollée avec succès .");
                      });
                    } catch (e) {
                      setState(() {
                        isLoading3 = !isLoading3;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            const TitleTile(
              title: "Capture des signatures",
              icon: CupertinoIcons.signature,
            ),
            GridView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.0,
                crossAxisCount: 4,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              children: [
                for (int i = 0; i < captures.length; i++) ...[
                  PreuveItem(
                    image: captures[i],
                    onDeleted: () {
                      captures.removeAt(i);
                      setState(() {});
                    },
                  )
                ],
                FilePickerBtn(
                  isSigned: true,
                  onPicked: () async {
                    var xfile = await takePhoto();
                    var result = File(xfile.path).readAsBytesSync();
                    var strImage = base64Encode(result);
                    captures.add(strImage);
                    setState(() {});
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            CostumBtn(
              label: "Enroller bénéficiaire",
              height: 50.0,
              color: Colors.green,
              onPressed: () => enrollerBeneficiaire(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userAvatar() {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
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
          Positioned(
            bottom: -8,
            right: 5.0,
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Colors.orange[800],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.2),
                    blurRadius: 12.0,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Material(
                borderRadius: BorderRadius.circular(50.0),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(50.0),
                  onTap: () async {
                    var xfile = await takePhoto();
                    var result = File(xfile.path).readAsBytesSync();
                    avatar = base64Encode(result);
                    setState(() {});
                  },
                  child: Center(
                    child: Icon(
                      avatar.isNotEmpty
                          ? Icons.close
                          : Icons.add_a_photo_outlined,
                      color: Colors.white,
                      size: 15.0,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /**
   * Method pour pour enroller une empreinte.
   */
  Future<String> _enrollFinger() async {
    String data = await NativeHelper.platform.invokeMethod("enroll");
    return data ?? "";
  }
}

class TitleTile extends StatelessWidget {
  final String title;
  final IconData icon;
  const TitleTile({
    Key key,
    this.title,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    return Container(
      width: double.infinity,
      height: 40.0,
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 10.0,
      ),
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.cyan,
            size: 18.0,
          ),
          const SizedBox(
            width: 5.0,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.didactGothic(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
