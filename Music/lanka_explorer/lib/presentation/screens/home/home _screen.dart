import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'trip_planner_screen.dart';
import '../explore_places/explore_places_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 500,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Lanka Explorer'),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/sri_lanka.jpg',
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Explore Sri Lanka 🇱🇰',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  CategoryCard(
                    title: 'Beaches',
                    icon: Icons.beach_access,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExplorePlacesScreen(category: 'Beach'),
                        ),
                      );
                    },
                  ),
                  CategoryCard(
                    title: 'Culture',
                    icon: Icons.account_balance,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExplorePlacesScreen(category: 'Culture'),
                        ),
                      );
                    },
                  ),
                  CategoryCard(
                    title: 'Safari',
                    icon: Icons.pets,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExplorePlacesScreen(category: 'Safari'),
                        ),
                      );
                    },
                  ),
                  CategoryCard(
                    title: 'Nature',
                    icon: Icons.park, // change icon to a tree/park icon
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExplorePlacesScreen(category: 'Nature'),
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // This code navigates to the new page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TripPlannerScreen()),
          );
        },
        label: const Text('Plan Trip'),
        icon: const Icon(Icons.travel_explore),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap; // New

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle tap
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2,2),
            )
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.teal),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
