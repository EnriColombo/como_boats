import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'widgets/boat_detail_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Boat Tours Lago di Como',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BoatMapScreen(),
    );
  }
}

class BoatMapScreen extends StatefulWidget {
  const BoatMapScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BoatMapScreenState createState() => _BoatMapScreenState();
}

class _BoatMapScreenState extends State<BoatMapScreen> {
  Map<String, dynamic>? _selectedBoat;

  final List<Map<String, dynamic>> _boats = [
    {
      "id": 1,
      "name": "Perla del Lago",
      "captain": "Enrico",
      "price": 250.00,
      "images": [
        "https://taxiboatlierna.it/images/limo/venetian_limousine_principale.jpg",
        "https://taxiboatlierna.it/images/limo/venetian_limousine_principale.jpg",
      ],
      "geo": {"lat": 45.98661616223449, "lng": 9.257043874433045}
    },
    {
      "id": 2,
      "name": "Vento di Como",
      "captain": "Marco",
      "price": 200.00,
      "images": [
        "https://taxiboatlierna.it/images/venice/classicvenice_principale.jpg",
        "https://taxiboatlierna.it/images/venice/classicvenice_principale.jpg",
      ],
      "geo": {"lat": 45.991224, "lng": 9.257900}
    },
    {
      "id": 3,
      "name": "Onde Blu",
      "captain": "Alessandro",
      "price": 180.00,
      "images": [
        "https://taxiboatlierna.it/images/flotta/como-dreamer.jpg",
        "https://taxiboatlierna.it/images/flotta/como-dreamer.jpg",
      ],
      "geo": {"lat": 45.984500, "lng": 9.250000}
    },
  ];

  bool _showList = false;

  String? _mapStyle;

  Set<Marker> _createMarkers() {
    return _boats
        .map((boat) => Marker(
              markerId: MarkerId(boat["id"].toString()),
              position: LatLng(boat["geo"]["lat"], boat["geo"]["lng"]),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure),
              infoWindow: InfoWindow(
                title: boat["name"],
                snippet: "€${boat["price"]}/ora",
                // onTap: () => _showBoatCard(boat),
                onTap: () {
                  setState(() => _selectedBoat = boat);
                },
              ),
            ))
        .toSet();
  }

  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map_style.json');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boat Tours Lago di Como'),
      ),
      body: Stack(
        children: [
          // Mappa di Google
          GoogleMap(
            style: _mapStyle,
            initialCameraPosition: CameraPosition(
              target: LatLng(45.98661616223449, 9.257043874433045),
              zoom: 14,
            ),
            markers: _createMarkers(),
          ),
          // Mostra la card quando una barca è selezionata
          if (_selectedBoat != null)
            BoatDetailCard(
              name: _selectedBoat!["name"],
              captain: _selectedBoat!["captain"],
              price: _selectedBoat!["price"],
              images: List<String>.from(_selectedBoat!["images"]),
              onClose: () {
                setState(() => _selectedBoat = null);
              },
            ),
          if (_showList)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                ),
                child: ListView.builder(
                  itemCount: _boats.length,
                  itemBuilder: (context, index) {
                    final boat = _boats[index];
                    return BoatDetailCard(
                      name: boat["name"],
                      captain: boat["captain"],
                      price: boat["price"],
                      images: List<String>.from(boat["images"]),
                      onClose: () {},
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(_showList ? Icons.map : Icons.list),
        onPressed: () {
          setState(() {
            _showList = !_showList;
          });
        },
      ),
    );
  }
}
