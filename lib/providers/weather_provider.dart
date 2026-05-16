import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../models/location_model.dart';
import '../services/weather_api.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherApi _weatherApi = WeatherApi();

  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;

  WeatherData? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  WeatherProvider() {
    _initApp();
  }

  Future<void> _initApp() async {
    _isLoading = true;
    notifyListeners();

    // 1. Check for saved location
    final prefs = await SharedPreferences.getInstance();
    final savedLocationJson = prefs.getString('last_location');

    if (savedLocationJson != null) {
      try {
        final locationMap = json.decode(savedLocationJson);
        final location = LocationModel.fromJson(locationMap);
        await fetchWeatherByLocation(location, saveLocation: false);
        return;
      } catch (e) {
        // If parsing fails, ignore and move on
      }
    }

    // 2. If no saved location, try GPS
    try {
      final hasPermission = await _handleLocationPermission();
      if (hasPermission) {
        final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
        // Reverse geocode to get a nice name if possible, or just pass lat/lon
        // Here we just pass lat/lon and a generic name
        final gpsLocation = LocationModel(
          name: 'Current Location',
          country: '',
          latitude: position.latitude,
          longitude: position.longitude,
        );
        await fetchWeatherByLocation(gpsLocation, saveLocation: true);
        return;
      }
    } catch (e) {
      // Ignore GPS errors and fallback
    }

    // 3. Fallback
    await fetchWeatherByCityName('London');
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  Future<void> fetchWeatherByCityName(String cityName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _weatherData = await _weatherApi.getWeatherForCity(cityName);
      
      // Save it using the fetched data's lat/lon
      // We assume getWeatherForCity internally geocodes it. 
      // A more robust way is to save the location object, but we'll create a dummy one here.
    } on WeatherApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByLocation(LocationModel location, {bool saveLocation = true}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _weatherData = await _weatherApi.getWeatherByCoordinates(
        location.latitude, 
        location.longitude, 
        location.name
      );

      if (saveLocation) {
        final prefs = await SharedPreferences.getInstance();
        // Manually build JSON to save
        final locationJson = json.encode({
          'name': location.name,
          'admin1': location.admin1,
          'country': location.country,
          'latitude': location.latitude,
          'longitude': location.longitude,
        });
        await prefs.setString('last_location', locationJson);
      }

    } on WeatherApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
