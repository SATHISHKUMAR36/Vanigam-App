import 'dart:convert';

class Contacts {
  String? userid;
  String? name;
  String? tag;
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
  String? addressline1;
  String? city;
  String? state;
  String? country;
  String? pincode;
  String? nextmsgdate;
  String? stackholdertype;

  Contacts(
      {this.name,
      this.userid,
      this.tag,
      this.tenant,
      this.usertype,
      this.email,
      this.phone,
      this.lastmsged,
      this.customertype,
      this.actiontype,
      this.address,
      this.addressline1,
      this.city,
      this.state,
      this.country,
      this.pincode,
      this.productdata,
      this.nextmsgdate,
      this.productnames,
      this.notes,
      this.stackholdertype});

  factory Contacts.fromJson(Map<String, dynamic> json) {
    return Contacts(
        userid: json['userid'],
        name: json["name"],
        tag: json["Tag"],
        tenant: json["tenant"],
        usertype: json["usertype"],
        email: json["email"],
        phone: json["phone"],
        lastmsged: json["lastmessageddate"],
        customertype: json['customertype'],
        address: json['address'],
        addressline1: json['AddressLineOne'],
        city: json['City'],
        country: json['Country'],
        state: json['State'],
        pincode: json['Pincode'],
        productdata: json["product"],
        nextmsgdate: json["nextmsgdate"],
        actiontype: json["actiontype"],
        // productnames: json["product"].map((e) => e["productname"]).toList(),
        notes: jsonDecode(json["notes"]),
        stackholdertype: json["StakeHolderType"]);
  }
}
