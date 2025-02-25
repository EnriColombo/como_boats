import 'package:como_boats/screens/boat_map_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Boat Tours Lago di Como',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      ),
      home: const BoatMapScreen(),
    );
  }
}