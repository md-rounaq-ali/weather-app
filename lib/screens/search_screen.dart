import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../services/weather_api.dart';
import '../models/location_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final WeatherApi _weatherApi = WeatherApi();
  
  Timer? _debounce;
  List<LocationModel> _suggestions = [];
  bool _isLoading = false;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    if (query.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final results = await _weatherApi.searchCities(query);
      if (mounted) {
        setState(() {
          _suggestions = results;
          _isLoading = false;
        });
      }
    });
  }

  void _selectCity(LocationModel location) {
    context.read<WeatherProvider>().fetchWeatherByLocation(location);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Search City'),
      ),
      body: Container(
        height: double.infinity,
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(fontSize: 18),
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Start typing a city name...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 24),
                
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_suggestions.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final location = _suggestions[index];
                        return Card(
                          color: Colors.white.withOpacity(0.05),
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.location_city, color: Colors.white70),
                            title: Text(
                              location.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              location.displayName,
                              style: TextStyle(color: Colors.white.withOpacity(0.6)),
                            ),
                            onTap: () => _selectCity(location),
                          ),
                        );
                      },
                    ),
                  )
                else if (_searchController.text.isEmpty)
                  _buildPopularCities()
                else
                  const Center(
                    child: Text('No cities found. Try another spelling.', 
                      style: TextStyle(color: Colors.white70, fontSize: 16)
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopularCities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Cities',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildCityChip('New York', 40.71427, -74.00597),
            _buildCityChip('London', 51.50853, -0.12574),
            _buildCityChip('Tokyo', 35.6895, 139.69171),
            _buildCityChip('Paris', 48.85341, 2.3488),
            _buildCityChip('Sydney', -33.86785, 151.20732),
          ],
        ),
      ],
    );
  }

  Widget _buildCityChip(String name, double lat, double lon) {
    return ActionChip(
      label: Text(name),
      backgroundColor: Colors.white.withOpacity(0.1),
      side: BorderSide(color: Colors.white.withOpacity(0.2)),
      onPressed: () {
        _selectCity(LocationModel(
          name: name,
          country: '',
          latitude: lat,
          longitude: lon,
        ));
      },
    );
  }
}
