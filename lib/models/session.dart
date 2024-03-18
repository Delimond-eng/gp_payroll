class Session {
  int sessionId;
  String agentId;
  String siteId;
  String activiteId;
  List<String> preuves = <String>[];

  Session({
    this.sessionId,
    this.agentId,
    this.siteId,
    this.activiteId,
    this.preuves,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    if (sessionId != null) {
      data["session_id"] = sessionId;
    }
    data["agent_id"] = agentId;
    data["site_id"] = siteId;
    data["activite_id"] = activiteId;
    if (preuves.isNotEmpty) {
      for (int i = 0; i < preuves.length; i++) {
        data["preuve_${i + 1}"] = preuves[i];
      }
    }
    return data;
  }
}
