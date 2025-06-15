import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Initialiser sqflite_ffi pour les tests
  setUpAll(() {
    // Initialiser FFI
    sqfliteFfiInit();
    // Changer la factory de base de données
    databaseFactory = databaseFactoryFfi;
  });

  group('Database Tests', () {
    late Database db;

    setUp(() async {
      // Créer une base de données en mémoire pour les tests
      db = await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE users(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              email TEXT UNIQUE,
              password TEXT,
              name TEXT
            )
          ''');
        },
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('Insert and retrieve user', () async {
      // Insérer un utilisateur de test
      final id = await db.insert('users', {
        'email': 'test@test.com',
        'password': 'password123',
        'name': 'Test User'
      });

      // Vérifier que l'insertion a réussi
      expect(id, 1);

      // Récupérer l'utilisateur
      final List<Map<String, dynamic>> users = await db.query('users');
      
      // Vérifier les données
      expect(users.length, 1);
      expect(users[0]['email'], 'test@test.com');
      expect(users[0]['name'], 'Test User');
    });

    test('Unique email constraint', () async {
      // Insérer le premier utilisateur
      await db.insert('users', {
        'email': 'test@test.com',
        'password': 'password123',
        'name': 'Test User'
      });

      // Essayer d'insérer un utilisateur avec le même email
      try {
        await db.insert('users', {
          'email': 'test@test.com',
          'password': 'password456',
          'name': 'Another User'
        });
        fail('Should have thrown an exception for duplicate email');
      } catch (e) {
        expect(e, isA<DatabaseException>());
      }
    });

    test('Update user', () async {
      // Insérer un utilisateur
      final id = await db.insert('users', {
        'email': 'test@test.com',
        'password': 'password123',
        'name': 'Test User'
      });

      // Mettre à jour l'utilisateur
      await db.update(
        'users',
        {'name': 'Updated Name'},
        where: 'id = ?',
        whereArgs: [id],
      );

      // Vérifier la mise à jour
      final List<Map<String, dynamic>> users = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );

      expect(users[0]['name'], 'Updated Name');
    });

    test('Delete user', () async {
      // Insérer un utilisateur
      final id = await db.insert('users', {
        'email': 'test@test.com',
        'password': 'password123',
        'name': 'Test User'
      });

      // Supprimer l'utilisateur
      await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );

      // Vérifier la suppression
      final List<Map<String, dynamic>> users = await db.query('users');
      expect(users.length, 0);
    });
  });
} 