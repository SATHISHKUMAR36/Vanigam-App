class User {
  String userid;
  String? email;
  String? firstname;
  String? lastname;
  String? phonenumber;
  String? userrole;
  String? language;
  String? status;
  bool? emailverified;
  bool? phonenumberverified;
  int? invalidattempts;

  User(
      {required this.userid,
      this.email,
      this.firstname,
      this.lastname,
      this.phonenumber,
      this.language,
      this.status,
      this.emailverified,
      this.phonenumberverified,
      this.invalidattempts,
      this.userrole});

  // Convert a JSON map to a User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userid: json['userid'],
        email: json['email'],
        // tenants: (json['tenants'] as List<dynamic>?)
        //     ?.map((e) => TenantModel.fromJson(e as Map<String, dynamic>))
        //     .toList(),

        firstname: json['first_name'],
        lastname: json['last_name'],
        phonenumber: json['phone_number'],
        language: json['language'],
        userrole: json['user_role'],
        status: json['status'],
        emailverified: json['email_verified'] is int
            ? json['email_verified'] == 1
            : json['email_verified'] as bool?,
        phonenumberverified: json['phone_number_verified'] is int
            ? json['phone_number_verified'] == 1
            : json['phone_number_verified'] as bool?,
        invalidattempts: json['invalid_attempts']);
  }

  // Convert a User to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'email': email,
      //'tenants': tenants?.map((e) => e.toJson()).toList(),
      'first_name': firstname,
      'last_name': lastname,
      'phone_number': phonenumber,
      'language': language,
      'user_role': userrole,
      'status': status,
      'email_verified': emailverified,
      'phone_number_verified': phonenumberverified,
      'invalid_attempts': invalidattempts
    };
  }
}
