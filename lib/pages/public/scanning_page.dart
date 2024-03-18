import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsa_payroll/api/models/sync_out_data.dart';
import 'package:gsa_payroll/components/top_bar.dart';
import 'package:gsa_payroll/pages/public/enroll_beneficiaire_page.dart';
import 'package:gsa_payroll/pages/public/payment_page.dart';
import 'package:gsa_payroll/services/db_helper.dart';
import 'package:gsa_payroll/services/native_helper.dart';
import 'package:gsa_payroll/utilities/modals.dart';
import 'package:lottie/lottie.dart';

class ScanningPage extends StatefulWidget {
  const ScanningPage({Key key}) : super(key: key);

  @override
  State<ScanningPage> createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {
  bool isSCanning = false;
  bool isSearched = false;
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
          top: 35.0,
          child: Text(
            isSearched
                ? "Recherche bénéficiaire".toUpperCase()
                : "Scannage bénéficiaire".toUpperCase(),
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

  Widget _body() {
    return Container(
      margin: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        bottom: 10.0,
        top: 80.0,
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!isSearched) ...[
            scannerBox(context),
          ] else ...[
            searchBox(context),
          ]
        ],
      ),
    );
  }

  Widget scannerBox(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!isSCanning) ...[
          Text(
            "Veuillez scanner une\nempreinte du bénéficiaire",
            textAlign: TextAlign.center,
            style: GoogleFonts.didactGothic(
              color: Colors.pink,
              fontWeight: FontWeight.w500,
              fontSize: 12.0,
            ),
          ),
        ] else ...[
          Text(
            "En attente d'une empreinte...",
            textAlign: TextAlign.center,
            style: GoogleFonts.didactGothic(
              color: Colors.pink,
              fontWeight: FontWeight.w500,
              fontSize: 12.0,
            ),
          ),
        ],
        const SizedBox(
          height: 8.0,
        ),
        DottedBorder(
          dashPattern: const [8, 4],
          borderType: BorderType.RRect,
          strokeWidth: 1,
          radius: const Radius.circular(20.0),
          color: Colors.grey[400],
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
                onLongPress: () {
                  setState(() {
                    isSCanning = !isSCanning;
                  });

                  Future.delayed(const Duration(seconds: 5), () {
                    setState(() {
                      isSCanning = !isSCanning;
                      isSearched = !isSearched;
                    });
                  });
                },
                onTap: () {
                  setState(() {
                    isSCanning = true;
                  });

                  /**
                   * Chercher le bénéficaire par son empreinte.
                   */
                  searchBeneficiaire();
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
    );
  }

  final _searchTxt = TextEditingController();

  Widget searchBox(BuildContext context) {
    return Column(
      children: [
        DottedBorder(
          dashPattern: const [4, 2],
          borderType: BorderType.RRect,
          strokeWidth: 1,
          radius: const Radius.circular(5.0),
          color: Colors.grey[400],
          child: Container(
            width: MediaQuery.of(context).size.width / 1.50,
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextField(
                      controller: _searchTxt,
                      onSubmitted: (String value) {
                        if (value.isNotEmpty) {
                          submitSearch(context);
                        }
                      },
                      textAlign: TextAlign.center,
                      style: GoogleFonts.didactGothic(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                      ),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Entrez le n° matricule du bénéficiaire...",
                        hintStyle: GoogleFonts.didactGothic(
                          fontSize: 15.0,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50.0,
                  width: 60.0,
                  decoration: const BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(5.0),
                    ),
                  ),
                  child: Material(
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(5.0)),
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(5.0)),
                      onTap: () => submitSearch(context),
                      child: const Icon(
                        CupertinoIcons.search,
                        size: 15.0,
                        color: Colors.white,
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

  void submitSearch(BuildContext context) async {
    if (_searchTxt.text.isEmpty) {
      EasyLoading.showToast(
        "Le n° matricule du bénéficiaire est réquis !",
        toastPosition: EasyLoadingToastPosition.bottom,
      );
      return;
    }
    FocusScope.of(context).unfocus();
    /**
                         * Rechercher trouver le bénéficiaire par son matricule ,
                         *
                         */
    await searchBeneficiaire(isSearched: true);

    setState(() {
      isSearched = !isSearched;
      _searchTxt.text = "";
    });
  }

  /**
   * Method pour chercher dans la DB local un bénéficiaire par son matricule.
   */
  Future<void> searchBeneficiaire({bool isSearched = false}) async {
    if (isSearched) {
      var query = await DBHelper.query(
        sql: "SELECT * FROM beneficiaires WHERE matricule='${_searchTxt.text}'",
      );
      if (query != null) {
        var foundBeneficiaire = Beneficiaire.fromJson(query.first);
        setState(() {
          isSCanning = false;
          this.isSearched = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnrollBeneficiairePage(
              data: foundBeneficiaire,
            ),
          ),
        );
      } else {
        XDialog.showMessage(
          context,
          type: "warning",
          message: "Matricule du bénéficiaire non reconnu !",
        );
        setState(() {
          isSCanning = false;
          this.isSearched = true;
        });
        return;
      }
    } else {
      /**
       * Collecter l'empreinte du bénéficiaire pour le matcher avec d'autres empreintes.
       */
      DBHelper.getAllFingers().then((empreintes) async {
        /**
         * Lancer la communication avec java pour collecter et matcher l'empreinte
         * avec les empreintes recuperées de la DB local.
         */
        if (empreintes != null) {
          try {
            int empreinteId = await NativeHelper.platform
                .invokeMethod("match", {"empreintes": empreintes});

            if (empreinteId >= 1) {
              var query = await DBHelper.query(
                sql:
                    "SELECT * FROM beneficiaires WHERE empreinte_id=$empreinteId",
              );
              var foundBeneficiaire = Beneficiaire.fromJson(query.first);

              if (foundBeneficiaire != null) {
                setState(() {
                  this.isSearched = false;
                  isSCanning = false;
                });
                /**
               * Aller vers le screen de payment.
               */
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(
                      data: foundBeneficiaire,
                    ),
                  ),
                );
              } else {
                /**
               * Activer la recherche du bénéficiaire par son matricule.
               */
                setState(() {
                  this.isSearched = true;
                });
              }
              return;
            } else {
              XDialog.show(context,
                  message:
                      "Empreinte scannée non reconnue,\n voulez-vous essayer une autre empreinte ?",
                  onFailed: () {
                setState(() {
                  this.isSearched = true;
                  isSCanning = false;
                });
              }, onValidated: () {
                setState(() {
                  this.isSearched = false;
                  isSCanning = false;
                });
              });
            }
          } on PlatformException catch (e) {
            debugPrint(e.message);
          }
        }
      });
    }
  }
}
