// lib/core/providers/session_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/user_model.dart';
import 'dart:convert';

class SessionNotifier extends StateNotifier<UserModel?> {
  SessionNotifier() : super(null) {
    _loadUserSession();
  }

  static const _userKey = 'user_session';

  Future<void> _loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      final userData = jsonDecode(userJson);
      state = UserModel.fromJson(userData);
    }
  }

  Future<void> updateSessionWithUserModel(UserModel user) async {
    state = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<void> clearSession() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
