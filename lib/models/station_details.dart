class StationDetails {
  final String code;
  final String name;
  final String imageUrl;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> nearbyAmenities;

  StationDetails({
    required this.code,
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.nearbyAmenities,
  });
}
