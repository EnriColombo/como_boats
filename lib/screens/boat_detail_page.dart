import 'package:flutter/material.dart';
import '../models/boat.dart';
import '../widgets/image_carousel.dart';

class BoatDetailPage extends StatelessWidget {
  final String name;
  final String captain;
  final double price;
  final List<String> images;

  // Altri dati inventati
  final String description;
  final String company;
  final String tourDescription;

  const BoatDetailPage({
    super.key,
    required this.name,
    required this.captain,
    required this.price,
    required this.images,
    this.description =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur consequat in mi in tempus.',
    this.company = 'Como Boats Inc.',
    this.tourDescription =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse potenti. Nulla facilisi.',
  });

  BoatDetailPage.fromBoat({
    super.key,
    required Boat boat,
  })  : name = boat.name,
        captain = boat.captain,
        price = boat.price,
        images = boat.images,
        description = boat.description,
        company = boat.company,
        tourDescription = 
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse potenti. Nulla facilisi.';
        
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Estende il corpo sotto l’AppBar per una foto a tutta larghezza
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: Icon(Icons.share), onPressed: () {}),
          IconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carosello delle foto
            SizedBox(
              height: 300,
              child: ImageCarousel(images: images),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome della barca
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  // Descrizione della barca
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16),
                  // Nome del comandante
                  Row(
                    children: [
                      Text('Capitano: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(captain),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Nome della società con fake link
                  Row(
                    children: [
                      Text('Società: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () {
                          // Abilita il link false
                        },
                        child: Text(
                          company,
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Descrizione del tour
                  Text(
                    'Tour',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    tourDescription,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16),
                  // Prezzo
                  Text(
                    'Prezzo: €$price/ora',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 32),
                  // Pulsanti Contatta e Prenota
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Contatta'),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Prenota'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
