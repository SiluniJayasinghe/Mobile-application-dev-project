import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lanka_explorer/services/trip_service.dart';
import 'package:lanka_explorer/models/trip_preferences.dart';
import 'package:lanka_explorer/models/place.dart';

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  final _cultureCtrl = TextEditingController(text: '40');
  final _beachCtrl = TextEditingController(text: '40');
  final _safariCtrl = TextEditingController(text: '20');
  final _natureCtrl = TextEditingController(text: '20');
  final _budgetCtrl = TextEditingController(text: '800');

  void _generate() {
    final svc = Provider.of<TripService>(context, listen: false);

    final culture = int.tryParse(_cultureCtrl.text) ?? 0;
    final beach = int.tryParse(_beachCtrl.text) ?? 0;
    final safari = int.tryParse(_safariCtrl.text) ?? 0;
    final nature = int.tryParse(_natureCtrl.text) ?? 0;
    final budget = double.tryParse(_budgetCtrl.text) ?? 0.0;

    if ((culture + beach + safari + nature) != 100) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Preferences must sum to 100%')),
  );
  return;
}

    svc.createTrip(
      tripId: 't1',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 5)),
      totalBudget: budget,
    );
    svc.setPreferences(
  TripPreferences('pref1', culture, beach, safari, nature),
);
    svc.generateItinerary();
  }

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<TripService>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Plan Your Trip',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cover photo
            ClipRRect(
              child: Image.asset(
                'assets/images/sri_lanka1.jpg', // Your cover image
                height: 500,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Input fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cultureCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Culture %',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _beachCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Beach %',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _safariCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Safari %',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _natureCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nature %',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _budgetCtrl,
              decoration: const InputDecoration(
                labelText: 'Total Budget',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.travel_explore),
              label: const Text('Generate Itinerary'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),

            // Trip Itinerary Cards
            svc.itinerary.isEmpty
                ? const Center(child: Text('No itinerary yet'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: svc.itinerary.length,
                    itemBuilder: (_, index) {
                      final Place p = svc.itinerary[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              p.imagePath,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            p.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${p.type} • ${p.location}'),
                              Text(
                                'Estimated Cost: \$${p.cost.toStringAsFixed(0)}',
                                style: const TextStyle(color: Colors.teal),
                              ),
                              Text('Hotels: ${p.hotels.join(", ")}'),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                                onPressed: () {
                                  // TODO: Implement edit functionality
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  // Simple delete
                                  setState(() {
                                    svc.itinerary.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

            const SizedBox(height: 16),
            Text(
              'Total Estimated Cost: \$${svc.estimatedCost().toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
