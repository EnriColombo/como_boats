import 'package:flutter/material.dart';
import '../models/boat.dart';
import '../widgets/image_carousel.dart';

class BoatDetailPage extends StatelessWidget {
  final Boat boat;
  final String tourDescription;

  const BoatDetailPage.fromBoat({
    super.key,
    required this.boat,
  })  : tourDescription =
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
              child: ImageCarousel(images: boat.images),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome della barca
                  Text(
                    boat.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  // Descrizione della barca
                  Text(
                    boat.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16),
                  // Nome del comandante
                  Row(
                    children: [
                      Text('Capitano: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(boat.captain),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Nome della società con link
                  Row(
                    children: [
                      Text('Società: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () {
                          // TODO: Abilita il link per la società
                          // boat.company.webAddress;
                        },
                        child: Text(
                          boat.company.name,
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
                    'Prezzo: €${boat.price}/ora',
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
