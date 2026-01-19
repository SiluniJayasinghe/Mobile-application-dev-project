import 'place.dart';
import 'trip_preferences.dart';
import 'recommendation_engine.dart';
import 'budget_planner.dart';
import 'user.dart';

class Trip {
  String tripId;
  DateTime startDate;
  DateTime endDate;
  double totalBudget;

  User? owner;
  TripPreferences? preferences;
  List<Place> itinerary = [];
  RecommendationEngine? engine;
  BudgetPlanner? planner;

  Trip(this.tripId, this.startDate, this.endDate, this.totalBudget, {this.owner, this.engine, this.planner});

  List<Place> generateItinerary() {
  if (preferences == null) throw StateError("Preferences not set.");
  if (engine == null) throw StateError("Engine not set.");

  itinerary = engine!.generateItineraryByBudget(
    preferences!,
    totalBudget,
  );

  return itinerary;
}


  double calculateCost() {
  return itinerary.fold(0.0, (s, p) => s + p.cost);
}

}
