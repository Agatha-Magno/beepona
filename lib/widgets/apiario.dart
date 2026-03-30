import 'package:flutter/material.dart';

class Apiario extends StatelessWidget {
  final String id;
  final String nome;
  final double latitude;
  final double longitude;
  final int colmeias;
  final bool ativo;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onTap;
  final VoidCallback onReactivar;

  const Apiario({
    super.key,
    required this.id,
    required this.nome,
    required this.latitude,
    required this.longitude,
    required this.colmeias,
    required this.onDelete,
    required this.onEdit,
    required this.onTap,
    required this.onReactivar,
    this.ativo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ativo ? const Color(0xFFFFE49A) : Colors.grey[300],
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
                      color: ativo ? null : Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        nome.isNotEmpty ? nome : 'Apiário',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: ativo ? Colors.black : Colors.grey[700],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Colmeias Ativas: $colmeias',
                  style: TextStyle(
                    fontSize: 16,
                    color: ativo ? Colors.black : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Latitude: ${latitude.toStringAsFixed(5)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: ativo ? Colors.black : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Longitude: ${longitude.toStringAsFixed(5)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: ativo ? Colors.black : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (ativo)
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
          child: ativo
              ? IconButton(
                  icon: Image.asset(
                    'assets/Delete_Icon.png',
                    height: 28,
                  ),
                  onPressed: onDelete,
                  tooltip: 'Excluir',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              : TextButton(
                  onPressed: onReactivar,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'Reativar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
        ),
      ],
    );
  }
}
