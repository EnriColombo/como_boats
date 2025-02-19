class BoatImage {
  final int id;
  final int boatId;
  final String url;

  BoatImage({
    required this.id,
    required this.boatId,
    required this.url,
  });

  factory BoatImage.fromJson(Map<String, dynamic> json) {
    return BoatImage(
      id: json['id'],
      boatId: json['boat_id'],
      url: json['url'],
    );
  }
}