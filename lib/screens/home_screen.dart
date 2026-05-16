import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';
import '../providers/weather_provider.dart';
import '../models/weather_model.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Weather', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          )
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildLoadingState();
          }

          if (provider.errorMessage != null) {
            return _buildErrorState(provider);
          }

          final weather = provider.weatherData;
          if (weather == null) {
            return const Center(child: Text('No weather data available'));
          }

          return Stack(
            children: [
              // Background Gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1E293B),
                      Color(0xFF0F172A),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: RefreshIndicator(
                  onRefresh: () => provider.fetchWeatherByCityName(weather.cityName), // Fallback refresh
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCurrentWeather(weather),
                        const SizedBox(height: 32),
                        const Text(
                          '7-Day Forecast',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildForecastList(weather.daily),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              'https://lottie.host/801a610f-6ef1-4b15-992a-fb0cc4a38f3c/y3eZpXJ1Yx.json', // Generic loading cloud
              height: 150,
              errorBuilder: (context, error, stackTrace) => const CircularProgressIndicator(),
            ),
            const SizedBox(height: 16),
            const Text('Fetching weather...', style: TextStyle(color: Colors.white70, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(WeatherProvider provider) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 80, color: Colors.white54),
            const SizedBox(height: 16),
            Text(provider.errorMessage!, style: const TextStyle(fontSize: 18, color: Colors.white)),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                foregroundColor: Colors.white,
              ),
              onPressed: () => provider.fetchWeatherByCityName('London'),
              child: const Text('Try Again'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentWeather(WeatherData weather) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            children: [
              Text(
                weather.cityName,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('EEEE, MMM d').format(DateTime.now()),
                style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7)),
              ),
              const SizedBox(height: 16),
              _buildAnimatedWeatherIcon(weather.current.weatherCode, size: 150),
              Text(
                '${weather.current.temperature.round()}°',
                style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w200),
              ),
              Text(
                WeatherUtils.getWeatherDescription(weather.current.weatherCode),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWeatherDetail(Icons.water_drop_outlined, '${weather.current.humidity}%', 'Humidity'),
                  _buildWeatherDetail(Icons.air, '${weather.current.windSpeed} km/h', 'Wind'),
                  _buildWeatherDetail(Icons.thermostat_outlined, '${weather.current.apparentTemperature.round()}°', 'Feels Like'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.7)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
      ],
    );
  }

  Widget _buildForecastList(List<DailyForecast> daily) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: daily.length,
      itemBuilder: (context, index) {
        final day = daily[index];
        final isToday = index == 0;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isToday ? 0.1 : 0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(isToday ? 0.2 : 0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  isToday ? 'Today' : DateFormat('EEEE').format(day.date),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: _buildAnimatedWeatherIcon(day.weatherCode, size: 50),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${day.maxTemp.round()}°',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${day.minTemp.round()}°',
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedWeatherIcon(int code, {required double size}) {
    String lottieUrl = '';
    IconData fallbackIcon = Icons.cloud;

    if (code == 0) {
      // Sunny
      lottieUrl = 'https://lottie.host/801a610f-6ef1-4b15-992a-fb0cc4a38f3c/y3eZpXJ1Yx.json'; 
      fallbackIcon = Icons.wb_sunny;
    } else if (code == 1 || code == 2 || code == 3) {
      // Partly Cloudy
      lottieUrl = 'https://lottie.host/a2b0051a-463d-49d6-953b-eef6b5391d37/A51Jz41R7I.json';
      fallbackIcon = Icons.cloud_queue;
    } else if (code >= 51 && code <= 65) {
      // Rain
      lottieUrl = 'https://lottie.host/7dd95b95-a22c-4976-b3aa-e1cd39e4a3e7/9K3mP827A7.json';
      fallbackIcon = Icons.water_drop;
    } else if (code >= 71 && code <= 75) {
      // Snow
      lottieUrl = 'https://lottie.host/175960cc-6e69-42b7-84a2-39f88636a0fb/L2U8oR1d8w.json';
      fallbackIcon = Icons.ac_unit;
    } else if (code >= 95) {
      // Thunder
      lottieUrl = 'https://lottie.host/e616f9f3-8b43-4e42-a4f6-ef792db8a7de/XvXQ85X4Xy.json';
      fallbackIcon = Icons.flash_on;
    } else {
      // Default Cloud
      lottieUrl = 'https://lottie.host/a2b0051a-463d-49d6-953b-eef6b5391d37/A51Jz41R7I.json';
      fallbackIcon = Icons.cloud;
    }

    return Lottie.network(
      lottieUrl,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Icon(
        fallbackIcon,
        size: size * 0.8,
        color: Colors.white,
      ),
    );
  }
}
