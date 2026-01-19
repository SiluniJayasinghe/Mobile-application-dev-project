class TripPreferences {
  String preferenceId;
  int culturePercentage;
  int beachPercentage;
  int safariPercentage;
  int naturePercentage;

  TripPreferences(
    this.preferenceId,
    this.culturePercentage,
    this.beachPercentage,
    this.safariPercentage,
    this.naturePercentage,
  );

  bool isValid() =>
      culturePercentage +
          beachPercentage +
          safariPercentage +
          naturePercentage ==
      100;

  void ensureValid() {
    if (!isValid()) {
      throw StateError("Preferences must sum to 100%");
    }
  }
}


