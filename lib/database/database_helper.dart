import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/song.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'hanitra_ankasitrahana.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE songs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numero INTEGER NOT NULL,
        titre TEXT NOT NULL,
        auteur TEXT NOT NULL,
        tonalite TEXT NOT NULL,
        mesure TEXT NOT NULL,
        paroles TEXT NOT NULL,
        lienAudio TEXT
      )
    ''');

    // Insert sample data
    await _insertSampleData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < newVersion) {
      // Example: Add new columns or tables
      // await db.execute('ALTER TABLE songs ADD COLUMN new_column TEXT');
    }
  }

  // CRUD Operations

  /// Insert a new song into the database
  Future<int> insertSong(Song song) async {
    final db = await database;
    return await db.insert('songs', song.toMap());
  }

  /// Get all songs from the database
  Future<List<Song>> getAllSongs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'songs',
      orderBy: 'numero ASC',
    );

    return List.generate(maps.length, (i) {
      return Song.fromMap(maps[i]);
    });
  }

  /// Get a song by its ID
  Future<Song?> getSongById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'songs',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Song.fromMap(maps.first);
    }
    return null;
  }

  /// Get a song by its number
  Future<Song?> getSongByNumber(int numero) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'songs',
      where: 'numero = ?',
      whereArgs: [numero],
    );

    if (maps.isNotEmpty) {
      return Song.fromMap(maps.first);
    }
    return null;
  }

  /// Search songs by title, author, or lyrics
  Future<List<Song>> searchSongs(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'songs',
      where: 'titre LIKE ? OR auteur LIKE ? OR paroles LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'numero ASC',
    );

    return List.generate(maps.length, (i) {
      return Song.fromMap(maps[i]);
    });
  }

  /// Update an existing song
  Future<int> updateSong(Song song) async {
    final db = await database;
    return await db.update(
      'songs',
      song.toMap(),
      where: 'id = ?',
      whereArgs: [song.id],
    );
  }

  /// Delete a song by its ID
  Future<int> deleteSong(int id) async {
    final db = await database;
    return await db.delete('songs', where: 'id = ?', whereArgs: [id]);
  }

  /// Get songs by author
  Future<List<Song>> getSongsByAuthor(String auteur) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'songs',
      where: 'auteur = ?',
      whereArgs: [auteur],
      orderBy: 'numero ASC',
    );

    return List.generate(maps.length, (i) {
      return Song.fromMap(maps[i]);
    });
  }

  /// Get songs by tonality
  Future<List<Song>> getSongsByTonality(String tonalite) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'songs',
      where: 'tonalite = ?',
      whereArgs: [tonalite],
      orderBy: 'numero ASC',
    );

    return List.generate(maps.length, (i) {
      return Song.fromMap(maps[i]);
    });
  }

  /// Get total count of songs
  Future<int> getSongCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM songs');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Close the database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  /// Insert sample data for testing
  Future<void> _insertSampleData(Database db) async {
    final sampleSongs = [
      {
        'numero': 1,
        'titre': 'Lumière du Matin',
        'auteur': 'Marie Rasoamanana',
        'tonalite': 'Do Majeur',
        'mesure': '4/4',
        'paroles': '''Verse 1:
Quand le soleil se lève sur la colline
Les oiseaux chantent leur mélodie divine
Un nouveau jour commence avec espoir
Dans nos cœurs brille une lumière d'espoir

Refrain:
Lumière du matin, guide nos pas
Vers un avenir plein de joie
Ensemble nous chantons cette mélodie
Qui unit nos cœurs en harmonie''',
        'lienAudio':
            'https://soundcloud.com/user-701125508/ho-azy-ny-voninahitra?si=d17a2323ae144f3885e598f0dc4a97a5&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing',
      },
      {
        'numero': 2,
        'titre': 'Vent des Hautes Terres',
        'auteur': 'Jean Rakoto',
        'tonalite': 'Sol Majeur',
        'mesure': '3/4',
        'paroles': '''Verse 1:
Le vent souffle sur les hautes terres
Portant les rêves de nos ancêtres
Dans chaque brise une histoire se raconte
De courage et de fierté qui remonte

