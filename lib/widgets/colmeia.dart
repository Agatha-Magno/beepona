import 'package:flutter/material.dart';

class Colmeia extends StatelessWidget {
  final String id;
  final String nome;
  final double peso;
  final String produto;
  final bool ativa;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onReactivar;

  const Colmeia({
    super.key,
    required this.id,
    required this.nome,
    required this.peso,
    required this.produto,
    this.onDelete,
    this.onEdit,
    this.onReactivar,
    this.ativa = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ativa ? const Color(0xFFFFE49A) : Colors.grey[300],
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
                    color: ativa ? null : Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      nome.isNotEmpty ? nome : 'Colmeia',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: ativa ? Colors.black : Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Peso: ${peso.toStringAsFixed(2)} kg',
                style: TextStyle(
                  fontSize: 16,
                  color: ativa ? Colors.black : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Produto: $produto',
                style: TextStyle(
                  fontSize: 16,
                  color: ativa ? Colors.black : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        if (ativa && onEdit != null)
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
          child: ativa
              ? (onDelete != null
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
                  : const SizedBox.shrink())
              : (onReactivar != null
                  ? TextButton(
                      onPressed: onReactivar,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
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
                    )
                  : const SizedBox.shrink()),
        ),
      ],
    );
  }
}
