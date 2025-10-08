class Agent{
  String? subagentid;
  String? subagentname;
  List? stakeholdertypecounts;


  Agent({this.subagentid,this.subagentname,this.stakeholdertypecounts});

  factory Agent.fromJson(Map<String,dynamic>json){
    return Agent(
      subagentid: json["subagentid"],
      subagentname: json['subagentname'],
      stakeholdertypecounts:json["stakeholdertypecounts"]
    );
  }
}
