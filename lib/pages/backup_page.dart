import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../services/backup_service.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({Key? key}) : super(key: key);

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  final BackupService _backupService = BackupService();
  List<BackupInfo> _backups = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _backupService.addListener(_onDataChanged);
    _loadBackups();
    _backupService.loadBackupInfo();
  }

  @override
  void dispose() {
    _backupService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadBackups() async {
    setState(() => _isLoading = true);
    _backups = await _backupService.getAvailableBackups();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('☁️ Sauvegarde & Restauration'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 24),
            _buildQuickActions(),
            const SizedBox(height: 24),
            _buildBackupsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final lastBackup = _backupService.lastBackupTime;
    final timeSinceBackup = lastBackup != null
        ? DateTime.now().difference(lastBackup)
        : null;

    String statusText;
    Color statusColor;
    IconData statusIcon;

    if (lastBackup == null) {
      statusText = 'Aucune sauvegarde';
      statusColor = Colors.orange;
      statusIcon = Icons.warning;
    } else if (timeSinceBackup!.inHours < 24) {
      statusText = 'À jour';
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (timeSinceBackup.inDays < 7) {
      statusText = 'Sauvegarde recommandée';
      statusColor = Colors.orange;
      statusIcon = Icons.schedule;
    } else {
      statusText = 'Sauvegarde urgente !';
      statusColor = Colors.red;
      statusIcon = Icons.error;
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 48),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (lastBackup != null)
                        Text(
                          'Dernière sauvegarde :\n${_formatDate(lastBackup)}',
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        )
                      else
                        const Text(
                          'Créez votre première sauvegarde',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 20, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Vos données sont sauvegardées localement. Pensez à exporter régulièrement !',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '⚡ Actions rapides',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.backup,
                label: 'Créer une\nsauvegarde',
                color: Colors.green,
                onTap: _createBackup,
                isLoading: _backupService.isBackingUp,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.file_upload,
                label: 'Exporter\nles données',
                color: Colors.blue,
                onTap: _exportData,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.restore,
                label: 'Restaurer',
                color: Colors.orange,
                onTap: _showRestoreDialog,
                isLoading: _backupService.isRestoring,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.delete_sweep,
                label: 'Nettoyer\nvieux backups',
                color: Colors.red,
                onTap: _cleanOldBackups,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (isLoading)
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(strokeWidth: 3),
                )
              else
                Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackupsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📦 Sauvegardes disponibles',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_backups.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.folder_open, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Aucune sauvegarde disponible',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _backups.length,
            itemBuilder: (context, index) => _buildBackupCard(_backups[index]),
          ),
      ],
    );
  }

  Widget _buildBackupCard(BackupInfo backup) {
    final isRecent = DateTime.now().difference(backup.date).inHours < 24;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          Icons.backup,
          color: isRecent ? Colors.green : Colors.grey,
        ),
        title: Text(backup.dateFormatted),
        subtitle: Text(backup.sizeFormatted),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.restore, color: Colors.blue),
              onPressed: () => _restoreBackup(backup),
              tooltip: 'Restaurer',
            ),
            IconButton(
              icon: const Icon(Icons.share, color: Colors.orange),
              onPressed: () => _shareBackup(backup),
              tooltip: 'Partager',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteBackup(backup),
              tooltip: 'Supprimer',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createBackup() async {
    try {
      final path = await _backupService.createBackup();
      if (path != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✅ Sauvegarde créée avec succès !'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Voir',
              textColor: Colors.white,
              onPressed: _loadBackups,
            ),
          ),
        );
        await _loadBackups();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _exportData() async {
    try {
      final path = await _backupService.exportData();
      if (path != null && mounted) {
        await Share.shareXFiles([XFile(path)], text: 'Export Agreg Master');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showRestoreDialog() {
    if (_backups.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune sauvegarde disponible'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restaurer une sauvegarde'),
        content: const Text(
          'Choisissez une sauvegarde dans la liste ci-dessous.\n\n'
          '⚠️ Attention : Cela remplacera toutes vos données actuelles !',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // L'utilisateur choisira dans la liste
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _restoreBackup(BackupInfo backup) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Confirmer la restauration'),
        content: Text(
          'Voulez-vous restaurer la sauvegarde du ${backup.dateFormatted} ?\n\n'
          'Toutes vos données actuelles seront remplacées !',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Restaurer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _backupService.restoreFromBackup(backup.path);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Restauration réussie !'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Erreur : $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _shareBackup(BackupInfo backup) async {
    await Share.shareXFiles([XFile(backup.path)], text: 'Backup Agreg Master');
  }

  Future<void> _deleteBackup(BackupInfo backup) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer cette sauvegarde ?'),
        content: Text('Backup du ${backup.dateFormatted}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _backupService.deleteBackup(backup.path);
        await _loadBackups();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Sauvegarde supprimée'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Erreur : $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _cleanOldBackups() async {
    final oldBackups = _backups.where((b) {
      return DateTime.now().difference(b.date).inDays > 30;
    }).toList();

    if (oldBackups.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune sauvegarde ancienne à supprimer'),
          backgroundColor: Colors.blue,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nettoyer les vieux backups'),
        content: Text(
          'Supprimer ${oldBackups.length} sauvegarde(s) de plus de 30 jours ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Nettoyer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        for (final backup in oldBackups) {
          await _backupService.deleteBackup(backup.path);
        }
        await _loadBackups();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ ${oldBackups.length} sauvegarde(s) supprimée(s)'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Erreur : $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inHours < 1) return 'Il y a ${diff.inMinutes} min';
    if (diff.inDays < 1) return 'Il y a ${diff.inHours}h';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays}j';

    return '${date.day}/${date.month}/${date.year}';
  }
}
