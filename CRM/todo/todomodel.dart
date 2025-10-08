import 'dart:convert';

class Todomodel {
  String? userid;
  String? name;
  String? status;
  String? tenant;
  String? usertype;
  String? email;
  String? phone;
  String? lastmsged;
  List? productdata;
  List? productnames;
  List? notes;
  String? customertype;
  String? actiontype;
  String? address;
  String? nextmsgdate;
  String? callmailstatus;
  String? stackholdertype;
  String? tag;

  Todomodel(
      {this.name,
      this.userid,
      this.status,
      this.tenant,
      this.usertype,
      this.email,
      this.phone,
      this.lastmsged,
      this.customertype,
      this.actiontype,
      this.address,
      this.productdata,
      this.nextmsgdate,
      this.productnames,
      this.notes,
      this.callmailstatus,
      this.stackholdertype,
      this.tag});

  factory Todomodel.fromJson(Map<String, dynamic> json) {
    return Todomodel(
        userid: json['userid'],
        name: json["name"],
        status: json["status"],
        tenant: json["tenant"],
        usertype: json["usertype"],
        email: json["email"],
        phone: json["phone"],
        lastmsged: json["lastmessageddate"],
        customertype: json['customertype'],
        address: json['address'],
        productdata: json["product"],
        nextmsgdate: json["nextmsgdate"],
        actiontype: json["actiontype"],
        // productnames: json["product"].map((e) => e["productname"]).toList(),
        notes: jsonDecode(json["notes"]),
        callmailstatus: json["CallMailStatus"],
        stackholdertype: json['StakeHolderType'],
        tag: json['tag']);
  }
}
