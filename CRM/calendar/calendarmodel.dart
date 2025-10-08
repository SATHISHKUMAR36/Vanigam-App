class Calendarmodel {
  String?date;
  int?contactcount;
  int?leadcount;
  int?customercount;
  Calendarmodel({this.contactcount,this.date,this.customercount,this.leadcount});
  factory Calendarmodel.fromJson(Map<String,dynamic> json){
    return Calendarmodel(
     date:json['date'],
     contactcount: json['Contact'],
     leadcount: json['Lead'],
     customercount: json['Customer']
    );
  }
}