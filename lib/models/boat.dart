import 'company.dart';

class Boat {
  final int id;
  final String name;
  final String captain;
  final double price;
  final String description;
  final Company company;
  final List<String> images;
  final double lat;
  final double lng;

  Boat({
    required this.id,
    required this.name,
    required this.captain,
    required this.price,
    required this.description,
    required this.company,
    required this.images,
    required this.lat,
    required this.lng,
  });
}
