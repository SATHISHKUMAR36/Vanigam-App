class Superuser {
  String? agentid;
  String? agentname;
  List? subagents;
  List? stakeholdertypecounts;

  Superuser({this.agentid, this.agentname, this.subagents,this.stakeholdertypecounts});

  factory Superuser.fromJson(Map<String, dynamic> json) {
    return Superuser(
        agentid: json['agentid'],
        agentname: json['agentname'],
        subagents: json['subagents'],
        stakeholdertypecounts:json["stakeholdertypecounts"]);
  }
}
