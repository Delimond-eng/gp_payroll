import 'package:get/get.dart';
import '../models/site.dart';
import '../services/db_helper.dart';
import '../utilities/data_storage.dart';

import '../api/models/sync_out_data.dart';

class UserSessionController extends GetxController {
  static UserSessionController instace = Get.find();

  var loggedUser = Agents().obs;
  var selectedAgency = Sites().obs;
  var agenciesList = <Sites>[].obs;
  var preuvesSessions = <String>[].obs;

  @override
  onInit() {
    super.onInit();
    refreshDatas();
  }

  refreshDatas() {
    fetchAgencies();
    refreshStorageData();
  }

  refreshStorageData() {
    var jsonData = storage.read("ags");

    if (jsonData != null) {
      selectedAgency.value = Sites.fromJson(jsonData);
    } else {
      selectedAgency.value = null;
    }
  }

  fetchAgencies() async {
    var data = await DBHelper.query(
        sql:
            "SELECT * FROM sites INNER JOIN activites ON sites.site_id = activites.site_id");
    if (data != null) {
      agenciesList.clear();
      data.forEach((e) {
        agenciesList.add(Sites.fromJson(e));
      });
    }
  }
}
