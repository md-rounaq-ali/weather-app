class LocationModel {
  final String name;
  final String? admin1; // State or region
  final String country;
  final double latitude;
  final double longitude;

  LocationModel({
    required this.name,
    this.admin1,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] ?? 'Unknown',
      admin1: json['admin1'],
      country: json['country'] ?? 'Unknown',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  String get displayName {
    if (admin1 != null && admin1!.isNotEmpty) {
      return '$name, $admin1, $country';
    }
    return '$name, $country';
  }
}
