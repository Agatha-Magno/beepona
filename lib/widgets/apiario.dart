import 'package:flutter/material.dart';

class Apiario extends StatelessWidget {
  final String id;
  final String nome;
  final double latitude;
  final double longitude;
  final int colmeias;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const Apiario({
    super.key,
    required this.id,
    required this.nome,
    required this.latitude,
    required this.longitude,
    required this.colmeias,
    required this.onDelete,
    required this.onEdit,
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
            boxShadow: const [
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
                  Expanded(
                    child: Text(
                      nome.isNotEmpty ? nome : 'Apiário',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
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
          top: 24,
          right: 24,
          child: IconButton(
            icon: Image.asset(
              'assets/Edit_Icon.png',
              height: 24,
            ),
            onPressed: onEdit,
            tooltip: 'Editar',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: IconButton(
            icon: Image.asset(
              'assets/Delete_Icon.png',
              height: 28,
            ),
            onPressed: onDelete,
            tooltip: 'Excluir',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }
}
