import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lanka_explorer/presentation/screens/home/home%20_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/trip_service.dart';
import 'services/place_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}


