class CountryModel {
  String name;
  String capital;
  String flagUrl;

  CountryModel(
      {required this.name, required this.capital, required this.flagUrl});

  static List<CountryModel> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray
        .map((jsonObject) => CountryModel.fromJson(jsonObject))
        .toList();
  }

  factory CountryModel.fromJson(Map<String, dynamic> jsonObject) {
    return CountryModel(
      name: jsonObject["name"]["official"],
      capital: jsonObject["capital"] == null ? "" : jsonObject["capital"][0],
      flagUrl: jsonObject["flags"]["png"],
    );
  }
}
