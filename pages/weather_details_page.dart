import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_20/helpers/api_helper.dart';
import 'package:weather_app_20/helpers/location_helper.dart';
import 'package:weather_app_20/models/weather_info_model.dart';
import 'package:weather_app_20/pages/selecte_city_page.dart';

class WeatherDetailsPage extends StatefulWidget {
  const WeatherDetailsPage({Key? key}) : super(key: key);

  @override
  State<WeatherDetailsPage> createState() => _WeatherDetailsPageState();
}

class _WeatherDetailsPageState extends State<WeatherDetailsPage> {
  LocationHelper locationHelper = LocationHelper();
  ApiHelper apiHelper = ApiHelper();

  WeatherInfoModel weatherInfo =
      WeatherInfoModel(cityName: "", weatherStatus: "", temp: 0, iconCode: "");

  bool isLoadingData = false;

  void getWeatherInfoForCity(String cityName) async {
    setState(() {
      isLoadingData = true;
    });
    weatherInfo = await apiHelper.getWeatherInfoByName(cityName);
    setState(() {
      isLoadingData = false;
    });
  }

  void getWeatherInfoForMyLocation() async {
    setState(() {
      isLoadingData = true;
    });

    Position? position =
        await locationHelper.checkPermissionAndGetLocation(context);
    if (position != null) {
      weatherInfo = await apiHelper.getWeatherInfoByGeoCordinates(
          position.latitude, position.longitude);
    }
    setState(() {
      isLoadingData = false;
    });
  }

  @override
  void initState() {
    getWeatherInfoForMyLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/bg_img.jpg"),
        fit: BoxFit.fill,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white.withAlpha(50),
          elevation: 0,
          title: Text(weatherInfo.cityName),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          actions: [
            IconButton(
                onPressed: () {
                  getWeatherInfoForMyLocation();
                },
                icon: Icon(
                  Icons.refresh,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () async {
                  String? cityName = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectCityPage()));
                  if (cityName != null) {
                    getWeatherInfoForCity(cityName);
                  }
                },
                icon: Icon(
                  Icons.location_city,
                  color: Colors.black,
                )),
          ],
        ),
        body: Center(
          child: isLoadingData
              ? CircularProgressIndicator(
                  color: Colors.red,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(weatherInfo.getIconPath()),
                    Text(
                      weatherInfo.temp.toStringAsFixed(0),
                      style: TextStyle(fontSize: 70),
                    ),
                    Text(
                      weatherInfo.weatherStatus,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
