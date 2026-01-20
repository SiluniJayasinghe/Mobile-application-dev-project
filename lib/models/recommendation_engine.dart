import 'place.dart';
import 'trip_preferences.dart';

class RecommendationEngine {
  String engineId;
  List<Place> catalog;

  RecommendationEngine(this.engineId, {List<Place>? catalog})
      : catalog = catalog ?? [];

  List<Place> generateItineraryByBudget(
    TripPreferences prefs,
    double totalBudget,
  ) {
    prefs.ensureValid();

    final Map<String, double> categoryBudgets = {
      'Culture': totalBudget * prefs.culturePercentage / 100,
      'Beach': totalBudget * prefs.beachPercentage / 100,
      'Safari': totalBudget * prefs.safariPercentage / 100,
      'Nature': totalBudget * prefs.naturePercentage / 100,
    };

    final List<Place> result = [];

    categoryBudgets.forEach((type, budget) {
      final places = catalog
          .where((p) => p.type == type)
          .toList()
        ..sort((a, b) => a.cost.compareTo(b.cost));

      double spent = 0;
      for (final place in places) {
        if (spent + place.cost <= budget) {
          result.add(place);
          spent += place.cost;
        }
      }
    });

    return result;
  }
}
