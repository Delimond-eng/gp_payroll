import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../services/db_helper.dart';
import 'package:http/http.dart' as Api;
import 'package:path_provider/path_provider.dart';

import '../global/controllers.dart';
import 'models/sync_out_data.dart';

class ApiManagerService {
  static const String baseURL = "http://gsa-central-server.rtgroup-rdc.com";

  static Future<SyncOutData> getDatas() async {
    final response = await Api.get(
      Uri.parse("$baseURL/data/sync/out"),
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return SyncOutData.fromJson(jsonResponse);
    } else {
      EasyLoading.dismiss();
      return null!;
    }
  }

  static Future<SyncOutData> takeAgentData(String agentId) async {
    final response = await Api.post(
      Uri.parse("$baseURL/data/sync/out"),
      body: {
        "agent_id": agentId,
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return SyncOutData.fromJson(jsonResponse);
    } else {
      EasyLoading.dismiss();
      return null!;
    }
  }

  static Future inPutData() async {
    var dataConnection = await (Connectivity().checkConnectivity());
    if (dataConnection != ConnectivityResult.mobile ||
        dataConnection != ConnectivityResult.wifi) {
      return 0;
    }
    var beneficiaires = await DBHelper.query(
        sql:
            "SELECT beneficiaire_id, photo, signature_capture FROM beneficiaires");

    var empreintes = await DBHelper.query(
        sql:
            "SELECT beneficiaire_id, empreinte_1,empreinte_2,empreinte_3 FROM empreintes INNER JOIN beneficiaires ON empreintes.empreinte_id = beneficiaires.empreinte_id");
    var paiements =
        await DBHelper.query(sql: "SELECT paiement_id FROM paiements");

    var paiementPreuves = await DBHelper.query(
        sql:
            "SELECT paiement_id, preuve_1,preuve_2,preuve_3,preuve_4, preuve_5, preuve_6 FROM paiements");
    var sessions = await DBHelper.query(
        sql:
            "SELECT activite_id,agent_id, preuve_1, preuve_2, preuve_3, preuve_4, preuve_5, preuve_6 FROM sessions");
    String json = jsonEncode({
      'beneficiaires': beneficiaires,
      'empreintes': empreintes,
      'paiements': paiements,
      'paiement_preuves': paiementPreuves,
      'activite_clotures': sessions
    });

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String filename = "file.json";

    var res;

    File file = File(tempPath + "/" + filename);
    file.createSync();
    file.writeAsStringSync(json);
    try {
      var request =
          Api.MultipartRequest('POST', Uri.parse("$baseURL/data/sync/in"));

      //request.fields['agent_id'] = "1";

      request.files.add(
        Api.MultipartFile.fromBytes(
          'data',
          file.readAsBytesSync(),
          filename: filename.split("/").last,
        ),
      );
      request
          .send()
          .then((result) async {
            Api.Response.fromStream(result).then((response) {
              if (response.statusCode == 200) {
                res = response.body;
              }
            });
          })
          .catchError((err) => print('error : ' + err.toString()))
          .whenComplete(() {});
    } catch (err) {
      print("error from $err");
    }
    if (res == null) {
      return null;
    } else {
      return res;
    }
  }
}
