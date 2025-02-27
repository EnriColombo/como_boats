import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle, Uint8List;
import '../models/boat.dart';
import '../services/boat_service.dart';
import '../widgets/boat_detail_card.dart';
import '../widgets/custom_marker.dart';
import '../widgets/nav_item.dart';
import 'boat_detail_page.dart';

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
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();
  final ValueNotifier<bool> _fabVisible = ValueNotifier<bool>(true);
  ScrollController _listScrollController = ScrollController();
  // DraggableScrollableSheet percentage heights
  final double _minSheetSize = 0.08;
  final double _maxSheetSize = 1.0;
  double _currentSheetSize = 1.0;
  // Soglia per mostrare la barra di navigazione
  final double _navBarThreshold = 0.2;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _fetchBoats();
    _draggableController.addListener(() {
      _fabVisible.value = _draggableController.size > 0.1;
      // Aggiorna lo stato per far ricalcolare l'offset della nav bar
      setState(() {
        _currentSheetSize = _draggableController.size;
      });
    });
  }

  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map_style.json');
    setState(() {});
  }

  Future<void> _fetchBoats() async {
    try {
      _boats = await BoatService.fetchBoats();
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
    final markersList = await Future.wait(_boats.map((boat) async {
      final String name = boat.name;
      final String price = "€${boat.price}/ora";
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
      );
    }));
    _markers = markersList.toSet();
    setState(() {});
  }

  @override
  void dispose() {
    _draggableController.dispose();
    _fabVisible.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fa sì che la bottomNavigationBar sia sopra il contenuto,
      // ovvero quando nascosta non riserva spazio
      extendBody: true,
      appBar: AppBar(
        title: const Text('Boat Tours Lago di Como'),
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            style: _mapStyle,
            initialCameraPosition: const CameraPosition(
              target: LatLng(45.98661616223449, 9.257043874433045),
              zoom: 14,
            ),
            markers: _markers,
            onTap: (latLng) {
              setState(() {
                _selectedBoat = null;
                _draggableController.animateTo(
                  _minSheetSize,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              });
            },
          ),
          // Boat detail card (when a boat is selected)
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
                      builder: (context) =>
                          BoatDetailPage.fromBoat(boat: _selectedBoat!),
                    ),
                  );
                },
                onClose: () {
                  setState(() => _selectedBoat = null);
                },
              ),
            ),
          // Draggable panel showing list of boats
          DraggableScrollableSheet(
            initialChildSize: _maxSheetSize,
            minChildSize: _minSheetSize,
            maxChildSize: _maxSheetSize,
            controller: _draggableController,
            builder: (context, scrollController) {
              _listScrollController = scrollController;
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: _currentSheetSize == 1.0
                      ? BorderRadius.zero
                      : const BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                ),
                child: Column(
                  children: [
                    // Tap sulla barra di trascinamento per l'apertura immediata del pannello
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _draggableController.animateTo(
                            0.8,
                            duration: const Duration(milliseconds: 500),
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
                          // # Boats available
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${_boats.length} barche disponibili',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Boats list
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
                                        BoatDetailPage.fromBoat(boat: boat),
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
      // Floating Action Button to reset the map view
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _fabVisible,
        builder: (context, isVisible, child) {
          return isVisible
              ? FloatingActionButton(
                  child: const Icon(Icons.map),
                  onPressed: () {
                    setState(() {
                      _selectedBoat = null;
                      _draggableController.animateTo(
                        _minSheetSize,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                      _listScrollController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                )
              : const SizedBox.shrink();
        },
      ),
      // Barra di navigazione inferiore animata
      bottomNavigationBar: AnimatedSlide(
        offset: _currentSheetSize > _navBarThreshold
            ? const Offset(0, 0) // Navbar visible
            : const Offset(0, 1), // Navbar hidden
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(icon: Icons.search, label: 'Esplora', active: true),
              NavItem(icon: Icons.favorite, label: 'Preferiti'),
              NavItem(icon: Icons.directions_boat, label: 'Prenotazioni'),
              NavItem(icon: Icons.person, label: 'Accedi'),
            ],
          ),
        ),
      ),
    );
  }
}