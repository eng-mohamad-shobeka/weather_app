import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:weather_app_20/models/weather_info_model.dart';

import '../models/country_model.dart';

const kBaseURL = "https://api.openweathermap.org/data/2.5";
const kWeatherDetailsMethod = "/weather";

const kOpenWeatherMapKey = "d1038b2c4d58da539fc6db99071637e2";

const kCountryListURL = "https://restcountries.com/v3.1/all";

class ApiHelper {
  Future<WeatherInfoModel> getWeatherInfoByGeoCordinates(
      double lat, double lon) async {
    http.Response response = await http.get(Uri.parse("$kBaseURL"
        "$kWeatherDetailsMethod"
        "?lat=$lat"
        "&lon=$lon"
        "&appid=$kOpenWeatherMapKey"
        "&units=metric"));

    if (response.statusCode == 200) {
      return WeatherInfoModel.fromJson(response.body);
      /* Map<String, dynamic> data = JsonDecoder().convert(response.body);
      String cityName = data["name"];
      double temp = data["main"]["temp"];
      String weatherStatus = data["weather"][0]["main"];
      print(cityName);
      print(temp);
      print(weatherStatus);

      WeatherInfoModel weatherInfoModel = WeatherInfoModel(
          cityName: cityName, weatherStatus: weatherStatus, temp: temp);
      return weatherInfoModel;*/
    } else {
      //TODO: handle error status;
      return WeatherInfoModel(
          cityName: "", weatherStatus: "weatherStatus", temp: 0, iconCode: "");
    }
  }

  Future<WeatherInfoModel> getWeatherInfoByName(String cityName) async {
    http.Response response = await http.get(Uri.parse("$kBaseURL"
        "$kWeatherDetailsMethod"
        "?q=$cityName"
        "&appid=$kOpenWeatherMapKey"
        "&units=metric"));

    if (response.statusCode == 200) {
      return WeatherInfoModel.fromJson(response.body);
      /* Map<String, dynamic> data = JsonDecoder().convert(response.body);
      String cityName = data["name"];
      double temp = data["main"]["temp"];
      String weatherStatus = data["weather"][0]["main"];
      print(cityName);
      print(temp);
      print(weatherStatus);

      WeatherInfoModel weatherInfoModel = WeatherInfoModel(
          cityName: cityName, weatherStatus: weatherStatus, temp: temp);
      return weatherInfoModel;*/
    } else {
      //TODO: handle error status;
      return WeatherInfoModel(
          cityName: "", weatherStatus: "weatherStatus", temp: 0, iconCode: "");
    }
  }

  Future<List<CountryModel>> getCountryList() async {
    http.Response response = await http.get(Uri.parse(kCountryListURL));

    if (response.statusCode == 200) {
      return CountryModel.fromJsonArray(jsonDecode(response.body));
    } else {
      //TODO: handle error status;
      return [];
    }
  }
}
