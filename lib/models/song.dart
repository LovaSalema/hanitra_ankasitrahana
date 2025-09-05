class Song {
  final int? id;
  final int numero;
  final String titre;
  final String auteur;
  final String tonalite;
  final String mesure;
  final String paroles;
  final String? lienAudio;

  Song({
    this.id,
    required this.numero,
    required this.titre,
    required this.auteur,
    required this.tonalite,
    required this.mesure,
    required this.paroles,
    this.lienAudio,
  });

  // Convert Song to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numero': numero,
      'titre': titre,
      'auteur': auteur,
      'tonalite': tonalite,
      'mesure': mesure,
      'paroles': paroles,
      'lienAudio': lienAudio,
    };
  }

  // Create Song from Map (database query result)
  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id']?.toInt(),
      numero: map['numero']?.toInt() ?? 0,
      titre: map['titre'] ?? '',
      auteur: map['auteur'] ?? '',
      tonalite: map['tonalite'] ?? '',
      mesure: map['mesure'] ?? '',
      paroles: map['paroles'] ?? '',
      lienAudio: map['lienAudio'],
    );
  }

  // Create a copy of Song with updated fields
  Song copyWith({
    int? id,
    int? numero,
    String? titre,
    String? auteur,
    String? tonalite,
    String? mesure,
    String? paroles,
    String? lienAudio,
  }) {
    return Song(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      titre: titre ?? this.titre,
      auteur: auteur ?? this.auteur,
      tonalite: tonalite ?? this.tonalite,
      mesure: mesure ?? this.mesure,
      paroles: paroles ?? this.paroles,
      lienAudio: lienAudio ?? this.lienAudio,
    );
  }

  @override
  String toString() {
    return 'Song{id: $id, numero: $numero, titre: $titre, auteur: $auteur, tonalite: $tonalite, mesure: $mesure, lienAudio: $lienAudio}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Song &&
        other.id == id &&
        other.numero == numero &&
        other.titre == titre &&
        other.auteur == auteur &&
        other.tonalite == tonalite &&
        other.mesure == mesure &&
        other.paroles == paroles &&
        other.lienAudio == lienAudio;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        numero.hashCode ^
        titre.hashCode ^
        auteur.hashCode ^
        tonalite.hashCode ^
        mesure.hashCode ^
        paroles.hashCode ^
        lienAudio.hashCode;
  }
}
