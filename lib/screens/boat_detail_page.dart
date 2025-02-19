import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/boat.dart';
import '../widgets/image_carousel.dart';

class BoatDetailPage extends StatefulWidget {
  final Boat boat;
  final String tourDescription;

  const BoatDetailPage.fromBoat({
    super.key,
    required this.boat,
  }) : tourDescription =
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse potenti. Nulla facilisi.';

  @override
  State<BoatDetailPage> createState() => _BoatDetailPageState();
}

class _BoatDetailPageState extends State<BoatDetailPage> {
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
              child: ImageCarousel(images: widget.boat.images),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome della barca
                  Text(
                    widget.boat.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  // Descrizione della barca
                  Text(
                    widget.boat.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16),
                  // Nome del comandante
                  Row(
                    children: [
                      Text('Capitano: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(widget.boat.captain),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Nome della società con link
                  Row(
                    children: [
                      Text('Società: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      InkWell(
                        onTap: () async {
                          final Uri url =
                              Uri.parse(widget.boat.company.webAddress);
                          // Capture the ScaffoldMessenger before the async gap.
                          final scaffoldMessenger =
                              ScaffoldMessenger.of(context);
                          if (!await launchUrl(url,
                              mode: LaunchMode.externalApplication)) {
                            if (!mounted) return;
                            scaffoldMessenger.showSnackBar(
                              SnackBar(content: Text('Could not launch $url')),
                            );
                          }
                        },
                        child: Text(
                          widget.boat.company.name,
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
                    widget.tourDescription,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16),
                  // Prezzo
                  Text(
                    'Prezzo: €${widget.boat.price}/ora',
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
