import 'package:flutter/material.dart';
import 'tabs/accueil_tab.dart';
import 'tabs/apprendre_tab.dart';
import 'tabs/entrainer_tab.dart';
import 'tabs/organiser_tab.dart';
import 'tabs/profil_tab.dart';
import '../services/spaced_repetition_service.dart';
import '../services/analytics_service.dart';

class HomeNavigationPage extends StatefulWidget {
  const HomeNavigationPage({super.key});

  @override
  State<HomeNavigationPage> createState() => _HomeNavigationPageState();
}

class _HomeNavigationPageState extends State<HomeNavigationPage> {
  int _currentIndex = 0;
  final SpacedRepetitionService _srsService = SpacedRepetitionService();

  @override
  void initState() {
    super.initState();
    _srsService.addListener(_onChanged);
  }

  @override
  void dispose() {
    _srsService.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  void _navigateToTab(int index) {
    if (index >= 0 && index <= 4) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dueCount = _srsService.getDueCards().length;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          AccueilTab(onNavigateToTab: _navigateToTab),
          const ApprendreTab(),
          const EntrainerTab(),
          const OrganiserTab(),
          const ProfilTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) { setState(() => _currentIndex = i); AnalyticsService().logTabChange(tabName: const ['accueil', 'apprendre', 'entrainer', 'organiser', 'profil'][i]); },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          const NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Apprendre',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: dueCount > 0,
              label: Text('$dueCount'),
              child: const Icon(Icons.fitness_center_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: dueCount > 0,
              label: Text('$dueCount'),
              child: const Icon(Icons.fitness_center),
            ),
            label: "S'entraîner",
          ),
          const NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'Organiser',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
