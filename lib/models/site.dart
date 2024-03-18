import 'package:gsa_payroll/api/models/sync_data.dart';

class Sites {
  int id;
  String siteId;
  String siteNom;
  String montantBudget;
  String montantDevise;
  String province;
  String ordreAlphabetique;
  Activites activite;

  Sites({
    this.id,
    this.siteId,
    this.siteNom,
    this.province,
    this.montantBudget,
    this.activite,
    this.ordreAlphabetique,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['site_id'] = siteId;
    data['site'] = siteNom;
    data['province'] = province;
    data['montant_budget'] = montantBudget;
    data['devise'] = montantDevise;
    data['site_ordre'] = ordreAlphabetique;
    return data;
  }

  Sites.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    siteId = json["site_id"];
    siteNom = json['site'];
    province = json['province'];
    montantBudget = json['montant_budget'];
    montantDevise = json['devise'];
    ordreAlphabetique = json['site_ordre'];
    if (json["activite_id"] != null) {
      activite = Activites.fromJson(json);
    }
  }
}
