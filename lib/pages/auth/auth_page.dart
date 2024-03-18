import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/components/top_bar.dart';
import '/global/controllers.dart';
import '/pages/public/user_home_page.dart';
import '/services/db_helper.dart';
import '/utilities/modals.dart';
import '/widgets/custom_input.dart';

import '/api/models/sync_out_data.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _txtUserName = TextEditingController();
  final TextEditingController _txtPwd = TextEditingController();

  final GlobalKey<NavigatorState> skey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      var result = await (Connectivity().checkConnectivity());
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        Xloading.showLottieLoading(skey.currentContext!);
        await apiAsyncController.syncDatas();
        Xloading.dismiss();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: skey,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          _header(),
          // ignore: sized_box_for_whitespace
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 280.0,
                      width: MediaQuery.of(context).size.width / 1.50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.8),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15.0,
                            color: Colors.grey.withOpacity(.3),
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "GSA",
                                    style: GoogleFonts.bebasNeue(
                                      color: const Color(0xFFf16b01),
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " PayRoll",
                                    style: GoogleFonts.bebasNeue(
                                      color: Colors.black,
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Flexible(
                              child: CostumInput(
                                controller: _txtUserName,
                                icon: CupertinoIcons.person,
                                hintText: "Email ou téléphone.",
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Flexible(
                              child: CostumInput(
                                controller: _txtPwd,
                                icon: CupertinoIcons.lock,
                                hintText: "Mot de passe.",
                                isPwdField: true,
                                onSubmitted: (val) async {
                                  debugPrint("submitted");
                                  FocusScope.of(context).unfocus();
                                  _loggedIn(context);
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              height: 60.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.2),
                                    blurRadius: 12.0,
                                    offset: const Offset(0, 10.0),
                                  )
                                ],
                                color: Colors.cyan[700],
                              ),
                              child: Material(
                                borderRadius: BorderRadius.circular(2.0),
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    _loggedIn(context);
                                  },
                                  borderRadius: BorderRadius.circular(2.0),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: SvgPicture.asset(
                                        "assets/svg/next-right-arrow-svgrepo-com.svg",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return const SizedBox(
      height: 300,
      child: TopBar(),
    );
  }

  Future<void> _loggedIn(BuildContext context) async {
    if (_txtUserName.text.isEmpty) {
      EasyLoading.showToast(
        "Email utilisateur ou n° de téléphone réquis !",
        toastPosition: EasyLoadingToastPosition.bottom,
      );
      return;
    }
    if (_txtPwd.text.isEmpty) {
      EasyLoading.showToast(
        "Mot de passe réquis !",
        toastPosition: EasyLoadingToastPosition.bottom,
      );
      return;
    }

    Agents user = Agents(telephone: _txtUserName.text, pass: _txtPwd.text);
    var result = await DBHelper.loginUser(user: user);
    if (result.isNotEmpty) {
      var userData = Agents.fromJson(result.first);
      userSessionController.loggedUser.value = userData;
      Xloading.showLottieLoading(context);
      await userSessionController.fetchAgencies();
      await userSessionController.refreshStorageData();

      var dataConnection = await (Connectivity().checkConnectivity());
      if (dataConnection == ConnectivityResult.mobile ||
          dataConnection == ConnectivityResult.wifi) {
        await apiAsyncController.syncAgentData(
          agentId: userData.agentId,
        );
      }
      Xloading.dismiss();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const UserHomePage(),
        ),
        (route) => false,
      );
    } else {
      EasyLoading.showToast(
        "Email ou mot de passe incorrect !",
        toastPosition: EasyLoadingToastPosition.top,
      );
      return;
    }
  }
}
