import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lanka_explorer/presentation/screens/home/home%20_screen.dart';
import 'package:provider/provider.dart';
import 'package:lanka_explorer/services/trip_service.dart';
import 'package:lanka_explorer/models/place.dart';
import 'package:lanka_explorer/models/trip.dart';
import 'package:lanka_explorer/models/trip_preferences.dart';
import 'package:lanka_explorer/services/place_repository.dart';
import 'package:lanka_explorer/models/recommendation_engine.dart'; 
import 'package:lanka_explorer/models/budget_planner.dart';

// Complete Mock version of TripService
class MockTripService extends ChangeNotifier implements TripService {
  @override
  final PlaceRepository placeRepo = MockPlaceRepository();
  
  @override
  late RecommendationEngine engine = MockRecommendationEngine();
  
  @override
  final BudgetPlanner planner = MockBudgetPlanner();
  
  @override
  Trip? currentTrip;
  
  @override
  TripPreferences? currentPreferences;
  
  @override
  List<Place> itinerary = [];
  
  @override
  void createTrip({
    required String tripId,
    required DateTime startDate,
    required DateTime endDate,
    required double totalBudget,
  }) {
    currentTrip = Trip(tripId, startDate, endDate, totalBudget);
    itinerary = [];
    notifyListeners();
  }
  
  @override
  void setPreferences(TripPreferences prefs) {
    currentPreferences = prefs;
    notifyListeners();
  }
  
  @override
  bool preferencesValid() {
    if (currentPreferences == null) return false;
    return (currentPreferences!.culturePercentage +
            currentPreferences!.beachPercentage +
            currentPreferences!.safariPercentage) ==
        100;
  }
  
  @override
  void generateItinerary({int maxPlaces = 5}) {
    // Mock itinerary generation
    itinerary = List.generate(maxPlaces, (index) => Place(
      'place$index', 
      'Mock Place $index', 
      'Description $index', 
      'Type $index', 
      'Location $index', 
      10.0 * (index + 1)
    ));
    notifyListeners();
  }
  
  @override
  double estimatedCost() {
    final placesCost = itinerary.fold<double>(0.0, (s, p) => s + p.cost);
    final hotelEst = (currentTrip?.totalBudget ?? 0.0) * 0.4;
    return placesCost + hotelEst;
  }
}

// Mock classes for dependencies
class MockPlaceRepository implements PlaceRepository {
  @override
  List<Place> all() => [];
}

class MockRecommendationEngine extends RecommendationEngine {
  MockRecommendationEngine() : super('mock_engine', catalog: []);

  @override
  List<Place> filterByPreferences(TripPreferences prefs) {
    // return empty list for testing
    return [];
  }

  @override
  List<Place> filterByBudget(double budget) {
    // return empty list for testing
    return [];
  }
}

class MockBudgetPlanner extends BudgetPlanner {
  MockBudgetPlanner() : super('mock_planner');

  @override
  double calculateBudget() => 0.0;

  @override
  List<Place> suggestActivities() => [];
}

void main() {
  testWidgets('Lanka Explorer app loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<TripService>(
        create: (_) => MockTripService(),
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Lanka Explorer'), findsOneWidget);
  });
}


