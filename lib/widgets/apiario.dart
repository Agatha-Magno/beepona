import 'package:flutter/material.dart';

class Apiario extends StatelessWidget {
  final int number;
  final String nome;
  final double latitude;
  final double longitude;
  final int colmeias; // Add this
  final VoidCallback onDelete;

  const Apiario({
    super.key,
    required this.number,
    required this.nome,
    required this.latitude,
    required this.longitude,
    required this.colmeias,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE49A),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/Apiary_Icon.png',
                    height: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    nome.isNotEmpty ? nome : 'Apiario #$number',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Colmeias: $colmeias', // Show number of hives
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Latitude: ${latitude.toStringAsFixed(5)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Longitude: ${longitude.toStringAsFixed(5)}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: IconButton(
            icon: Image.asset(
              'assets/Delete_Icon.png',
              height: 28,
            ),
            onPressed: onDelete,
            tooltip: 'Excluir',
          ),
        ),
      ],
    );
  }
}
