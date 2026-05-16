import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../models/location_model.dart';

class WeatherApiException implements Exception {
  final String message;
  WeatherApiException(this.message);
  @override
  String toString() => message;
}

class WeatherApi {
  static const String _geocodeBaseUrl = 'https://geocoding-api.open-meteo.com/v1/search';
  static const String _weatherBaseUrl = 'https://api.open-meteo.com/v1/forecast';

  // Autocomplete search
  Future<List<LocationModel>> searchCities(String query) async {
    if (query.trim().isEmpty) return [];
    
    try {
      final url = Uri.parse('$_geocodeBaseUrl?name=${Uri.encodeComponent(query)}&count=10&language=en&format=json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['results'] != null) {
          final results = jsonResponse['results'] as List;
          return results.map((data) => LocationModel.fromJson(data)).toList();
        }
      }
      return [];
    } catch (e) {
      // In a real app, log error. Here we return empty list to not break the UI.
      return [];
    }
  }

  // Fetch by exact coordinates
  Future<WeatherData> getWeatherByCoordinates(double lat, double lon, String cityName) async {
    try {
      final weatherUrl = Uri.parse(
        '$_weatherBaseUrl?latitude=$lat&longitude=$lon'
        '&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,weather_code,wind_speed_10m'
        '&daily=weather_code,temperature_2m_max,temperature_2m_min'
        '&timezone=auto'
      );

      final weatherResponse = await http.get(weatherUrl);

      if (weatherResponse.statusCode != 200) {
        throw WeatherApiException('Failed to fetch weather data');
      }

      final weatherJson = json.decode(weatherResponse.body);
      return WeatherData.fromJson(weatherJson, cityName);
    } catch (e) {
      if (e is WeatherApiException) rethrow;
      throw WeatherApiException('Network error or invalid data');
    }
  }

  // Legacy fetch by city name (for initial load)
  Future<WeatherData> getWeatherForCity(String cityName) async {
    try {
      final results = await searchCities(cityName);
      if (results.isEmpty) {
        throw WeatherApiException('City not found');
      }
      
      final location = results.first;
      return await getWeatherByCoordinates(location.latitude, location.longitude, location.name);
    } catch (e) {
      if (e is WeatherApiException) rethrow;
      throw WeatherApiException('Network error or invalid data');
    }
  }
}
