import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TripPlace {
  final String id;
  final String name;
  final String category;
  final String description;
  final String location;
  final String hotels;
  final double cost;
  final String imageUrl;

  TripPlace({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.location,
    required this.hotels,
    required this.cost,
    required this.imageUrl,
  });

  factory TripPlace.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TripPlace(
      id: doc.id,
      name: data['name'],
      category: data['category'],
      description: data['description'],
      location: data['location'],
      hotels: (data['hotels'] is List)
    ? (data['hotels'] as List).join(', ')
    : data['hotels'] ?? '',

      cost: (data['cost'] as num).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}

class MyTripScreen extends StatefulWidget {
  const MyTripScreen({super.key});

  @override
  State<MyTripScreen> createState() => _MyTripScreenState();
}

class _MyTripScreenState extends State<MyTripScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;              // Mobile/Desktop
  Uint8List? _webImageBytes;         // Web
  String? _editingId;

  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descController = TextEditingController();
  final _locController = TextEditingController();
  final _hotelController = TextEditingController();
  final _costController = TextEditingController();

  /// ---------------- IMAGE PICKER (WEB + MOBILE SAFE) ----------------
  Future<void> _pickImage(StateSetter setDialogState) async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (picked == null) return;

    if (kIsWeb) {
      final bytes = await picked.readAsBytes();
      setDialogState(() {
        _webImageBytes = bytes;
      });
    } else {
      setDialogState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  /// ---------------- IMAGE UPLOAD ----------------
  Future<String> _uploadImage() async {
    final ref = _storage
        .ref()
        .child('trip_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    if (kIsWeb && _webImageBytes != null) {
      await ref.putData(_webImageBytes!);
    } else if (_selectedImage != null) {
      await ref.putFile(_selectedImage!);
    }

    return await ref.getDownloadURL();
  }

  void _openDialog({TripPlace? place}) {
    if (place != null) {
      _editingId = place.id;
      _nameController.text = place.name;
      _categoryController.text = place.category;
      _descController.text = place.description;
      _locController.text = place.location;
      _hotelController.text = place.hotels;
      _costController.text = place.cost.toString();
    } else {
      _clear();
    }

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (_, setDialogState) => AlertDialog(
          title: Text(place == null ? 'Add Place' : 'Update Place'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => _pickImage(setDialogState),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _buildImagePreview(),
                  ),
                ),
                TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
                TextField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Category')),
                TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Description')),
                TextField(controller: _locController, decoration: const InputDecoration(labelText: 'Location')),
                TextField(controller: _hotelController, decoration: const InputDecoration(labelText: 'Hotels')),
                TextField(controller: _costController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Cost')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clear();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _savePlace,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- IMAGE PREVIEW (NO Image.file ON WEB) ----------------
  Widget _buildImagePreview() {
    if (kIsWeb && _webImageBytes != null) {
      return Image.memory(_webImageBytes!, fit: BoxFit.cover);
    } else if (!kIsWeb && _selectedImage != null) {
      return Image.file(_selectedImage!, fit: BoxFit.cover);
    } else {
      return const Center(child: Icon(Icons.add_a_photo, size: 40),);
    }
  }

  /// ---------------- SAVE PLACE ----------------
  Future<void> _savePlace() async {
    if (_nameController.text.trim().isEmpty) return;

    String imageUrl = '';
    if (_selectedImage != null || _webImageBytes != null) {
      imageUrl = await _uploadImage();
    }

    final data = {
      'name': _nameController.text.trim(),
      'category': _categoryController.text.trim(),
      'description': _descController.text.trim(),
      'location': _locController.text.trim(),
      'hotels': _hotelController.text.trim(),
      'cost': double.tryParse(_costController.text) ?? 0,
      'imageUrl': imageUrl,
    };

    if (_editingId == null) {
      await _firestore.collection('trip_places').add(data);
    } else {
      await _firestore.collection('trip_places').doc(_editingId).update(data);
    }

    _clear();
    Navigator.pop(context);
  }

  void _clear() {
    _editingId = null;
    _selectedImage = null;
    _webImageBytes = null;
    _nameController.clear();
    _categoryController.clear();
    _descController.clear();
    _locController.clear();
    _hotelController.clear();
    _costController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Trip Destinations')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('trip_places').snapshots(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final places =
              snapshot.data!.docs.map((e) => TripPlace.fromDoc(e)).toList();

          if (places.isEmpty) {
            return const Center(child: Text('No places added'));
          }

          return ListView.builder(
            itemCount: places.length,
            itemBuilder: (_, index) {
              final place = places[index];
              return Card(
                child: ListTile(
                  leading: place.imageUrl.isNotEmpty
                      ? Image.network(place.imageUrl, width: 50, fit: BoxFit.cover)
                      : const Icon(Icons.image),
                  title: Text(place.name),
                  subtitle: Text('${place.category} • \$${place.cost}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openDialog(place: place),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _firestore
                            .collection('trip_places')
                            .doc(place.id)
                            .delete(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

