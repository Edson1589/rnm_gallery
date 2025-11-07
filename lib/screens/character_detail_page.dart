import 'package:flutter/material.dart';
import '../core/api.dart';
import '../models/character.dart';
import '../models/episode.dart';
import '../widgets/state_views.dart';

class CharacterDetailPage extends StatefulWidget {
  final Character character;
  const CharacterDetailPage({super.key, required this.character});

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  late Future<List<Episode>> _futureEpisodes;
  final _api = ApiClient();

  @override
  void initState() {
    super.initState();
    _futureEpisodes = _api.fetchEpisodesByUrls(widget.character.episodeUrls);
  }

  @override
  void dispose() {
    _api.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.character;

    return Scaffold(
      appBar: AppBar(title: Text(c.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'img_${c.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(c.image, height: 260, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyMedium!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _kv('Estado', c.status),
                      _kv('Especie', c.species),
                      if (c.type.isNotEmpty) _kv('Tipo', c.type),
                      _kv('Género', c.gender),
                      _kv('Origen', c.originName),
                      _kv('Ubicación', c.locationName),
                      if (c.created != null)
                        _kv('Creado', c.created!.toLocal().toString()),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text('Aparece en', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),

            FutureBuilder<List<Episode>>(
              future: _futureEpisodes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingView(message: 'Cargando episodios...');
                }
                if (snapshot.hasError) {
                  return ErrorView(
                    error: snapshot.error!,
                    onRetry: () {
                      setState(() {
                        _futureEpisodes = _api.fetchEpisodesByUrls(
                          c.episodeUrls,
                        );
                      });
                    },
                  );
                }

                final eps = snapshot.data ?? const <Episode>[];
                if (eps.isEmpty) {
                  return const Text('Sin episodios (¿raro, no?)');
                }

                return Card(
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: eps.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final e = eps[i];
                      return ListTile(
                        leading: const Icon(Icons.movie_outlined),
                        title: Text(e.name),
                        subtitle: Text(e.code),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text('$k: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }
}
