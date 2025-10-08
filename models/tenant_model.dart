import 'package:equatable/equatable.dart';

class TenantModel extends Equatable {
  String tenantid;
  String? tenantname;
  String? tenanttype;
  String? description;
  String? industry;
  String? address;
  String? phonenumber;
  String? emailid;
  String? gstnumber;
  String? pannumber;
  String? uein;
  String? website;
  String? userrole;

  TenantModel({
    required this.tenantid,
    this.tenantname,
    this.tenanttype,
    this.description,
    this.industry,
    this.address,
    this.phonenumber,
    this.emailid,
    this.gstnumber,
    this.pannumber,
    this.uein,
    this.website,
    this.userrole,
  });

  // Convert a JSON map to a TenantModel
  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return TenantModel(
      tenantid: json['TenantID'],
      tenantname: json['TenantName'],
      tenanttype: json['TenantType'],
      description: json['Description'],
      industry: json['Industry'],
      address: json['Address'],
      phonenumber: json['PhoneNumber'],
      emailid: json['EmailID'],
      gstnumber: json['GstNumber'],
      pannumber: json['PanNumber'],
      uein: json['UEIN'],
      website: json['Website'],
      userrole: json['UserRole'],
    );
  }

  // Convert a TenantModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'TenantID': tenantid,
      'TenantName': tenantname,
      'TenantType': tenanttype,
      'Description': description,
      'Industry': industry,
      'Address': address,
      'PhoneNumber': phonenumber,
      'EmailID': emailid,
      'GstNumber': gstnumber,
      'PanNumber': pannumber,
      'UEIN': uein,
      'Website': website,
      'UserRole': userrole,
    };
  }

  @override
  List<Object?> get props => [
        tenantid,
        tenantname,
        tenanttype,
        industry,
        gstnumber,
        pannumber,
        uein,
        userrole
      ];
}
