import 'package:flutter/material.dart';
import '../services/cloud_sync_service.dart';
import '../services/subscription_service.dart';
import 'paywall_page.dart';

/// Page de gestion de la synchronisation cloud
class CloudSyncPage extends StatefulWidget {
  const CloudSyncPage({super.key});

  @override
  State<CloudSyncPage> createState() => _CloudSyncPageState();
}

class _CloudSyncPageState extends State<CloudSyncPage> {
  final CloudSyncService _cloudSyncService = CloudSyncService();
  final SubscriptionService _subscriptionService = SubscriptionService();

  @override
  void initState() {
    super.initState();
    _cloudSyncService.addListener(_onSyncStatusChanged);
  }

  @override
  void dispose() {
    _cloudSyncService.removeListener(_onSyncStatusChanged);
    super.dispose();
  }

  void _onSyncStatusChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPremium = _subscriptionService.isPremium;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: const Text('Synchronisation Cloud', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: !isPremium
          ? _buildPremiumRequired()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Statut de synchronisation
                _buildSyncStatusCard(isDark),
                
                const SizedBox(height: 16),

                // Informations utilisateur
                _buildUserInfoCard(isDark),

                const SizedBox(height: 16),

                // Actions
                _buildActionsCard(isDark),

                const SizedBox(height: 16),

                // Historique
                _buildHistoryCard(isDark),

                const SizedBox(height: 16),

                // Informations techniques
                _buildTechnicalInfoCard(isDark),
              ],
            ),
    );
  }

  Widget _buildPremiumRequired() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Synchronisation Cloud',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Cette fonctionnalité est réservée aux abonnés Premium.\n\nSynchronisez vos données entre tous vos appareils !',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PaywallPage(source: 'cloud_sync')),
                  );
                  if (result == true && mounted) {
                    setState(() {});
                  }
                },
                icon: const Icon(Icons.workspace_premium),
                label: const Text(
                  'Passer à Premium',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStatusCard(bool isDark) {
    final isSyncing = _cloudSyncService.isSyncing;
    final isOnline = _cloudSyncService.isOnline;
    final error = _cloudSyncService.error;

    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (error != null) {
      statusColor = Colors.red;
      statusIcon = Icons.error;
      statusText = 'Erreur de synchronisation';
    } else if (isSyncing) {
      statusColor = Colors.blue;
      statusIcon = Icons.sync;
      statusText = 'Synchronisation en cours...';
    } else if (!isOnline) {
      statusColor = Colors.orange;
      statusIcon = Icons.cloud_off;
      statusText = 'Hors ligne';
    } else {
      statusColor = Colors.green;
      statusIcon = Icons.cloud_done;
      statusText = 'Synchronisé';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha((0.15 * 255).round()),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  statusIcon,
                  color: statusColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (_cloudSyncService.lastSyncTime != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Dernière sync : ${_formatLastSync(_cloudSyncService.lastSyncTime!)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSyncing)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          if (error != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserInfoCard(bool isDark) {
    final userId = _cloudSyncService.userId;
    final isAuthenticated = _cloudSyncService.isAuthenticated;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.indigo.shade600,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Compte',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Statut', isAuthenticated ? 'Connecté' : 'Déconnecté', isDark),
          const SizedBox(height: 8),
          _buildInfoRow('ID Utilisateur', userId != null ? '${userId.substring(0, 8)}...' : 'N/A', isDark),
          const SizedBox(height: 8),
          _buildInfoRow('Type', 'Compte anonyme', isDark),
        ],
      ),
    );
  }

  Widget _buildActionsCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings,
                color: Colors.indigo.shade600,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Bouton synchroniser maintenant
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _cloudSyncService.isSyncing ? null : _handleSyncNow,
              icon: const Icon(Icons.sync),
              label: const Text('Synchroniser maintenant'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Bouton danger : supprimer données cloud
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _handleDeleteCloudData,
              icon: const Icon(Icons.delete_forever),
              label: const Text('Supprimer données cloud'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: Colors.indigo.shade600,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Données Synchronisées',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDataItem('Scores de quiz', Icons.quiz, isDark),
          _buildDataItem('Favoris', Icons.star, isDark),
          _buildDataItem('Notes', Icons.note, isDark),
          _buildDataItem('Progression de lecture', Icons.menu_book, isDark),
          _buildDataItem('Streak', Icons.local_fire_department, isDark),
          _buildDataItem('Badges', Icons.emoji_events, isDark),
          _buildDataItem('Répétition espacée', Icons.repeat, isDark),
          _buildDataItem('Progression leçons', Icons.school, isDark),
          _buildDataItem('Résultats examens blancs', Icons.assignment, isDark),
        ],
      ),
    );
  }

  Widget _buildTechnicalInfoCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info,
                color: Colors.indigo.shade600,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Informations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '• Synchronisation automatique toutes les 5 minutes\n'
            '• Synchronisation lors de la connexion Internet\n'
            '• Fusion intelligente des données (garde le plus récent)\n'
            '• Authentification anonyme Firebase\n'
            '• Données chiffrées en transit (HTTPS)\n'
            '• Stockage sécurisé sur Cloud Firestore',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDataItem(String label, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _formatLastSync(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) {
      return 'À l\'instant';
    } else if (diff.inMinutes < 60) {
      return 'Il y a ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'Il y a ${diff.inHours}h';
    } else {
      return 'Il y a ${diff.inDays} jours';
    }
  }

  Future<void> _handleSyncNow() async {
    await _cloudSyncService.forceSyncNow();
    
    if (mounted && _cloudSyncService.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Synchronisation terminée !'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _handleDeleteCloudData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('⚠️ Supprimer les données cloud ?'),
        content: const Text(
          'Cette action supprimera toutes vos données synchronisées dans le cloud. '
          'Vos données locales seront conservées.\n\n'
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _cloudSyncService.deleteAllCloudData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ Données cloud supprimées'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
