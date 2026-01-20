import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:lanka_explorer/services/trip_service.dart';
import 'package:lanka_explorer/models/trip_preferences.dart';
import 'package:lanka_explorer/models/place.dart';

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  final _cultureCtrl = TextEditingController(text: '30');
  final _beachCtrl = TextEditingController(text: '30');
  final _safariCtrl = TextEditingController(text: '20');
  final _natureCtrl = TextEditingController(text: '20');
  final _budgetCtrl = TextEditingController(text: '800');

  @override
  void dispose() {
    _cultureCtrl.dispose();
    _beachCtrl.dispose();
    _safariCtrl.dispose();
    _natureCtrl.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  void _generate() {
    final svc = context.read<TripService>();

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

  Future<void> _addToMyTrip(Place place) async {
    final firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('trip_places').add({
        'name': place.name,
        'category': place.type,
        'description': place.description ?? '',
        'location': place.location,
        'hotels': place.hotels,
        'cost': place.cost,
        'imageUrl': place.imagePath,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${place.name} added to My Trip')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add place: $e')),
      );
    }
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
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/sri_lanka1.jpg',
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                _percentField(_cultureCtrl, 'Culture %'),
                _percentField(_beachCtrl, 'Beach %'),
                _percentField(_safariCtrl, 'Safari %'),
                _percentField(_natureCtrl, 'Nature %'),
              ],
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _budgetCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Budget',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.travel_explore),
              label: const Text('Generate Itinerary'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: Colors.teal,
              ),
            ),
            const SizedBox(height: 20),

            /// 🔹 ITINERARY LIST WITH ADD BUTTON
            svc.itinerary.isEmpty
                ? const Text('No itinerary yet')
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
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.add, color: Colors.black),
                            onPressed: () => _addToMyTrip(p),
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

  Widget _percentField(TextEditingController ctrl, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}

