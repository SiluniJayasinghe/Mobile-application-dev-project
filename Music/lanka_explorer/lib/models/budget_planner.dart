import 'place.dart';

class BudgetPlanner {
  String plannerId;

  BudgetPlanner(this.plannerId);

  double calculateBudget() => 1000.0;

  List<Place> suggestActivities() {
    return [Place("2", "Safari", "Wildlife safari", "Safari", "Yala", 200.0)];
  }
}
