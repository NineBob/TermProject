class universities {
  final String name;
  final String province;
  final String country;
  final String url;


  universities({
    required this.name,
    required this.province,
    required this.country,
    required this.url,

  });

  factory universities.fromJson(Map<String, dynamic> json) {
    return universities(
      name: json['name'],
      province: json['state-province'].toString(),
      country: json['alpha_two_code'],
      url: json['web_pages'].toString(),

    );
  }
}