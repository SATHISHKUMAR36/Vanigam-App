class UserModel {
  String? message;
  String? tenantname;
  String? email;
  String? tenantid;
  String? role;
  String? agentid;
  List? stakeholdertypes;
  List? productlist;

  UserModel(
      {this.email,
      this.tenantid,
      this.message,
      this.tenantname,
      this.role,
      this.agentid,
      this.stakeholdertypes,
      this.productlist});

  // Convert a JSON map to a UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        email: json['email'],
        tenantid: json['tenantid'],
        message: json['message'],
        tenantname: json['tenantname'],
        role: json['role'],
        agentid: json['agentid'],
        stakeholdertypes: json['stakeholdertypes'],
        productlist: json['productlist']);
  }

  // Convert a UserModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'tenantid': tenantid,
      'agentid': agentid,
      'message ': message,
      'tenantname': tenantname,
      'role': role,
      'stakeholdertypes': stakeholdertypes,
      'productlist': productlist
    };
  }
}
