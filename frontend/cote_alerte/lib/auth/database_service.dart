import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cote_alerte.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT,
        name TEXT
      )
    ''');
  }

  // Méthodes d'authentification
  Future<bool> registerUser(String email, String password, String name) async {
    print('Tentative d\'enregistrement : email=$email, password=$password, name=$name');
    try {
      final db = await database;
      await db.insert('users', {
        'email': email,
        'password': password, // Dans une vraie application, il faudrait hasher le mot de passe
        'name': name,
      });
      print('Utilisateur enregistré avec succès');
      return true;
    } catch (e) {
      print('Erreur lors de l\'enregistrement :');
      print(e);
      return false;
    }
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    print('Tentative de connexion : email=$email');
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );

      if (maps.isNotEmpty) {
        final user = maps.first;
        print('Utilisateur trouvé : ${user['email']}');
        // Stocker l'ID de l'utilisateur dans SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', user['id'].toString());
        await prefs.setString('user_email', user['email']);
        await prefs.setString('user_name', user['name']);
        return user;
      }
      print('Aucun utilisateur trouvé avec ces identifiants');
      return null;
    } catch (e) {
      print('Erreur lors de la connexion :');
      print(e);
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_id');
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (await isLoggedIn()) {
      return {
        'id': prefs.getString('user_id'),
        'email': prefs.getString('user_email'),
        'name': prefs.getString('user_name'),
      };
    }
    return null;
  }
} 