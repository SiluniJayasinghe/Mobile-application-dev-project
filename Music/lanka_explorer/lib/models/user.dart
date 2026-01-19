import 'trip.dart';
import 'trip_preferences.dart';

class User {
  String userId;
  String username;
  String email;
  String password;
  List<Trip> trips = [];

  User(this.userId, this.username, this.email, this.password);

  bool login() => true;
  void logout() => print("User logged out");

  void setPreferences(TripPreferences preferences) {
    print("Preferences set for $username");
  }

  Trip createTrip({
    required String tripId,
    required DateTime startDate,
    required DateTime endDate,
    required double totalBudget,
  }) {
    final trip = Trip(tripId, startDate, endDate, totalBudget, owner: this);
    trips.add(trip);
    return trip;
  }
}
