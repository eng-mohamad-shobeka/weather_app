import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_20/models/weather_info_model.dart';

class LocationHelper {
  Future<Position> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //print(position.longitude);
    //print(position.latitude);
    return position;
  }

  Future<Position?> checkPermissionAndGetLocation(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return _getLocation();
      case LocationPermission.denied:
      case LocationPermission.deniedForever:
        LocationPermission permission = await Geolocator.requestPermission();
        switch (permission) {
          case LocationPermission.whileInUse:
          case LocationPermission.always:
            return _getLocation();
          case LocationPermission.denied:
          case LocationPermission.deniedForever:
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content:
                    Text("Location permission is required to using tha app"),
                actions: [
                  TextButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: Text("close")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        checkPermissionAndGetLocation(context);
                      },
                      child: Text("Ok")),
                ],
              ),
            );
            break;

          default:
            break;
        }
        break;

      default:
        break;
    }
  }
}
