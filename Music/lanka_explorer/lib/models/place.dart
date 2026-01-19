class Place {
  String placeId;
  String name;
  String description;
  String type;
  String location;
  double cost;
  
  // New fields
  String imagePath; // path to the image asset
  List<String> hotels; // nearby hotel names
  double rating; // optional: rating out of 5

  Place(
    this.placeId,
    this.name,
    this.description,
    this.type,
    this.location,
    this.cost, {
    this.imagePath = 'assets/images/placeholder.jpg',
    this.hotels = const [],
    this.rating = 0.0,
  });

  void addPlace() => print("Place $name added");
  void editPlace() => print("Place $name edited");
  void deletePlace() => print("Place $name deleted");
}

