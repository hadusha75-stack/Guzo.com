class Traveler {
  String firstName;
  String lastName;
  String gender;
  String birthDate;
  String email;
  String phone;

  Traveler({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.birthDate,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "birthDate": birthDate,
      "email": email,
      "phoneNo": phone,
      "paxType": "ADT",
    };
  }
}
