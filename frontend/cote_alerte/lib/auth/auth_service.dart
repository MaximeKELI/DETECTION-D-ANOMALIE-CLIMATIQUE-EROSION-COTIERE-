import 'dart:async';
import 'database_service.dart';

class AuthService {
  final DatabaseService _databaseService = DatabaseService();
  final _authStateController = StreamController<bool>.broadcast();

  Stream<bool> get authStateChanges => _authStateController.stream;

  Future<bool> signIn(String email, String password) async {
    final user = await _databaseService.loginUser(email, password);
    if (user != null) {
      _authStateController.add(true);
      return true;
    }
    return false;
  }

  Future<bool> signUp(String email, String password, String name) async {
    final success = await _databaseService.registerUser(email, password, name);
    if (success) {
      _authStateController.add(true);
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    await _databaseService.logout();
    _authStateController.add(false);
  }

  Future<bool> isLoggedIn() async {
    return await _databaseService.isLoggedIn();
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    return await _databaseService.getCurrentUser();
  }

  void dispose() {
    _authStateController.close();
  }
}