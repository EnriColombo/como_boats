import 'package:flutter/material.dart';

import '../models/boat.dart';

class BoatDetailCard extends StatefulWidget {
  final String name;
  final String captain;
  final double price;
  final List<String> images;
  final VoidCallback? onClose; // parametro onClose opzionale
  final VoidCallback? onTap; // parametro onTap opzionale

  const BoatDetailCard({
    required this.name,
    required this.captain,
    required this.price,
    required this.images,
    this.onClose,
    this.onTap,
    super.key,
  });

  factory BoatDetailCard.fromBoat(Boat boat, {VoidCallback? onClose, VoidCallback? onTap}) {
    return BoatDetailCard(
      name: boat.name,
      captain: boat.captain,
      price: boat.price,
      images: boat.images,
      onClose: onClose,
      onTap: onTap,
    );
  }

  @override
  BoatDetailCardState createState() => BoatDetailCardState();
}

class BoatDetailCardState extends State<BoatDetailCard> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap, // cattura l'onTap su tutta la superficie
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Immagini con carosello
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: widget.images.length,
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                      },
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.network(
                            widget.images[index],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                    // Pulsanti Preferiti e Chiudi
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite_border,
                                color: Colors.white),
                            onPressed:
                                () {}, // TODO: Aggiungi logica per i preferiti
                          ),
                          if (widget.onClose != null)
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.white),
                              onPressed: widget.onClose,
                            ),
                        ],
                      ),
                    ),
                    // Indicatori delle pagine del carosello
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.images.length,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 10 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Dettagli della barca
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome della barca
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Nome del comandante
                    Text(
                      "Capitano: ${widget.captain}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),

                    SizedBox(height: 4),

                    // Prezzo orario
                    Text(
                      "€${widget.price.toStringAsFixed(2)} / ora",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
