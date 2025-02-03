import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

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
      home: BoatTourScreen(),
    );
  }
}

class BoatTourScreen extends StatefulWidget {
  const BoatTourScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BoatTourScreenState createState() => _BoatTourScreenState();
}

class _BoatTourScreenState extends State<BoatTourScreen> {

  final List<Map<String, dynamic>> boats = [
    {
      "id": 1,
      "nomebarca": "Perla del Lago",
      "foto":
          "https://taxiboatlierna.it/images/limo/venetian_limousine_principale.jpg",
      "comandante": "Enrico",
      "prezzoorario": 250.00,
      "geo": {"lat": 45.98661616223449, "lng": 9.257043874433045}
    },
    {
      "id": 2,
      "nomebarca": "Vento di Como",
      "foto":
          "https://taxiboatlierna.it/images/venice/classicvenice_principale.jpg",
      "comandante": "Marco",
      "prezzoorario": 200.00,
      "geo": {"lat": 45.991224, "lng": 9.257900}
    },
    {
      "id": 3,
      "nomebarca": "Onde Blu",
      "foto": "https://taxiboatlierna.it/images/flotta/como-dreamer.jpg",
      "comandante": "Alessandro",
      "prezzoorario": 180.00,
      "geo": {"lat": 45.984500, "lng": 9.250000}
    },
  ];

  bool showList = false;
  
  String? _mapStyle;

  Set<Marker> _createMarkers() {
    return boats
        .map((boat) => Marker(
              markerId: MarkerId(boat["id"].toString()),
              position: LatLng(boat["geo"]["lat"], boat["geo"]["lng"]),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
              infoWindow: InfoWindow(
                title: boat["nomebarca"],
                snippet: "€${boat["prezzoorario"]}/ora",
                onTap: () => _showBoatCard(boat),
              ),
            ))
        .toSet();
  }

  void _showBoatCard(Map<String, dynamic> boat) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              boat["nomebarca"],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Comandante: ${boat["comandante"]}"),
            Text("Prezzo orario: €${boat["prezzoorario"]}"),
            SizedBox(height: 16),
            Image.network(boat["foto"], height: 150, fit: BoxFit.cover),
          ],
        ),
      ),
    );
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
          GoogleMap(
            style: _mapStyle,
            initialCameraPosition: CameraPosition(
              target: LatLng(45.98661616223449, 9.257043874433045),
              zoom: 14,
            ),
            markers: _createMarkers(),
          ),
          if (showList)
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
                  itemCount: boats.length,
                  itemBuilder: (context, index) {
                    final boat = boats[index];
                    return ListTile(
                      leading: Image.network(
                        boat["foto"],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(boat["nomebarca"]),
                      subtitle: Text("€${boat["prezzoorario"]}/ora"),
                      onTap: () => _showBoatCard(boat),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(showList ? Icons.map : Icons.list),
        onPressed: () {
          setState(() {
            showList = !showList;
          });
        },
      ),
    );
  }
}
