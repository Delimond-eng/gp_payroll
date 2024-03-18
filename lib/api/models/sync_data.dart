class SynchroneDatas {
  Data data;

  SynchroneDatas({this.data});

  SynchroneDatas.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Agents> agents;
  List<Activites> activites;

  Data({this.agents, this.activites});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['agents'] != null) {
      agents = <Agents>[];
      json['agents'].forEach((v) {
        agents.add(Agents.fromJson(v));
      });
    }
    if (json['activites'] != null) {
      activites = <Activites>[];
      json['activites'].forEach((v) {
        activites.add(Activites.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (agents != null) {
      data['agents'] = agents.map((v) => v.toJson()).toList();
    }
    if (activites != null) {
      data['activites'] = activites.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Agents {
  String agentId;
  String adminId;
  String nom;
  String email;
  String telephone;
  String pass;
  String photo;
  String agentStatus;
  String empreinteId;
  String dateEnregistrement;

  Agents(
      {this.agentId,
      this.adminId,
      this.nom,
      this.email,
      this.telephone,
      this.pass,
      this.photo,
      this.agentStatus,
      this.empreinteId,
      this.dateEnregistrement});

  Agents.fromJson(Map<String, dynamic> json) {
    agentId = json['agent_id'];
    adminId = json['admin_id'];
    nom = json['nom'];
    email = json['email'];
    telephone = json['telephone'];
    pass = json['pass'];
    photo = json['photo'];
    agentStatus = json['agent_status'];
    empreinteId = json['empreinte_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['agent_id'] = agentId;
    data['nom'] = nom;
    data['email'] = email;
    data['telephone'] = telephone;
    data['pass'] = pass;
    data['photo'] = photo;
    data['empreinte_id'] = empreinteId;
    return data;
  }
}

class Activites {
  int id;
  String activiteId;
  String siteId;
  String montantBudget;
  String devise;
  String nomRepresentant;
  String telephoneRepresentant;
  String site;
  String province;
  List<Paiements> paiements;

  Activites({
    this.id,
    this.activiteId,
    this.siteId,
    this.montantBudget,
    this.nomRepresentant,
    this.telephoneRepresentant,
    this.site,
    this.province,
    this.paiements,
  });

  Activites.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    activiteId = json['activite_id'];
    siteId = json['site_id'];
    montantBudget = json['montant_budget'];
    devise = json['devise'];
    nomRepresentant = json['nom_representant'];
    telephoneRepresentant = json['telephone_representant'];
    site = json['site'];
    province = json['province'];
    if (json['paiements'] != null) {
      paiements = <Paiements>[];
      json['paiements'].forEach((v) {
        paiements.add(Paiements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['activite_id'] = activiteId;
    data['site_id'] = siteId;
    data['montant_budget'] = montantBudget;
    data['nom_representant'] = nomRepresentant;
    data['devise'] = devise;
    data['telephone_representant'] = telephoneRepresentant;
    data['site'] = site;
    data['province'] = province;
    if (paiements != null) {
      data['paiements'] = paiements.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Paiements {
  int id;
  String paiementId;
  String societe;
  String netApayer;
  String devise;
  String beneficiaireId;
  String numCompte;
  String nom;
  String matricule;
  String telephone;
  String sexe;
  String etatCivil;
  String dateNaissance;
  String empreinteId;
  String photo;
  String signatureCapture;
  String ayantDroit;
  List<Empreintes> empreintes;

  Paiements(
      {this.id,
      this.paiementId,
      this.societe,
      this.netApayer,
      this.devise,
      this.beneficiaireId,
      this.numCompte,
      this.nom,
      this.matricule,
      this.telephone,
      this.sexe,
      this.etatCivil,
      this.dateNaissance,
      this.empreinteId,
      this.photo,
      this.signatureCapture,
      this.ayantDroit,
      this.empreintes});

  Paiements.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paiementId = json['paiement_id'];
    societe = json['societe'];
    netApayer = json['netapayer'];
    devise = json['devise'];
    beneficiaireId = json['beneficiaire_id'];
    numCompte = json['num_compte'];
    matricule = json['matricule'];
    nom = json['nom'];
    telephone = json['telephone'];
    sexe = json['sexe'];
    etatCivil = json['etat_civil'];
    dateNaissance = json['date_naissance'];
    empreinteId = json['empreinte_id'];
    photo = json['photo'];
    signatureCapture = json['signature_capture'];
    ayantDroit = json['ayant_droit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['paiement_id'] = paiementId;
    data['societe'] = societe;
    data['netapayer'] = netApayer;
    data['devise'] = devise;
    data['beneficiaire_id'] = beneficiaireId;
    data['num_compte'] = numCompte;
    data['matricule'] = matricule;
    data['nom'] = nom;
    data['telephone'] = telephone;
    data['sexe'] = sexe;
    data['etat_civil'] = etatCivil;
    data['date_naissance'] = dateNaissance;
    data['empreinte_id'] = empreinteId;
    data['photo'] = photo;
    data['signature_capture'] = signatureCapture;
    data['ayant_droit'] = ayantDroit;

    return data;
  }
}

class Empreintes {
  String empreinteId;
  String empreinte1;
  String empreinte2;
  String empreinte3;

  Empreintes(
      {this.empreinteId, this.empreinte1, this.empreinte2, this.empreinte3});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['empreinte_id'] = empreinteId;
    data['empreinte_1'] = empreinte1;
    data['empreinte_2'] = empreinte2;
    data['empreinte_3'] = empreinte3;
    return data;
  }

  Empreintes.fromJson(Map<String, dynamic> map) {
    empreinteId = map['empreinte_id'];
    empreinte1 = map['empreinte_1'];
    empreinte2 = map['empreinte_2'];
    empreinte3 = map['empreinte_3'];
  }
}
