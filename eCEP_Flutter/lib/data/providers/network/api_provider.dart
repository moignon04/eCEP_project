import 'dart:async';
import 'dart:io';
import 'package:client/app/services/local_storage.dart';
import 'package:client/data/providers/network/api_request_representable.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';

class APIProvider {
  static const requestTimeOut = Duration(seconds: 30);
  final _client = GetConnect(timeout: requestTimeOut);

  static final _singleton = APIProvider();
  static APIProvider get instance => _singleton;
  final store = Get.find<LocalStorageService>();

  Future request(APIRequestRepresentable request) async {
    try {
      final response = await _client.request(
        request.url,
        request.method.string,
        headers: request.headers,
        query: request.query,
        body: request.body,
      );
      return _returnResponse(response);
    } on TimeoutException catch (_) {
      throw TimeOutException(null);
    } on SocketException {
      throw FetchDataException('Pas de connexion internet');
    }
  }

  dynamic _returnResponse(Response<dynamic> response) {
    switch (response.statusCode) {
      case 200:
        return _handleSuccessResponse(response.body);
      case 400:
        throw BadRequestException(response.body['message'], response.body['errors']);
      case 401:
        throw UnauthorisedException(response.body['message'], response.body['errors']);
      case 403:
        throw AuthenticationException(response.body['message'], response.body['errors']);
      case 404:
        throw FetchDataException(response.body['message']);
      case 422:
        throw ValidationException(response.body['message'], response.body['errors']);
      case 500:
        throw _handleErrorResponse(response.body, response.statusCode ?? 500);
      default:
        throw FetchDataException('Problème de connexion internet');
    }
  }

  Map<String, dynamic> _handleErrorResponse(dynamic body, int statusCode) {
    return {
      'status': false,
      'code': statusCode,
      'message': body['message'] ?? 'Une erreur est survenue',
      'errors': body['errors'] ?? null
    };
  }

  Map<String, dynamic> _handleSuccessResponse(dynamic body) {
    if (body is Map && body.containsKey('status') && body['status'] == true) {
      return {
        'status': body['status'],
        'message': body['message'],
        'code': body['code'],
        'datas': body['datas'] ?? [],
      };
    }
    return body;
  }
}

// Classes d'exception
class AppException implements Exception {
  final code;
  final message;
  final errors;

  AppException({this.code, this.message, this.errors});

  @override
  String toString() {
    return "[$code]: $message \n ${errors != null ? errors : 'Aucun détail fourni'}";
  }

  Map<String, dynamic> toObject() {
    return {
      'code': code,
      'message': message,
      'errors': errors,
    };
  }
}

class FetchDataException extends AppException {
  FetchDataException(String message)
      : super(
    code: "fetch-data",
    message: message,
    errors: null,
  );
}

class BadRequestException extends AppException {
  BadRequestException(String message, dynamic details)
      : super(
    code: "invalid-request",
    message: message,
    errors: details,
  );
}

class UnauthorisedException extends AppException {
  UnauthorisedException(String message, dynamic details)
      : super(
    code: "unauthorised",
    message: message,
    errors: details,
  );
}

class InvalidInputException extends AppException {
  InvalidInputException(String? message, dynamic details)
      : super(
    code: "invalid-input",
    message: message,
    errors: details,
  );
}

class AuthenticationException extends AppException {
  AuthenticationException(String? message, dynamic details)
      : super(
    code: "authentication-failed",
    message: message,
    errors: details,
  );
}

class TimeOutException extends AppException {
  TimeOutException(String? details)
      : super(
    code: "request-timeout",
    message: "Serveur injoignable",
    errors: details,
  );
}

class ValidationException extends AppException {
  ValidationException(String? message, Map<String, dynamic>? details)
      : super(
    code: "validation-error",
    message: message,
    errors: details,
  );
}