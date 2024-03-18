class PayModel {
  int id;
  String paiementId;
  String beneficiaireId;
  String agentId;
  String siteId;
  String paiementMontant;
  String preuve1;
  String preuve2;
  String preuve3;
  String preuve4;
  String preuve5;
  String preuve6;
  List<String> preuves;

  PayModel({
    this.id,
    this.paiementId,
    this.beneficiaireId,
    this.agentId,
    this.siteId,
    this.paiementMontant,
    this.preuves,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["paiement_id"] = paiementId;
    data['beneficiaire_id'] = beneficiaireId;
    data['paiement_montant'] = double.parse(paiementMontant);
    data['site_id'] = siteId;
    data['agent_id'] = agentId;
    for (int i = 0; i < preuves.length; i++) {
      data["preuve_${i + 1}"] = preuves[i];
    }
    return data;
  }

  PayModel.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    paiementId = data["paiement_id"];
    agentId = data['agent_id'];
    beneficiaireId = data['beneficiaire_id'];
    paiementMontant = data['paiement_montant'];
    siteId = data['site_id'];
    preuve1 = data["preuve_1"];
    preuve2 = data["preuve_2"];
    preuve3 = data["preuve_3"];
    preuve4 = data["preuve_4"];
    preuve5 = data["preuve_5"];
    preuve6 = data["preuve_6"];
  }
}
