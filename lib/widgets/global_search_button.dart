import 'package:flutter/material.dart';
import '../pages/search_page.dart';

/// Widget de bouton de recherche globale réutilisable
/// Peut être ajouté dans n'importe quelle AppBar
class GlobalSearchButton extends StatelessWidget {
  const GlobalSearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      tooltip: 'Recherche globale',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchPage()),
        );
      },
    );
  }
}

/// Widget de recherche flottant qui peut être ajouté en overlay
class FloatingSearchButton extends StatelessWidget {
  const FloatingSearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 80,
      child: FloatingActionButton(
        heroTag: 'global_search',
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.search, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchPage()),
          );
        },
      ),
    );
  }
}

/// Fonction helper pour afficher la recherche depuis n'importe où
void showGlobalSearch(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const SearchPage()),
  );
}
