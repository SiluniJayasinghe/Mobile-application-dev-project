import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lanka_explorer/services/trip_service.dart';
import 'package:lanka_explorer/models/place.dart';

class ExplorePlacesScreen extends StatelessWidget {
  final String category;

  const ExplorePlacesScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<TripService>();

    // Filter places by category
    List<Place> filtered = svc.placeRepo.all()
        .where((p) => p.type.toLowerCase() == category.toLowerCase())
        .toList();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.teal,title: Text(category)),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: filtered.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemBuilder: (_, index) {
            final place = filtered[index];
            return PlaceCard(place: place);
          },
        ),
      ),
    );
  }
}

class PlaceCard extends StatelessWidget {
  final Place place;

  const PlaceCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                place.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          /// CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  Text(
                    place.type,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  Text(
                    place.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star,
                              size: 14, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            place.rating.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Text(
                        '\$${place.cost.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
