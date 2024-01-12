import 'package:drmohans_homecare_flutter/network/network_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final locationServiceProvider = StateProvider((ref) {
  final service = ref.watch(dioProvider);
  return LocationService(service);
});

class LocationService {
  final NetworkClient service;
  LocationService(this.service);

  ///Convert lat lng to city name using google api
  Future<CityLocationData?> getLocation(double lat, double lng) async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&result_type=political&key=AIzaSyBuUhvxFgX3m3845a8TvU4DHVIJXHihHnc';
      final response = await service.getRequestWithoutToken(url);
      print("lat-long--------------->$response");
      final allComponent = response['results'] as List;
      final addressComponent = allComponent.first['formatted_address'];
      return CityLocationData(
        address: addressComponent,
      );
    } catch (e) {
      print("Google geocoding error: $e");
      rethrow;
    }
  }

  getLatLong() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue accessing the position and request users of the App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try requesting permissions again (this is also where Android's shouldShowRequestPermissionRationale returned true. According to Android guidelines your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // When we reach here, permissions are granted and we can continue accessing the position of the device.
      final data = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return {"lat": data.latitude, "long": data.longitude};
    } catch (err) {
      rethrow;
    }
  }

  // Future<void> recordCityOnServer(String city, String country)async{
  //   try{
  //     String? savedCity = _preference.getString(SharedPrefsKey.cityName)?.toLowerCase();
  //     final currentCity = city.toLowerCase();
  //     ///Save city is null means user does not have have previous location, we save
  //     ///the current location as active location
  //     if(savedCity == null){
  //       _dashboardService.saveCurrentLocation(currentCity, country.toLowerCase(), uid);
  //     }else{
  //       ///User have last location, so save the current city and saved city in location history
  //       _dashboardService.saveCurrentLocation(currentCity, country.toLowerCase(), uid);
  //       _dashboardService.saveLocationHistory(currentCity, country.toLowerCase(), uid);
  //     }
  //   }catch(e){
  //     print('CITY RECORD FAILED');
  //   }
  // }
}

class CityLocationData {
  String? address;
  CityLocationData({this.address});
}
