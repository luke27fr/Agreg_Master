import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import '../utils/content_loader.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../utils/theme_utils.dart';

class ExportPdfPage extends StatefulWidget {
  const ExportPdfPage({super.key});

  @override
  State<ExportPdfPage> createState() => _ExportPdfPageState();
}

class _ExportPdfPageState extends State<ExportPdfPage> {
  List<Map<String, dynamic>> _themes = [];
  final Set<String> _selectedFiches = {};
  bool _loading = true;
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    _loadManifest();
  }

  Future<void> _loadManifest() async {
    try {
      final json = await ContentLoader.loadString('assets/fiches/manifest.json');
      final data = jsonDecode(json) as Map<String, dynamic>;
      final themes = (data['themes'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList();

      setState(() {
        _themes = themes ?? [];
        _loading = false;
      });
    } catch (e) {
      debugPrint('Erreur chargement manifest: $e');
      setState(() => _loading = false);
    }
  }

  void _toggleFiche(String ficheId) {
    setState(() {
      if (_selectedFiches.contains(ficheId)) {
        _selectedFiches.remove(ficheId);
      } else {
        _selectedFiches.add(ficheId);
      }
    });
  }

  void _selectAllFromTheme(Map<String, dynamic> theme) {
    setState(() {
      final files = (theme['files'] as List).cast<String>();
      for (var file in files) {
        _selectedFiches.add(file.replaceAll('.md', ''));
      }
    });
  }

  void _deselectAllFromTheme(Map<String, dynamic> theme) {
    setState(() {
      final files = (theme['files'] as List).cast<String>();
      for (var file in files) {
        _selectedFiches.remove(file.replaceAll('.md', ''));
      }
    });
  }

  Future<void> _exportToPdf() async {
    if (_selectedFiches.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sélectionnez au moins une fiche')),
      );
      return;
    }

    setState(() => _exporting = true);

    try {
      final pdf = pw.Document();

      // Page de titre
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'Agreg Master',
                  style: pw.TextStyle(
                    fontSize: 36,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Fiches de révision',
                  style: const pw.TextStyle(fontSize: 24),
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  '${_selectedFiches.length} fiches sélectionnées',
                  style: const pw.TextStyle(fontSize: 16),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Exporté le ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
                ),
              ],
            ),
          ),
        ),
      );

      // Table des matières
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Table des matières',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              ...List.generate(_selectedFiches.length, (index) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Text(
                    '${index + 1}. ${_selectedFiches.elementAt(index)}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                );
              }),
            ],
          ),
        ),
      );

      // Charger et ajouter chaque fiche
      for (var ficheId in _selectedFiches) {
        // Trouver le chemin de la fiche
        String? fichePath;
        for (var theme in _themes) {
          final files = (theme['files'] as List).cast<String>();
          for (var file in files) {
            if (file.replaceAll('.md', '') == ficheId) {
              fichePath = '${theme['path']}/$file';
              break;
            }
          }
          if (fichePath != null) break;
        }

        if (fichePath != null) {
          try {
            final content = await ContentLoader.loadString(fichePath);
            
            // Convertir le markdown en texte simple pour le PDF
            final cleanContent = _cleanMarkdown(content);

            pdf.addPage(
              pw.MultiPage(
                pageFormat: PdfPageFormat.a4,
                margin: const pw.EdgeInsets.all(40),
                header: (context) => pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 20),
                  child: pw.Text(
                    ficheId,
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                ),
                footer: (context) => pw.Container(
                  alignment: pw.Alignment.center,
                  margin: const pw.EdgeInsets.only(top: 20),
                  child: pw.Text(
                    'Page ${context.pageNumber}',
                    style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
                  ),
                ),
                build: (context) => [
                  pw.Header(
                    level: 0,
                    child: pw.Text(
                      ficheId,
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    cleanContent,
                    style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.5),
                  ),
                ],
              ),
            );
          } catch (e) {
            debugPrint('Erreur lecture $ficheId: $e');
          }
        }
      }

      // Afficher/sauvegarder le PDF
      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name: 'agreg_master_fiches.pdf',
      );
    } catch (e) {
      debugPrint('Erreur export PDF: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'export: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _exporting = false);
      }
    }
  }

  String _cleanMarkdown(String markdown) {
    // Enlever les blocs de code LaTeX
    var cleaned = markdown.replaceAll(RegExp(r'\$\$[\s\S]*?\$\$'), '[Formule]');
    cleaned = cleaned.replaceAll(RegExp(r'\$[^\$]+\$'), '[Math]');
    
    // Enlever les en-têtes markdown (garder le texte)
    cleaned = cleaned.replaceAll(RegExp(r'^#+\s*', multiLine: true), '');
    
    // Enlever les caractères de mise en forme
    cleaned = cleaned.replaceAll(RegExp(r'\*\*([^\*]+)\*\*'), r'\1');
    cleaned = cleaned.replaceAll(RegExp(r'\*([^\*]+)\*'), r'\1');
    cleaned = cleaned.replaceAll(RegExp(r'`([^`]+)`'), r'\1');
    
    // Enlever les liens markdown
    cleaned = cleaned.replaceAll(RegExp(r'\[([^\]]+)\]\([^\)]+\)'), r'\1');
    
    // Simplifier les listes
    cleaned = cleaned.replaceAll(RegExp(r'^[\*\-]\s+', multiLine: true), '• ');
    
    // Enlever les lignes vides multiples
    cleaned = cleaned.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    
    return cleaned.trim();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: const Text('Export PDF', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          if (_selectedFiches.isNotEmpty)
            TextButton(
              onPressed: () => setState(() => _selectedFiches.clear()),
              child: const Text('Tout désélectionner'),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Info
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${_selectedFiches.length} fiche${_selectedFiches.length > 1 ? 's' : ''} sélectionnée${_selectedFiches.length > 1 ? 's' : ''}',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),

                // Liste des fiches par thème
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _themes.length,
                    itemBuilder: (context, themeIndex) {
                      final theme = _themes[themeIndex];
                      final files = (theme['files'] as List).cast<String>();
                      final themeLabel = theme['label'] as String;
                      
                      final selectedInTheme = files
                          .where((f) => _selectedFiches.contains(f.replaceAll('.md', '')))
                          .length;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                          title: Text(
                            themeLabel,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '$selectedInTheme/${files.length} sélectionnées',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.select_all, size: 20),
                                onPressed: () => _selectAllFromTheme(theme),
                                tooltip: 'Tout sélectionner',
                              ),
                              IconButton(
                                icon: const Icon(Icons.deselect, size: 20),
                                onPressed: () => _deselectAllFromTheme(theme),
                                tooltip: 'Tout désélectionner',
                              ),
                            ],
                          ),
                          children: files.map((file) {
                            final ficheId = file.replaceAll('.md', '');
                            final isSelected = _selectedFiches.contains(ficheId);
                            
                            return CheckboxListTile(
                              title: Text(ThemeUtils.getFicheTitle(ficheId)),
                              value: isSelected,
                              onChanged: (_) => _toggleFiche(ficheId),
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),

                // Bouton export
                Container(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _exporting ? null : _exportToPdf,
                      icon: _exporting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.picture_as_pdf),
                      label: Text(_exporting ? 'Export en cours...' : 'Exporter en PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
