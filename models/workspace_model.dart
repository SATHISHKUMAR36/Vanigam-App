import 'package:equatable/equatable.dart';

enum Features { CRM, Accounting }

extension FeaturesExtension on Features {
  String get displaytitle {
    switch (this) {
      case Features.CRM:
        return "CRM";
      case Features.Accounting:
        return "Accounting";
    }
  }

  String get imagelink {
    switch (this) {
      case Features.CRM:
        return "assets/images/crm3.png";
      case Features.Accounting:
        return "assets/images/accounting2.png";
    }
  }
}

class WorkspaceModel extends Equatable {
  String workspaceid;
  String? workspacename;
  String? workspacetype;
  String? description;
  String? website;
  String? extras;
  String? wsrole;
  String? tenantid;
  String? branchid;
  String? branchname;
  String? branchtype;
  String? branchemail;
  String? branchmobile;
  String? branchaddress;
  String? branchrole;
  String? branchextras;
  bool? isaccounting;
  bool? iscrm;

  WorkspaceModel(
      {required this.tenantid,
      required this.workspaceid,
      this.workspacename,
      this.workspacetype,
      this.description,
      this.website,
      this.extras,
      this.wsrole,
      this.branchid,
      this.branchname,
      this.branchtype,
      this.branchemail,
      this.branchmobile,
      this.branchaddress,
      this.branchrole,
      this.branchextras,
      this.isaccounting,
      this.iscrm});

  List<Features> get featuresenabled {
    List<Features> features = [];
    if (iscrm ?? false) features.add(Features.CRM);
    if (isaccounting ?? false) features.add(Features.Accounting);
    return features;
  }

  // Convert a JSON map to a WorkspaceModel
  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceModel(
      tenantid: json['TenantID'],
      workspaceid: json['WorkspaceID'],
      workspacename: json['WorkspaceName'],
      workspacetype: json['WorkspaceType'],
      description: json['Description'],
      website: json['Website'],
      extras: json['Extras'],
      wsrole: json['WSRole'],
      branchid: json['BranchID'],
      branchname: json['BranchName'],
      branchtype: json['BranchType'],
      branchaddress: json['BranchAddress'],
      branchemail: json['BranchEmailID'],
      branchmobile: json['BranchPhoneNumber'],
      branchrole: json['BranchRole'],
      branchextras: json['BranchExtras'],
      iscrm: json['ISCRM'] is int ? json['ISCRM'] == 1 : json['ISCRM'] as bool?,
      isaccounting: json['ISAccounting'] is int
          ? json['ISAccounting'] == 1
          : json['ISAccounting'] as bool?,
    );
  }

  // Convert a WorkspaceModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'TenantID': tenantid,
      'WorkspaceID': workspaceid,
      'WorkspaceName': workspacename,
      'WorkspaceType': workspacetype,
      'Website': website,
      'Extras': extras,
      'Description': description,
      'WSRole': wsrole,
      'BranchID': branchid,
      'BranchName': branchname,
      'BranchType': branchtype,
      'BranchAddress': branchaddress,
      'BranchEmailID': branchemail,
      'BranchPhoneNumber': branchmobile,
      'BranchRole': branchrole,
      'BranchExtras': branchextras,
      'ISCRM': iscrm,
      'ISAccounting': isaccounting
    };
  }

  @override
  List<Object?> get props => [
        tenantid,
        workspaceid,
        branchid,
        workspacename,
        workspacetype,
        website,
        extras,
        description,
        wsrole,
        branchname,
        branchtype,
        branchaddress,
        branchemail,
        branchmobile,
        branchrole,
        branchextras,
        isaccounting,
        iscrm
      ];
}
