import 'package:flutter/material.dart';
import 'package:lanka_explorer/presentation/screens/home/home%20_screen.dart';
import 'package:provider/provider.dart';
import 'services/trip_service.dart';
import 'services/place_repository.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TripService(placeRepository: PlaceRepository()),
      child: const LankaExplorerApp(),
    ),
  );
}

class LankaExplorerApp extends StatelessWidget {
  const LankaExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lanka Explorer',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        // This makes the design look more modern
        useMaterial3: true, 
      ),
      home: const HomeScreen(), 
    );
  }
}

