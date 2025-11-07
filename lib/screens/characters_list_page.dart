import 'package:flutter/material.dart';
import '../core/api.dart';
import '../models/character.dart';
import '../widgets/state_views.dart';
import 'character_detail_page.dart';

class CharactersListPage extends StatefulWidget {
  const CharactersListPage({super.key});

  @override
  State<CharactersListPage> createState() => _CharactersListPageState();
}

class _CharactersListPageState extends State<CharactersListPage> {
  late Future<List<Character>> _future;
  final _api = ApiClient();

  @override
  void initState() {
    super.initState();
    _future = _api.fetchCharacters(page: 1);
  }

  @override
  void dispose() {
    _api.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personajes (Rick & Morty)')),
      body: FutureBuilder<List<Character>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView(message: 'Cargando personajes...');
          }

          if (snapshot.hasError) {
            return ErrorView(
              error: snapshot.error!,
              onRetry: () {
                setState(() {
                  _future = _api.fetchCharacters(page: 1);
                });
              },
            );
          }

          final items = snapshot.data ?? const <Character>[];
          if (items.isEmpty) {
            return const Center(child: Text('No hay personajes'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, i) {
              final c = items[i];
              return ListTile(
                leading: Hero(
                  tag: 'img_${c.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      c.image,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(c.name),
                subtitle: Text('${c.species} • ${c.status}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CharacterDetailPage(character: c),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemCount: items.length,
          );
        },
      ),
    );
  }
}
