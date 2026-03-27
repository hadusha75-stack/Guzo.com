class Airport {
  final String name;
  final String code;
  final String city;

  Airport({required this.name, required this.code, required this.city});

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(name: json['name'], code: json['code'], city: json['city']);
  }
}
