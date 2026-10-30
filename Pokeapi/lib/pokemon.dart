class Pokemon {
  final int id;

  final String name;

  final int baseExperience;

  final int height;

  final int weight;

  final List<String> types;

  final List<String> abilities;

  final List<String> heldItems;

  final List<String> moves;

  final String spriteUrl;

  Pokemon({
    required this.id,
    required this.name,
    required this.baseExperience,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.heldItems,
    required this.moves,
    required this.spriteUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    var typesList = (json['types'] as List)
        .map((t) => t['type']['name'].toString())
        .toList();

    var abilitiesList = (json['abilities'] as List)
        .map((a) => a['ability']['name'].toString())
        .toList();

    var heldItemsList = (json['held_items'] as List)
        .map((h) => h['item']['name'].toString())
        .toList();

    var movesList = (json['moves'] as List)
        .map((m) => m['move']['name'].toString())
        .toList();

    String sprite = '';

    if (json['sprites'] != null) {
      if (json['sprites']['other'] != null &&
          json['sprites']['other']['official-artwork'] != null) {
        sprite =
            json['sprites']['other']['official-artwork']['front_default'] ?? '';
      }

      if (sprite.isEmpty) {
        sprite = json['sprites']['front_default'] ?? '';
      }
    }

    return Pokemon(
      id: json['id'] ?? 644,
      name: json['name'] ?? 'zekrom',
      baseExperience: json['base_experience'] ?? 0,
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
      types: typesList,
      abilities: abilitiesList,
      heldItems: heldItemsList,
      moves: movesList,
      spriteUrl: sprite,
    );
  }
}
