class Leadsschedulemodel {
 int?count;
  String?name;
  Leadsschedulemodel({this.name,this.count});
  factory Leadsschedulemodel.fromJson(Map<String, dynamic> json ){
return Leadsschedulemodel(

 name:json["name"],
  count: json["count"]
);
  }
}


class CustomerSubscription {
  int?count;
  String?name;
  CustomerSubscription({this.name,this.count});
  factory CustomerSubscription.fromJson(Map<String, dynamic> json ){
return CustomerSubscription(

  name:json["name"],
  count: json["count"]
);
  }
}

class StakeHolderTypes {
  int?count;
  String?name;
  StakeHolderTypes({this.name,this.count});
  factory StakeHolderTypes.fromJson(Map<String, dynamic> json ){
return StakeHolderTypes(

  
  name:json["name"],
  count: json["count"]
);
  }
}