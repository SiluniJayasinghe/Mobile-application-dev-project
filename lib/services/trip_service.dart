import 'package:flutter/foundation.dart';
import '../models/place.dart';
import '../models/trip.dart';
import '../models/trip_preferences.dart';
import '../models/recommendation_engine.dart';
import '../models/budget_planner.dart';
import 'place_repository.dart';

class TripService with ChangeNotifier {
  final PlaceRepository placeRepo;
  late RecommendationEngine engine;
  final BudgetPlanner planner;

  Trip? currentTrip;
  TripPreferences? currentPreferences;
  List<Place> itinerary = [];

  TripService({PlaceRepository? placeRepository})
      : placeRepo = placeRepository ?? PlaceRepository(),
        planner = BudgetPlanner('planner1') {
    engine = RecommendationEngine('engine1', catalog: placeRepo.all());
  }

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

  void setPreferences(TripPreferences prefs) {
    currentPreferences = prefs;
    notifyListeners();
  }

  bool preferencesValid() {
    if (currentPreferences == null) return false;
    return (currentPreferences!.culturePercentage +
            currentPreferences!.beachPercentage +
            currentPreferences!.safariPercentage) ==
        100;
  }

  void generateItinerary() {
  if (currentPreferences == null || currentTrip == null) {
    throw StateError('Trip or preferences not set.');
  }

  currentPreferences!.ensureValid();

  itinerary = engine.generateItineraryByBudget(
    currentPreferences!,
    currentTrip!.totalBudget,
  );

  notifyListeners();
}


  double estimatedCost() {
  return itinerary.fold(0.0, (sum, p) => sum + p.cost);
}

}
