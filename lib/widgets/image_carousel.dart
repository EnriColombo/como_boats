import 'package:flutter/material.dart';
import '../models/boat_image.dart';

class ImageCarousel extends StatefulWidget {
  final List<BoatImage> images;

  const ImageCarousel({super.key, required this.images});

  @override
  ImageCarouselState createState() => ImageCarouselState();
}

class ImageCarouselState extends State<ImageCarousel> {
  int _currentPage = 0;
  final PageController _controller = PageController();

  void _openFullScreen(int initialPage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenCarousel(
          images: widget.images,
          initialPage: initialPage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.images.length,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _openFullScreen(index),
              child: Image.network(
                widget.images[index].url,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          },
        ),
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 12 : 8,
                height: _currentPage == index ? 12 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.white : Colors.white54,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class FullScreenCarousel extends StatefulWidget {
  final List<BoatImage> images;
  final int initialPage;

  const FullScreenCarousel({
    super.key,
    required this.images,
    this.initialPage = 0,
  });

  @override
  FullScreenCarouselState createState() => FullScreenCarouselState();
}

class FullScreenCarouselState extends State<FullScreenCarousel> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Schermo intero con sfondo nero
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return Center(
            child: Image.network(
              widget.images[index].url,
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}