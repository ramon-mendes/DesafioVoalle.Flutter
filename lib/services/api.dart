import 'dart:convert';
import 'dart:developer';

import 'package:desafio_voalle/apimodels/product.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:desafio_voalle/apimodels/user.dart';
import 'package:desafio_voalle/services/login_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

const API_URL = 'desafiovoallebackend.azurewebsites.net';
const PREFERENCES_KEY = 'logged_user';

enum ELoginResult {
  NO_INTERNET,
  LOGIN_INVALID,
  ERROR,
  OK,
}

enum ERegisterResult {
  NO_INTERNET,
  EMAIL_ALREADY_EXISTS,
  ERROR,
  OK,
}

class API {
  static String? _token;
  static Map<String, String>? _headers;
  static late User loggedUser;
  BuildContext? _context;

  API();
  API.of(this._context);

  static void _loadConfigs() {
    _token = loggedUser.token;
    _headers = {'Authorization': 'Bearer $_token'};
  }

  static Map<String, String> _jsonHeader() {
    var copy = Map<String, String>.from(_headers!);
    copy['Content-Type'] = 'application/json';
    return copy;
  }

  Future<bool> _checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      final snackBar = SnackBar(
        content: Text('Não foi possível completar esta ação. Verifique sua conexão com a internet.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(_context!).showSnackBar(snackBar);
      return false;
    }
    return true;
  }

  void _catchException() {
    final snackBar = SnackBar(
      content: Text('Não foi possível completar esta ação.'),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(_context!).showSnackBar(snackBar);
    throw Exception(); // so the Future don't resolves
  }

  static Future<bool> isLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(PREFERENCES_KEY)) {
      loggedUser = User.fromJson(jsonDecode(prefs.getString(PREFERENCES_KEY)!));
      _loadConfigs();
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    _token = null;
    _headers = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<ELoginResult> login(String email, String pwd) async {
    if (!await _checkInternet()) return ELoginResult.NO_INTERNET;

    try {
      final queryParameters = {
        'email': email,
        'pwd': pwd,
      };
      final response = await http.get(Uri.https(API_URL, "api/user/login", queryParameters));

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(PREFERENCES_KEY, response.body);

        loggedUser = User.fromJson(jsonDecode(response.body));
        _loadConfigs();
        await Provider.of<LoginNotifier>(_context!, listen: false).logInByUserPwd();
        return ELoginResult.OK;
      } else {
        return ELoginResult.LOGIN_INVALID;
      }
    } catch (e) {}
    return ELoginResult.ERROR;
  }

  Future<ELoginResult> googleLogin(String idtoken, String email, String name) async {
    if (!await _checkInternet()) return ELoginResult.NO_INTERNET;

    try {
      final queryParameters = {
        'idtoken': idtoken,
        'email': email,
        'name': name,
      };
      final response = await http.get(Uri.https(API_URL, "api/user/googlelogin", queryParameters));

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(PREFERENCES_KEY, response.body);

        loggedUser = User.fromJson(jsonDecode(response.body));
        _loadConfigs();
        return ELoginResult.OK;
      } else {
        return ELoginResult.LOGIN_INVALID;
      }
    } catch (e) {
      debugger();
    }
    return ELoginResult.ERROR;
  }

  Future<ERegisterResult> userRegister(String name, String email, String pwd) async {
    if (!await _checkInternet()) return ERegisterResult.NO_INTERNET;

    try {
      final queryParameters = {
        'name': name,
        'email': email,
        'pwd': pwd,
      };
      final response = await http.get(Uri.https(API_URL, "api/user/register", queryParameters));

      if (response.statusCode == 200) {
        return ERegisterResult.OK;
      } else if (response.statusCode == 201) {
        return ERegisterResult.EMAIL_ALREADY_EXISTS;
      }
    } catch (e) {}
    return ERegisterResult.ERROR;
  }

  Future<List<Product>?> productList() async {
    if (!await _checkInternet()) throw Exception();

    try {
      final response = await http.get(Uri.https(API_URL, "api/product/list"), headers: _headers);
      if (response.statusCode == 200) {
        var all = jsonDecode(response.body);
        var list = <Product>[];
        for (var item in all) {
          list.add(Product.fromJson(item));
        }
        return list;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      _catchException();
    }
    return null;
  }

  Future<void> productCreate(Product product) async {
    if (!await _checkInternet()) throw Exception();

    try {
      final body = product.toJson();
      body.remove('id'); // fuck

      final response = await http.post(
        Uri.https(API_URL, "api/product/create"),
        headers: _jsonHeader(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      _catchException();
    }
  }

  Future<void> productEdit(Product product) async {
    if (!await _checkInternet()) throw Exception();

    try {
      final response = await http.post(
        Uri.https(API_URL, "api/product/edit"),
        headers: _jsonHeader(),
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      _catchException();
    }
  }

  Future<void> productRemove(String id) async {
    if (!await _checkInternet()) throw Exception();

    try {
      final response = await http.get(Uri.https(API_URL, "api/product/remove", {'id': id}), headers: _headers);
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      _catchException();
    }
  }
}
