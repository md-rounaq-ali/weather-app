class WeatherData {
  final CurrentWeather current;
  final List<DailyForecast> daily;
  final String cityName;

  WeatherData({
    required this.current,
    required this.daily,
    required this.cityName,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json, String cityName) {
    final currentJson = json['current'];
    final dailyJson = json['daily'];

    List<DailyForecast> dailyForecasts = [];
    if (dailyJson != null) {
      List<dynamic> times = dailyJson['time'];
      List<dynamic> weatherCodes = dailyJson['weather_code'];
      List<dynamic> maxTemps = dailyJson['temperature_2m_max'];
      List<dynamic> minTemps = dailyJson['temperature_2m_min'];

      for (int i = 0; i < times.length; i++) {
        dailyForecasts.add(DailyForecast(
          date: DateTime.parse(times[i]),
          weatherCode: weatherCodes[i],
          maxTemp: (maxTemps[i] as num).toDouble(),
          minTemp: (minTemps[i] as num).toDouble(),
        ));
      }
    }

    return WeatherData(
      cityName: cityName,
      current: CurrentWeather(
        temperature: (currentJson['temperature_2m'] as num).toDouble(),
        humidity: currentJson['relative_humidity_2m'] as int,
        apparentTemperature: (currentJson['apparent_temperature'] as num).toDouble(),
        isDay: currentJson['is_day'] == 1,
        weatherCode: currentJson['weather_code'] as int,
        windSpeed: (currentJson['wind_speed_10m'] as num).toDouble(),
      ),
      daily: dailyForecasts,
    );
  }
}

class CurrentWeather {
  final double temperature;
  final int humidity;
  final double apparentTemperature;
  final bool isDay;
  final int weatherCode;
  final double windSpeed;

  CurrentWeather({
    required this.temperature,
    required this.humidity,
    required this.apparentTemperature,
    required this.isDay,
    required this.weatherCode,
    required this.windSpeed,
  });
}

class DailyForecast {
  final DateTime date;
  final int weatherCode;
  final double maxTemp;
  final double minTemp;

  DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.maxTemp,
    required this.minTemp,
  });
}

// Utility to convert WMO weather codes to text/icons
class WeatherUtils {
  static String getWeatherDescription(int code) {
    if (code == 0) return 'Clear Sky';
    if (code == 1 || code == 2 || code == 3) return 'Partly Cloudy';
    if (code == 45 || code == 48) return 'Foggy';
    if (code >= 51 && code <= 55) return 'Drizzle';
    if (code >= 61 && code <= 65) return 'Rain';
    if (code >= 71 && code <= 75) return 'Snow';
    if (code >= 80 && code <= 82) return 'Rain Showers';
    if (code >= 95) return 'Thunderstorm';
    return 'Unknown';
  }
}
