import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_saver/file_saver.dart';

class TelaVisualizarPdf extends StatelessWidget {
  final Uint8List pdfBytes;
  final String titulo;

  const TelaVisualizarPdf({
    super.key,
    required this.pdfBytes,
    required this.titulo,
  });

  Future<void> _compartilharPdf(BuildContext context) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = await File(
        '${tempDir.path}/$titulo.pdf',
      ).create();
      await file.writeAsBytes(pdfBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: titulo,
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao compartilhar: $e')),
        );
      }
    }
  }

  Future<void> _baixarPdf(BuildContext context) async {
    try {
      final fileName = titulo;
      await FileSaver.instance.saveAs(
        name: fileName,
        bytes: pdfBytes,
        fileExtension: 'pdf',
        mimeType: MimeType.pdf,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Arquivo salvo com sucesso no local escolhido!'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao baixar arquivo: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEC107),
        elevation: 0,
        title: Text(
          titulo,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _baixarPdf(context),
            tooltip: 'Baixar no Dispositivo',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _compartilharPdf(context),
            tooltip: 'Compartilhar',
          ),
        ],
      ),
      body: SfPdfViewer.memory(pdfBytes),
    );
  }
}
