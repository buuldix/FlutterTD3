import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../configs.dart';
import '../models/user.dart';
import '../result.dart';

class AuthState extends ChangeNotifier{
  User? _currentUser;
  User? get currentUser => _currentUser;
  String? _token;
  String? get token => _token;
  String? error;
  bool get isLoggedIn => currentUser!=null;


  Future<Result<User,String>> login(String username, String password) async { 
    final loginResponse = await http.post( 
      Uri.parse('${Configs.baseUrl}/auth/login'), 
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: json.encode({
        'username': username, 
        'password': password, 
      }),
    ); 
    if (loginResponse.statusCode == HttpStatus.ok) {
      _token = json.decode(loginResponse.body)['token']; 
      final userResponse = await http.get( 
        Uri.parse('${Configs.baseUrl}/users/me'), 
        headers: { 
          HttpHeaders.authorizationHeader: 'Bearer $_token', 
          HttpHeaders.contentTypeHeader: 'application/json', 
        }, 
      ); 
      if (userResponse.statusCode == HttpStatus.ok) { 
        _currentUser = User.fromJson(json.decode(userResponse.body)); 
        notifyListeners(); 
        return Result.success(_currentUser!); 
      } 

      error = 'Une erreur est survenue';
    } else{
      error = loginResponse.statusCode == HttpStatus.badRequest || 
        loginResponse.statusCode == HttpStatus.unauthorized 
        ? 'Identifiant ou mot de passe incorrect' 
        : 'Une erreur est survenue';
    }
    logout(); 
    return Result.failure(error!); 
  }
  Future<bool> signup(String username, String password) async { 

    final signupResponse = await http.post( 
      Uri.parse('${Configs.baseUrl}/auth/signup'), 
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
      }, 
      body: json.encode({
        'username': username, 
        'password': password, 
      }),
    ); 
    if (signupResponse.statusCode == HttpStatus.created) {
      return true;
    }
    return false; 



  }

  void logout(){
    _token = null;
    _currentUser = null;
    notifyListeners(); 
  }


}