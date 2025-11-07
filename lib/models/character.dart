class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String originName;
  final String locationName;
  final String image;
  final List<String> episodeUrls;
  final DateTime? created;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.originName,
    required this.locationName,
    required this.image,
    required this.episodeUrls,
    required this.created,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      species: json['species'] as String? ?? '',
      type: json['type'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      originName: (json['origin']?['name'] as String?) ?? '',
      locationName: (json['location']?['name'] as String?) ?? '',
      image: json['image'] as String? ?? '',
      episodeUrls: (json['episode'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      created: DateTime.tryParse(json['created']?.toString() ?? ''),
    );
  }
}
