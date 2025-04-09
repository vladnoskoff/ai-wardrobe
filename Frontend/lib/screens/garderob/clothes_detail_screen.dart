import 'package:flutter/material.dart';
import '../../services/clothes.dart';

class ClothesDetailScreen extends StatelessWidget {
  final Clothes clothes;

  const ClothesDetailScreen({Key? key, required this.clothes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Гардеробус'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Добавить логику удаления
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                clothes.imageUrl ?? '',
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              clothes.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(Icons.thermostat, size: 32),
                    Text('${clothes.category}'),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.water_drop, size: 32),
                    Text('${clothes.season}'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
