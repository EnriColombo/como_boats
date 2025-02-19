import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/boat.dart';
import 'screens/boat_detail_page.dart';
import 'widgets/boat_detail_card.dart';
import 'widgets/custom_marker.dart';

const supabaseUrl = 'https://kkndlynlaffnwqdmvvim.supabase.co';
const supabaseKey = String.fromEnvironment('SUPABASE_KEY');

Future<void> main() async {
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Boat Tours Lago di Como',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      ),
      home: BoatMapScreen(),
    );
  }
}

class BoatMapScreen extends StatefulWidget {
  const BoatMapScreen({super.key});

  @override
  BoatMapScreenState createState() => BoatMapScreenState();
}

class BoatMapScreenState extends State<BoatMapScreen> {
  List<Boat> _boats = [];
  Boat? _selectedBoat;
  String? _mapStyle;
  Set<Marker> _markers = {};
  final DraggableScrollableController _draggableScrollableController =
      DraggableScrollableController();
  final ValueNotifier<bool> _fabVisible = ValueNotifier<bool>(true);
  ScrollController _listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _loadBoatsFromSupabase();
    _draggableScrollableController.addListener(() {
      if (_draggableScrollableController.size > 0.1) {
        _fabVisible.value = true;
      } else {
        _fabVisible.value = false;
      }
    });
  }

  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map_style.json');
    setState(() {});
  }

  Future<void> _loadBoatsFromSupabase() async {
    try {
      final boatsData = await Supabase.instance.client
          .from('boats')
          .select('*, companies(*), boat_images(*)');
      setState(() {
        _boats = (boatsData as List)
            .map((boatData) => Boat.fromJson(boatData))
            .toList();
      });
      _createMarkers();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Errore durante il caricamento delle barche: $error'),
            duration: const Duration(seconds: 20),
            showCloseIcon: true,
        ),
      );
    }
  }

  Future<void> _createMarkers() async {
    _markers = (await Future.wait(_boats.map((boat) async {
      String name = boat.name;
      String price = "€${boat.price}/ora";
      final Uint8List? markerIcon =
          await CustomMarker.createCustomMarkerBitmap(name, price);
      final BitmapDescriptor bitmapDescriptor =
          BitmapDescriptor.bytes(markerIcon!);

      return Marker(
        markerId: MarkerId(boat.id.toString()),
        position: LatLng(boat.lat, boat.lng),
        icon: bitmapDescriptor,
        onTap: () {
          setState(() => _selectedBoat = boat);
        },
        // infoWindow: InfoWindow(
        //   title: name,
        //   snippet: price,
        //   onTap: () {
        //     setState(() => _selectedBoat = boat);
        //   },
        // ),
      );
    }).toList()))
        .toSet();

    setState(() {});
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    _fabVisible.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Inizializza la grandezza iniziale del pannello draggable
    var initialChildSize = 0.08;
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
            markers: _markers,
            onTap: (LatLng latLng) {
              setState(() {
                _selectedBoat = null;
                _draggableScrollableController.animateTo(
                  initialChildSize,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              });
            },
          ),
          // Mostra la card quando una barca è selezionata
          if (_selectedBoat != null)
            Positioned(
              bottom: 60,
              left: 16,
              right: 16,
              child: BoatDetailCard.fromBoat(
                _selectedBoat!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BoatDetailPage.fromBoat(
                        boat: _selectedBoat!,
                      ),
                    ),
                  );
                },
                onClose: () {
                  setState(() => _selectedBoat = null);
                },
              ),
            ),
          // Pannello draggable della lista delle barche
          DraggableScrollableSheet(
            initialChildSize: 1.0,
            minChildSize: initialChildSize,
            maxChildSize: 1.0,
            controller: _draggableScrollableController,
            builder: (BuildContext context, ScrollController scrollController) {
              _listScrollController = scrollController;
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                ),
                child: Column(
                  children: [
                    // Tap sulla barra di trascinamento per l'apertura immediata del pannello
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _draggableScrollableController.animateTo(
                            0.8,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        });
                      },
                      child: Column(
                        children: [
                          // Handle bar
                          Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          // Numero di barche disponibili
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${_boats.length} barche disponibili',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Lista delle barche
                    Expanded(
                      child: ListView.builder(
                        controller: _listScrollController,
                        itemCount: _boats.length,
                        itemBuilder: (context, index) {
                          final boat = _boats[index];
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: BoatDetailCard.fromBoat(
                              boat,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BoatDetailPage.fromBoat(
                                      boat: boat,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      // Floating Action Button per tornare alla mappa
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _fabVisible,
        builder: (context, isVisible, child) {
          return isVisible
              ? FloatingActionButton(
                  child: Icon(Icons.map),
                  onPressed: () {
                    setState(() {
                      _selectedBoat = null;
                      _draggableScrollableController.animateTo(
                        initialChildSize,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                      _listScrollController.animateTo(
                        0.0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                )
              : SizedBox.shrink();
        },
      ),
    );
  }
}
