import 'dart:async';
import 'package:get/get.dart';
import '../api/api_manager.dart';
import '../services/db_helper.dart';

class ApiAsyncController extends GetxController {
  static ApiAsyncController instance = Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> syncDatas() async {
    var synchroneData = await ApiManagerService.getDatas();
    synchroneData.data.agents.forEach((e) async {
      var checkMap = await DBHelper.checkDatas(
        checkId: e.agentId,
        tableName: "agents",
        where: "agent_id",
      );
      if (checkMap == "0") {
        await DBHelper.registerUser(e);
      }
    });
  }

  Future<void> syncAgentData({String agentId}) async {
    Future.delayed(const Duration(milliseconds: 500));
    var syncData = await ApiManagerService.takeAgentData(agentId);

    String siteId = "";

    if (syncData.data != null) {
      if (syncData.data.activites.isNotEmpty) {
        syncData.data.activites.forEach((e) async {
          var checkMapActivity = await DBHelper.checkDatas(
            checkId: e.activiteId,
            tableName: "activites",
            where: "activite_id",
          );
          if (checkMapActivity == "0") {
            print("register activities");
            await DBHelper.enregistrerActivites(e);
          }

          var checkSite = await DBHelper.checkDatas(
            checkId: e.siteId,
            tableName: "sites",
            where: "site_id",
          );

          if (checkSite == "0") {
            print("register sites");
            await DBHelper.enregistrerSites(e);
          }
          siteId = e.siteId;
          for (int i = 0; i < e.beneficiaires.length; i++) {
            var checkBeneficiares = await DBHelper.checkDatas(
              checkId: e.beneficiaires[i].beneficiaireId,
              tableName: "beneficiaires",
              where: "beneficiaire_id",
            );
            if (checkBeneficiares == "0") {
              print("register beneficiaires !");
              if (e.beneficiaires[i].empreinteId != "0" ||
                  e.beneficiaires[i].empreinteId.isNotEmpty) {
                if (e.beneficiaires[i].apiEmpreintes != null) {
                  await DBHelper.saveOnlineFinger(
                      e.beneficiaires[i].apiEmpreintes);
                  print("register fingers !");
                }
              }
              await DBHelper.enregistrerBeneficiaire(
                siteId,
                paiement: e.beneficiaires[i],
              );
            }
          }
        });
      }
    }
  }
}
