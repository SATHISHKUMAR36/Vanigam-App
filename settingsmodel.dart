class SettingsModel {
  String? name;
  String? description;
  String? value;

  SettingsModel({this.name, this.description, this.value});

  factory SettingsModel.fromMap(Map<String, dynamic> data) => SettingsModel(
        name: data['Name'] as String?,
        description: data['Description'] as String?,
        value: data['Value'] as String?,
      );

  Map<String, dynamic> toMap() => {
        "Name": name,
        "Description": description,
        "Value": value,
      };
}
