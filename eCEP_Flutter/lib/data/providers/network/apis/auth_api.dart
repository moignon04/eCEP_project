import 'dart:io';
import 'package:client/app/services/local_storage.dart';
import 'package:client/data/providers/network/api_endpoint.dart';
import 'package:client/data/providers/network/api_request_representable.dart';
import 'package:client/data/providers/network/api_provider.dart';
import 'package:get/get.dart';

enum AuthType { login, register, logout }

class AuthAPI implements APIRequestRepresentable {
  final AuthType type;
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  String? role;
  final store = Get.find<LocalStorageService>();

  AuthAPI._({
    required this.type,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.role
  });

  // Login constructor
  AuthAPI.login({required String email, required String password})
      : this._(type: AuthType.login, email: email, password: password);

  // Register constructor
  AuthAPI.register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role
  }) : this._(
      type: AuthType.register,
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      role: role
  );

  // Logout constructor
  AuthAPI.logout() : this._(type: AuthType.logout);

  @override
  String get endpoint => APIEndpoint.baseURL;

  @override
  String get path {
    switch (type) {
      case AuthType.login:
        return "/login";
      case AuthType.register:
        return "/register";
      case AuthType.logout:
        return "/logout";
      default:
        return "";
    }
  }

  @override
  HTTPMethod get method {
    switch (type) {
      case AuthType.login:
      case AuthType.register:
        return HTTPMethod.post;
      case AuthType.logout:
        return HTTPMethod.post;
      default:
        return HTTPMethod.post;
    }
  }

  @override
  Map<String, String> get headers => {
    HttpHeaders.contentTypeHeader: 'application/json',
    if (type == AuthType.logout)
      HttpHeaders.authorizationHeader: 'Bearer ${store.token}',
  };

  @override
  Map<String, String>? get query => null;

  @override
  dynamic get body {
    switch (type) {
      case AuthType.login:
        return {
          "email": email,
          "password": password,
        };
      case AuthType.register:
        return {
          "email": email,
          "password": password,
          "first_name": firstName,
          "last_name": lastName,
          "role": role,
        };
      case AuthType.logout:
        return null;
      default:
        return null;
    }
  }

  @override
  String get url => endpoint + path;

  @override
  Future request() {
    return APIProvider.instance.request(this);
  }
}