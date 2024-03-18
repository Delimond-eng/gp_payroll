class SyncOutData {
  Data data;

  SyncOutData({this.data});

  SyncOutData.fromJson(Map<String, dynamic> json) {
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

  Agents({
    this.agentId,
    this.adminId,
    this.nom,
    this.email,
    this.telephone,
    this.pass,
    this.photo,
    this.agentStatus,
    this.empreinteId,
    this.dateEnregistrement,
  });

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
    dateEnregistrement = json['date_enregistrement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['agent_id'] = agentId;
    data['admin_id'] = adminId;
    data['nom'] = nom;
    data['email'] = email;
    data['telephone'] = telephone;
    data['pass'] = pass;
    data['photo'] = photo;
    data['agent_status'] = agentStatus;
    data['empreinte_id'] = empreinteId;
    data['date_enregistrement'] = dateEnregistrement;
    return data;
  }
}

class Activites {
  String activiteDate;
  String activiteId;
  String siteId;
  String devise;
  String nomRepresentant;
  String telephoneRepresentant;
  String site;
  String province;
  String montant;
  List<Beneficiaire> beneficiaires;
  String beneficiairesOrdre;

  Activites({
    this.activiteDate,
    this.activiteId,
    this.siteId,
    this.devise,
    this.nomRepresentant,
    this.telephoneRepresentant,
    this.site,
    this.province,
    this.montant,
    this.beneficiaires,
    this.beneficiairesOrdre,
  });

  Activites.fromJson(Map<String, dynamic> json) {
    activiteDate = json['activite_date'];
    activiteId = json['activite_id'];
    siteId = json['site_id'];
    devise = json['devise'];
    nomRepresentant = json['nom_representant'];
    telephoneRepresentant = json['telephone_representant'];
    site = json['site'];
    province = json['province'];
    montant = json['montant'];
    if (json['paiements'] != null) {
      beneficiaires = <Beneficiaire>[];
      json['paiements'].forEach((v) {
        beneficiaires.add(Beneficiaire.fromJson(v));
      });
    }
    beneficiairesOrdre = json['beneficiaires'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['activite_date'] = activiteDate;
    data['activite_id'] = activiteId;
    data['site_id'] = siteId;
    data['devise'] = devise;
    data['nom_representant'] = nomRepresentant;
    data['telephone_representant'] = telephoneRepresentant;
    data['site'] = site;
    data['province'] = province;
    data['montant'] = montant;
    if (beneficiaires != null) {
      data['paiements'] = beneficiaires.map((v) => v.toJson()).toList();
    }
    data['beneficiaires'] = beneficiairesOrdre;
    return data;
  }
}

class Beneficiaire {
  String paiementId;
  String societe;
  String netapayer;
  String devise;
  String beneficiaireId;
  String numCompte;
  String nom;
  String telephone;
  String sexe;
  String matricule;
  String identifiant;
  String etatCivil;
  String dateNaissance;
  String empreinteId;
  String photo;
  String signatureCapture;
  String ayantDroit;
  String siteId;
  List<Empreintes> empreintes;
  Empreintes apiEmpreintes;

  Beneficiaire({
    this.paiementId,
    this.societe,
    this.netapayer,
    this.devise,
    this.beneficiaireId,
    this.numCompte,
    this.nom,
    this.telephone,
    this.sexe,
    this.matricule,
    this.identifiant,
    this.etatCivil,
    this.dateNaissance,
    this.empreinteId,
    this.photo,
    this.signatureCapture,
    this.ayantDroit,
    this.empreintes,
    this.siteId,
  });

  Beneficiaire.fromJson(Map<String, dynamic> json) {
    paiementId = json['paiement_id'];
    societe = json['societe'];
    netapayer = json['netapayer'];
    devise = json['devise'];
    beneficiaireId = json['beneficiaire_id'];
    numCompte = json['num_compte'];
    nom = json['nom'];
    telephone = json['telephone'];
    sexe = json['sexe'];
    matricule = json['matricule'];
    identifiant = json['identifiant'];
    etatCivil = json['etat_civil'];
    dateNaissance = json['date_naissance'];
    empreinteId = json['empreinte_id'];
    photo = json['photo'];
    signatureCapture = json['signature_capture'];
    apiEmpreintes = json['empreintes'] != null
        ? Empreintes.fromJson(json['empreintes'])
        : null;
    ayantDroit = json['ayant_droit'];
    siteId = json['site_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['paiement_id'] = paiementId;
    data['societe'] = societe;
    data['netapayer'] = netapayer;
    data['devise'] = devise;
    data['beneficiaire_id'] = beneficiaireId;
    data['num_compte'] = numCompte;
    data['nom'] = nom;
    data['telephone'] = telephone;
    data['sexe'] = sexe;
    data['matricule'] = matricule;
    data['identifiant'] = identifiant;
    data['etat_civil'] = etatCivil;
    data['date_naissance'] = dateNaissance;
    data['empreinte_id'] = empreinteId;
    data['photo'] = photo;
    data['signature_capture'] = signatureCapture;
    data['ayant_droit'] = ayantDroit;
    data['site_id'] = siteId;
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
    final Map<String, dynamic> data = {};
    if (empreinteId != null) {
      data['empreinte_id'] = int.parse(empreinteId);
    }
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