Refrain:
Vent des hautes terres, emporte nos voix
Vers les sommets où résonnent nos émois
Chantons ensemble cette terre bénie
Qui nous a vus naître et grandir ici''',
        'lienAudio': 'https://soundcloud.com/example/danse-de-la-pluie',
      },
      {
        'numero': 3,
        'titre': 'Danse de la Pluie',
        'auteur': 'Hery Andriamampianina',
        'tonalite': 'Ré Mineur',
        'mesure': '6/8',
        'paroles': '''Verse 1:
Les nuages s'assemblent dans le ciel gris
La terre attend la pluie avec envie
Chaque goutte qui tombe est une bénédiction
Pour les champs et les cœurs en gestation

Refrain:
Danse de la pluie, rythme de la vie
Arrose nos rêves, nos espoirs aussi
Dans chaque goutte une promesse se cache
D'un avenir meilleur qui se détache''',
        'lienAudio': null,
      },
      {
        'numero': 4,
        'titre': 'Étoiles du Sud',
        'auteur': 'Nivo Razafy',
        'tonalite': 'La Majeur',
        'mesure': '4/4',
        'paroles': '''Verse 1:
Sous les étoiles du ciel austral
Nos ancêtres ont tracé le chemin
Chaque constellation raconte une histoire
De sagesse et d'amour sans fin

Refrain:
Étoiles du sud, brillez pour nous
Guidez nos pas vers des jours plus doux
Dans votre lumière nous trouvons la paix
Et l'espoir d'un monde qui renaît''',
        'lienAudio': null,
      },
      {
        'numero': 5,
        'titre': 'Chant du Baobab',
        'auteur': 'Lalao Raharison',
        'tonalite': 'Mi Majeur',
        'mesure': '4/4',
        'paroles': '''Verse 1:
Le vieux baobab au tronc majestueux
Garde les secrets de nos aïeux
Ses branches étendues vers le ciel
Portent les prières éternelles

Refrain:
Chant du baobab, sagesse millénaire
Enseigne-nous les mystères de la terre
Dans ton ombre nous trouvons la force
De continuer notre course''',
        'lienAudio': null,
      },
      {
        'numero': 6,
        'titre': 'Rivière Sacrée',
        'auteur': 'Ravo Andriantsoa',
        'tonalite': 'Fa Majeur',
        'mesure': '4/4',
        'paroles': '''Verse 1:
La rivière coule vers l'océan
Portant nos rêves et nos chants
Chaque méandre raconte une histoire
De vie, d'amour et de mémoire

Refrain:
Rivière sacrée, source de vie
Purifie nos âmes, nos esprits aussi
Dans ton courant nous trouvons la paix
Et la force de recommencer''',
        'lienAudio': null,
      },
      {
        'numero': 7,
        'titre': 'Flamme Éternelle',
        'auteur': 'Miora Rakotomalala',
        'tonalite': 'Si♭ Majeur',
        'mesure': '4/4',
        'paroles': '''Verse 1:
Dans le cœur de chaque enfant
Brûle une flamme ardente
Qui éclaire le chemin de demain
Et guide nos pas vers l'avant

Refrain:
Flamme éternelle, ne t'éteins jamais
Réchauffe nos cœurs, nos projets
Dans ta lumière nous trouvons l'espoir
D'un monde meilleur à construire''',
        'lienAudio': null,
      },
      {
        'numero': 8,
        'titre': 'Mélodie des Ancêtres',
        'auteur': 'Tiana Rabemananjara',
        'tonalite': 'Ré Majeur',
        'mesure': '3/4',
        'paroles': '''Verse 1:
Les voix de nos ancêtres résonnent encore
Dans le vent qui traverse les collines d'or
Leur sagesse nous guide jour après jour
Vers un avenir rempli d'amour

Refrain:
Mélodie des ancêtres, chant du passé
Enseigne-nous la voie de la vérité
Dans vos paroles nous trouvons la force
De poursuivre notre course''',
        'lienAudio': null,
      },
    ];

    for (var song in sampleSongs) {
      await db.insert('songs', song);
    }
  }
}
