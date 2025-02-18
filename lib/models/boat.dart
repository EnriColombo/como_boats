import 'company.dart';
import 'boat_image.dart';

class Boat {
  final int id;
  final String name;
  final String captain;
  final double price;
  final String description;
  final Company company;
  final List<BoatImage> images;
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

  factory Boat.fromJson(Map<String, dynamic> json) {
    final companyJson = json['companies'];
    final imagesJson = json['boat_images'] as List<dynamic>? ?? [];
    return Boat(
      id: json['id'],
      name: json['name'],
      captain: json['captain'],
      price: double.parse(json['price'].toString()),
      description: json['description'],
      company: Company(
        id: companyJson['id'],
        name: companyJson['name'],
        webAddress: companyJson['web_address'],
      ),
      images: imagesJson.map((img) => BoatImage.fromJson(img)).toList(),
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }
}
