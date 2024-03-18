import 'dart:async';
import 'package:gsa_payroll/api/models/sync_out_data.dart';
import 'package:gsa_payroll/models/paie.dart';
import 'package:gsa_payroll/models/session.dart';
import 'package:gsa_payroll/utilities/data_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database _db;
  static const String DB_NAME = 'gsa_data.db';

  static Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  static initDb() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  static _onCreate(Database db, int version) async {
    try {
      await db.transaction((txn) async {
        await txn.execute(
            "CREATE TABLE agents(id INTEGER PRIMARY KEY AUTOINCREMENT, agent_id TEXT, nom TEXT, telephone TEXT, pass TEXT, email TEXT)");
        await txn.execute(
            "CREATE TABLE beneficiaires(id INTEGER PRIMARY KEY AUTOINCREMENT, beneficiaire_id TEXT, num_compte TEXT, nom TEXT, telephone TEXT,matricule TEXT, netapayer TEXT, devise TEXT, sexe TEXT, etat_civil TEXT, date_naissance TEXT, empreinte_id TEXT, photo TEXT, signature_capture TEXT, ayant_droit TEXT, paiement_id TEXT, site_id TEXT)");
        await txn.execute(
            "CREATE TABLE activites(id INTEGER PRIMARY KEY AUTOINCREMENT, activite_id TEXT, montant_budget TEXT,devise TEXT, nom_representant TEXT,telephone_representant TEXT, site_id TEXT)");
        await txn.execute(
            "CREATE TABLE sites(id INTEGER PRIMARY KEY AUTOINCREMENT,site_id TEXT, site TEXT, province TEXT, site_ordre TEXT)");
        await txn.execute(
            "CREATE TABLE empreintes(empreinte_id INTEGER PRIMARY KEY AUTOINCREMENT, empreinte_1 TEXT, empreinte_2 TEXT, empreinte_3 TEXT)");
        await txn.execute(
          "CREATE TABLE paiements(id INTEGER PRIMARY KEY AUTOINCREMENT, paiement_id TEXT, beneficiaire_id TEXT, agent_id TEXT, site_id TEXT, paiement_montant REAL, preuve_1 TEXT, preuve_2 TEXT, preuve_3 TEXT,preuve_4 TEXT, preuve_5 TEXT, preuve_6 TEXT)",
        );
        await txn.execute(
          "CREATE TABLE sessions(id INTEGER PRIMARY KEY AUTOINCREMENT, agent_id TEXT, site_id TEXT, activite_id TEXT, preuve_1 TEXT, preuve_2 TEXT, preuve_3 TEXT,preuve_4 TEXT, preuve_5 TEXT, preuve_6 TEXT)",
        );
      });
    } catch (err) {
      print("error creating tables");
    }
  }

  /**
   * [Function] Permet d'enregistrer la session de paiement d'un agent
   * **/
  static Future<int> insertSession(Session session) async {
    var dbClient = await db;
    var lastInsertedSessionId = await dbClient.insert(
      "sessions",
      session.toJson(),
    );

    if (lastInsertedSessionId == null) return null;
    return lastInsertedSessionId;
  }

  static Future registerUser(Agents user) async {
    var dbClient = await db;
    try {
      await dbClient.transaction((txn) async {
        var batch = txn.batch();
        batch.rawQuery(
          "INSERT INTO agents(agent_id, nom, telephone,pass, email) VALUES(?,?,?,?,?)",
          [
            user.agentId,
            user.nom,
            user.telephone,
            user.pass,
            user.email,
          ],
        );
        await batch.commit(noResult: true);
      });
    } catch (e) {
      print("error from agents insert void $e");
    }
  }

  static Future enregistrerSites(Activites s) async {
    var dbClient = await db;

    try {
      await dbClient.transaction((txn) async {
        var batch = txn.batch();
        batch.rawQuery(
            "INSERT INTO sites(site_id, site, province, site_ordre) VALUES(?,?,?,?)",
            [s.siteId, s.site, s.province, s.beneficiairesOrdre]);
        await batch.commit(noResult: true);
      });
    } catch (e) {
      print("error from site insert void $e");
    }
  }

  static Future enregistrerActivites(Activites s) async {
    var dbClient = await db;
    try {
      await dbClient.transaction((txn) async {
        var batch = txn.batch();
        batch.rawQuery(
            "INSERT INTO activites(activite_id, montant_budget, devise, telephone_representant,nom_representant, site_id) VALUES(?,?,?,?,?,?)",
            [
              s.activiteId,
              s.montant,
              s.devise,
              s.telephoneRepresentant,
              s.nomRepresentant,
              s.siteId
            ]);
        await batch.commit(noResult: true);
      });
    } catch (e) {
      print("error from site insert void $e");
    }
  }

  static Future viewDatas({String tableName}) async {
    var dbClient = await db;
    var map;

    try {
      await dbClient.transaction((txn) async {
        map = await txn.query(tableName);
      });
    } catch (err) {
      print("error from view beneficiaire void $err");
    }
    if (map == null) {
      return null;
    }
    return map;
  }

  static Future query({String sql}) async {
    var dbClient = await db;
    var map;

    try {
      await dbClient.transaction((txn) async {
        map = await txn.rawQuery(sql);
      });
    } catch (err) {
      print("error from statment query $err");
    }

    if (map.isEmpty) {
      return null;
    }
    return map;
  }

  static Future loginUser({Agents user}) async {
    var dbClient = await db;

    var map;
    try {
      map = await dbClient.query("agents",
          where: "telephone=? AND pass=?",
          whereArgs: [user.telephone, user.pass]);
    } catch (e) {
      print("error from login statment $e");
    }
    return map;
  }

  static Future viewUsers() async {
    var dbClient = await db;
    int userId = storage.read('agent_id');
    return await dbClient
        .query("agents", where: "agent_id=?", whereArgs: [userId]);
  }

  static Future enrollerBeneficiaire(
      {Empreintes empreintes, Beneficiaire beneficiaire}) async {
    var dbClient = await db;
    int lastUpdateId;

    try {
      await dbClient.transaction((txn) async {
        int empreinteId = await txn.insert("empreintes", empreintes.toJson());
        if (empreinteId != null) {
          lastUpdateId = await txn.rawUpdate(
            "UPDATE beneficiaires SET empreinte_id = ?, photo = ?, signature_capture = ? WHERE beneficiaire_id=?",
            [
              empreinteId.toString(),
              beneficiaire.photo,
              beneficiaire.signatureCapture,
              beneficiaire.beneficiaireId,
            ],
          );
        }
      });
    } catch (err) {
      print('error from updating data!');
    }

    if (lastUpdateId == null) return null;
    return lastUpdateId;
  }

  static saveOnlineFinger(Empreintes empreinte) async {
    var dbClient = await db;
    await dbClient.insert("empreintes", empreinte.toJson());
  }

  static Future checkDatas(
      {String checkId, String where, String tableName}) async {
    var dbClient = await db;
    var map;
    try {
      await dbClient.transaction((txn) async {
        map =
            await txn.query(tableName, where: "$where=?", whereArgs: [checkId]);
      });
    } catch (e) {
      print("error from check beneficiaire $e");
    }
    if (map.isEmpty) {
      return "0";
    } else {
      return "1";
    }
  }

  static Future find({checkId, String where, String tableName}) async {
    var dbClient = await db;
    var map;
    try {
      await dbClient.transaction((txn) async {
        map =
            await txn.query(tableName, where: "$where=?", whereArgs: [checkId]);
      });
    } catch (e) {
      print("error from check beneficiaire $e");
    }
    if (map.isNotEmpty) {
      return map;
    } else {
      return [];
    }
  }

  static Future enregistrerBeneficiaire(String siteId,
      {Beneficiaire paiement}) async {
    var dbClient = await db;
    var lastInsertId;
    try {
      await dbClient.transaction((txn) async {
        var batch = txn.batch();

        batch.rawInsert(
            "INSERT INTO beneficiaires(beneficiaire_id, num_compte, nom, netapayer,devise, telephone,matricule, sexe, etat_civil, date_naissance, empreinte_id, photo, signature_capture, ayant_droit, paiement_id, site_id) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
            [
              paiement.beneficiaireId,
              paiement.numCompte,
              paiement.nom,
              paiement.netapayer,
              paiement.devise,
              paiement.telephone,
              paiement.matricule,
              paiement.sexe,
              paiement.etatCivil,
              paiement.dateNaissance,
              paiement.empreinteId,
              paiement.photo,
              paiement.signatureCapture,
              paiement.ayantDroit,
              paiement.paiementId,
              siteId
            ]);
        await batch.commit(noResult: true);
      });
    } catch (e) {
      print("error from register beneficiaire $e");
    }
  }

  static Future payerBeneficiaire(PayModel paie) async {
    var dbClient = await db;
    var lastInsertedId;
    try {
      await dbClient.transaction((txn) async {
        lastInsertedId = await txn.insert("paiements", paie.toJson());
      });
    } catch (err) {
      print("error from payment statment $err");
    }

    if (lastInsertedId == null) return null;
    return lastInsertedId;
  }

  /**
   * Method pour recuperer un bénéficiaire dans la DB local selon son empreinte_id.
   */
  static Future scannerBeneficiaire({String empreinteId}) async {
    var dbClient = await db;
    return await dbClient.query('beneficiaires',
        where: 'empreinte_id=?', whereArgs: ['$empreinteId']);
  }

  /**
   * Method pour recuperer toutes les empreintes dans la DB local.
   */
  static Future getAllFingers({where}) async {
    var dbClient = await db;
    if (where != null) {
      var map = await dbClient.query(
        "empreintes",
        where: "empreinte_id = ?",
        whereArgs: [where],
      );
      if (map.isEmpty) return null;
      return map;
    }
    var map = await dbClient.query('empreintes');
    if (map.isEmpty) return null;
    return map;
  }

  static Future getBeneficiaires() async {
    var dbClient = await db;
    var list = await dbClient.query("beneficiaires", orderBy: "id DESC");
    return list;
  }
}
