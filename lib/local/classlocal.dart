class UserInfo {
  final String name_hospital;
  final String platfromURL;
  final String checkqueueURL;
  final String care_unit_id;
  final String passwordsetting;

  UserInfo(
      {required this.name_hospital,
      required this.platfromURL,
      required this.checkqueueURL,
      required this.care_unit_id,
      required this.passwordsetting});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
        name_hospital: json['name_hospital'],
        platfromURL: json['platfromURL'],
        checkqueueURL: json['checkqueueURL'],
        care_unit_id: json['care_unit_id'],
        passwordsetting: json['passwordsetting']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name_hospital': name_hospital,
      'platfromURL': platfromURL,
      'checkqueueURL': checkqueueURL,
      'passwordsetting': passwordsetting,
    };
  }
}
