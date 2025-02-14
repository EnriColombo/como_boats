class Boat {
  final int id;
  final String name;
  final String captain;
  final double price;
  final String description;
  final String company;
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

  // Factory constructor to create a Boat instance from a Map
  factory Boat.fromMap(Map<String, dynamic> map) {
    return Boat(
      id: map['id'],
      name: map['name'],
      captain: map['captain'],
      price: map['price'],
      images: List<String>.from(map['images']),
      lat: map['geo']['lat'],
      lng: map['geo']['lng'],
      description: map['description'],
      company: map['company'],
    );
  }

  // Method to convert Boat instance to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'captain': captain,
      'price': price,
      'images': images,
      'geo': {'lat': lat, 'lng': lng},    
      'description': description,
      'company': company,
      };
  }
}
