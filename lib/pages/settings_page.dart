import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/settings_service.dart';
import '../services/score_service.dart';
import '../services/favorites_service.dart';
import '../services/notes_service.dart';
import '../services/streak_service.dart';
import '../services/subscription_service.dart';
import 'export_pdf_page.dart';
import 'paywall_page.dart';
import 'cloud_sync_page.dart';

import '../widgets/global_search_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsService _settingsService = SettingsService();
  final SubscriptionService _subscriptionService = SubscriptionService();

  @override
  void initState() {
    super.initState();
    _settingsService.addListener(_onSettingsChanged);
    _subscriptionService.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _settingsService.removeListener(_onSettingsChanged);
    _subscriptionService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
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
        title: const Text('Paramètres', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section Premium
          _buildPremiumCard(isDark),
          const SizedBox(height: 24),

          // Section Debug (visible uniquement en mode debug)
          if (kDebugMode) ...[
            _buildSectionTitle('Mode Test'),
            _buildCard(isDark, [
              SwitchListTile(
                title: const Text('Premium activé'),
                subtitle: Text(_subscriptionService.isPremium
                    ? 'Plan: ${_subscriptionService.currentPlan ?? "test"}'
                    : 'Activer pour tester sans payer'),
                secondary: Icon(
                  _subscriptionService.isPremium ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                value: _subscriptionService.isPremium,
                onChanged: (value) async {
                  if (value) {
                    await _subscriptionService.activatePremiumManually('test', days: 365);
                  } else {
                    await _subscriptionService.deactivatePremium();
                  }
                  setState(() {});
                },
              ),
            ]),
            const SizedBox(height: 24),
          ],

          // Section Apparence
          _buildSectionTitle('Apparence'),
          _buildCard(isDark, [
            // Mode sombre
            SwitchListTile(
              title: const Text('Mode sombre'),
              subtitle: const Text('Thème sombre pour le confort des yeux'),
              secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              value: _settingsService.isDarkMode,
              onChanged: (value) => _settingsService.setDarkMode(value),
            ),
            const Divider(height: 1),
            // Taille de police
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('Taille du texte'),
              subtitle: Text(_getFontSizeLabel(_settingsService.fontSize)),
              trailing: SizedBox(
                width: 150,
                child: Slider(
                  value: _settingsService.fontSize,
                  min: 0.8,
                  max: 1.4,
                  divisions: 6,
                  label: _getFontSizeLabel(_settingsService.fontSize),
                  onChanged: (value) => _settingsService.setFontSize(value),
                ),
              ),
            ),
          ]),

          const SizedBox(height: 24),

          // Section Quiz
          _buildSectionTitle('Quiz'),
          _buildCard(isDark, [
            // Timer
            SwitchListTile(
              title: const Text('Timer de quiz'),
              subtitle: Text(_settingsService.quizTimerEnabled
                  ? '${_settingsService.quizTimerSeconds}s par question'
                  : 'Désactivé'),
              secondary: const Icon(Icons.timer),
              value: _settingsService.quizTimerEnabled,
              onChanged: (value) => _settingsService.setQuizTimer(value),
            ),
            if (_settingsService.quizTimerEnabled) ...[
              const Divider(height: 1),
              ListTile(
                leading: const SizedBox(width: 24),
                title: const Text('Temps par question'),
                trailing: SizedBox(
                  width: 150,
                  child: Slider(
                    value: _settingsService.quizTimerSeconds.toDouble(),
                    min: 10,
                    max: 120,
                    divisions: 11,
                    label: '${_settingsService.quizTimerSeconds}s',
                    onChanged: (value) => _settingsService.setQuizTimer(
                      true,
                      seconds: value.round(),
                    ),
                  ),
                ),
              ),
            ],
          ]),

          const SizedBox(height: 24),

          // Section Lecture
          _buildSectionTitle('Lecture'),
          _buildCard(isDark, [
            SwitchListTile(
              title: const Text('Mode focus'),
              subtitle: const Text('Masque la navigation pendant la lecture'),
              secondary: const Icon(Icons.visibility_off),
              value: _settingsService.focusModeEnabled,
              onChanged: (value) => _settingsService.setFocusMode(value),
            ),
          ]),

          const SizedBox(height: 24),

          // Section Cloud
          _buildSectionTitle('Synchronisation'),
          _buildCard(isDark, [
            ListTile(
              leading: const Icon(Icons.cloud_sync),
              title: const Text('Cloud Sync'),
              subtitle: Text(_subscriptionService.isPremium
                  ? 'Synchroniser vos données'
                  : 'Fonctionnalité Premium'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CloudSyncPage(),
                  ),
                );
              },
            ),
          ]),

          const SizedBox(height: 24),

          // Section Export
          _buildSectionTitle('Export'),
          _buildCard(isDark, [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('Exporter en PDF'),
              subtitle: const Text('Créer un PDF de vos fiches'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExportPdfPage()),
              ),
            ),
          ]),

          const SizedBox(height: 24),

          // Section Données
          _buildSectionTitle('Données'),
          _buildCard(isDark, [
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Réinitialiser les scores'),
              subtitle: const Text('Supprimer tous les scores de quiz'),
              onTap: () => _showResetDialog(
                context,
                'Réinitialiser les scores ?',
                'Cette action supprimera tous vos scores de quiz.',
                () => ScoreService().resetAllScores(),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.orange),
              title: const Text('Supprimer les favoris'),
              subtitle: const Text('Retirer toutes les fiches des favoris'),
              onTap: () => _showResetDialog(
                context,
                'Supprimer les favoris ?',
                'Cette action retirera toutes vos fiches favorites.',
                () async {
                  final favs = FavoritesService().favorites.toList();
                  for (var f in favs) {
                    await FavoritesService().removeFavorite(f);
                  }
                },
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.blue),
              title: const Text('Supprimer les notes'),
              subtitle: const Text('Effacer toutes vos notes personnelles'),
              onTap: () => _showResetDialog(
                context,
                'Supprimer les notes ?',
                'Cette action effacera toutes vos notes personnelles.',
                () async {
                  final notes = NotesService().notes.keys.toList();
                  for (var n in notes) {
                    await NotesService().deleteNote(n);
                  }
                },
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.local_fire_department, color: Colors.orange),
              title: const Text('Réinitialiser les streaks'),
              subtitle: const Text('Remettre à zéro votre série'),
              onTap: () => _showResetDialog(
                context,
                'Réinitialiser les streaks ?',
                'Cette action remettra votre série de jours consécutifs à zéro.',
                () => StreakService().resetAll(),
              ),
            ),
          ]),

          const SizedBox(height: 24),

          // Section Légal
          _buildSectionTitle('Légal'),
          _buildCard(isDark, [
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Politique de confidentialité'),
              subtitle: const Text('Comment nous protégeons vos données'),
              trailing: const Icon(Icons.open_in_new, size: 16),
              onTap: () => _openUrl('https://agregmaster.fr/privacy.html'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: const Text('Conditions Générales d\'Utilisation'),
              subtitle: const Text('Règles d\'utilisation de l\'application'),
              trailing: const Icon(Icons.open_in_new, size: 16),
              onTap: () => _openUrl('https://agregmaster.fr/terms.html'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.gavel_outlined),
              title: const Text('Mentions légales'),
              trailing: const Icon(Icons.open_in_new, size: 16),
              onTap: () => _openUrl('https://agregmaster.fr/terms.html'),
            ),
          ]),

          const SizedBox(height: 24),

          // Section À propos
          _buildSectionTitle('À propos'),
          _buildCard(isDark, [
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Agreg Master'),
              subtitle: Text('Version 1.0.0'),
            ),
            const Divider(height: 1),
            const ListTile(
              leading: Icon(Icons.school),
              title: Text('Application de révision'),
              subtitle: Text('Préparation à l\'Agrégation de Mathématiques'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.devices),
              title: const Text('Multiplateforme'),
              subtitle: const Text('Disponible sur iOS, Android et Web.\nVotre abonnement est valable partout.'),
            ),
            if (kIsWeb) ...[
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.apple),
                title: const Text('Télécharger sur l\'App Store'),
                subtitle: const Text('iPhone et iPad'),
                trailing: const Icon(Icons.open_in_new, size: 16),
                onTap: () => _openUrl('https://apps.apple.com/app/agreg-master/id6740000879'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.shop),
                title: const Text('Télécharger sur Google Play'),
                subtitle: const Text('Android'),
                trailing: const Icon(Icons.open_in_new, size: 16),
                onTap: () => _openUrl('https://play.google.com/store/apps/details?id=com.agregmaster.app'),
              ),
            ],
            if (!kIsWeb) ...[
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Version Web'),
                subtitle: const Text('agregmaster.fr'),
                trailing: const Icon(Icons.open_in_new, size: 16),
                onTap: () => _openUrl('https://agregmaster.fr'),
              ),
            ],
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Contact & Support'),
              subtitle: const Text('contact@agregmaster.app'),
              trailing: const Icon(Icons.open_in_new, size: 16),
              onTap: () => _openUrl('mailto:contact@agregmaster.app'),
            ),
          ]),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPremiumCard(bool isDark) {
    final isPremium = _subscriptionService.isPremium;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isPremium
            ? LinearGradient(
                colors: [Colors.amber.shade400, Colors.amber.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [Colors.indigo.shade600, Colors.indigo.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isPremium ? Colors.amber : Colors.indigo).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPremium ? Icons.verified : Icons.workspace_premium,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPremium ? 'Agreg Master Premium' : 'Version Gratuite',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (isPremium && _subscriptionService.expirationDate != null)
                      Text(
                        'Jusqu\'au ${_formatDate(_subscriptionService.expirationDate!)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withAlpha((0.85 * 255).round()),
                        ),
                      )
                    else if (!isPremium)
                      Text(
                        'Débloquez tout le contenu',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withAlpha((0.85 * 255).round()),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (!isPremium) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PaywallPage(source: 'settings')),
                  );
                  if (result == true && mounted) {
                    setState(() {});
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.indigo.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Passer à Premium',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildCard(bool isDark, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  String _getFontSizeLabel(double value) {
    if (value <= 0.85) return 'Très petit';
    if (value <= 0.95) return 'Petit';
    if (value <= 1.05) return 'Normal';
    if (value <= 1.15) return 'Grand';
    if (value <= 1.25) return 'Très grand';
    return 'Maximum';
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showResetDialog(
    BuildContext context,
    String title,
    String message,
    Future<void> Function() onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          const GlobalSearchButton(),
          
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              await onConfirm();
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Données supprimées')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
