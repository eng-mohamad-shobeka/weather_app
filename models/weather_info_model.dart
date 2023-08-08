import 'dart:convert';

class WeatherInfoModel {
  String cityName;
  String weatherStatus;
  double temp;
  String iconCode;

  WeatherInfoModel({
    required this.cityName,
    required this.weatherStatus,
    required this.temp,
    required this.iconCode,
  });

  String getIconPath() {
    return "https://openweathermap.org/img/wn/$iconCode@2x.png";
  }

  factory WeatherInfoModel.fromJson(String jsonObject) {
    Map<String, dynamic> data = jsonDecode(jsonObject);
    return WeatherInfoModel(
      cityName: data["name"],
      weatherStatus: data["weather"][0]["main"],
      temp: data["main"]["temp"],
      iconCode: data["weather"][0]["icon"],
    );
  }
}
