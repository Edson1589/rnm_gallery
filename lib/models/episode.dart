class Episode {
  final int id;
  final String name;
  final String code;

  Episode({required this.id, required this.name, required this.code});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      code: json['episode'] as String? ?? '',
    );
  }
}
