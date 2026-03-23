import 'package:flutter/material.dart';

class Colmeia extends StatelessWidget {
  final String nome;
  final String data;
  final double peso;
  final String produto;

  const Colmeia({
    super.key,
    required this.nome,
    required this.data,
    required this.peso,
    required this.produto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            nome,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text('Data: $data', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text('Peso: ${peso.toStringAsFixed(2)} kg',
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text('Produto: $produto', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
