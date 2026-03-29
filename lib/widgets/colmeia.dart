import 'package:flutter/material.dart';

class Colmeia extends StatelessWidget {
  final String id;
  final String nome;
  final double peso;
  final String produto;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const Colmeia({
    super.key,
    required this.id,
    required this.nome,
    required this.peso,
    required this.produto,
    this.onDelete,
    this.onEdit,
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
                    'assets/Swarm_Icon.png',
                    height: 28,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      nome.isNotEmpty ? nome : 'Colmeia',
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
                'Peso: ${peso.toStringAsFixed(2)} kg',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Produto: $produto',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        if (onEdit != null)
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
        if (onDelete != null)
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
