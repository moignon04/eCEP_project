import 'dart:io';
import 'package:client/app/services/local_storage.dart';
import 'package:client/data/providers/network/api_endpoint.dart';
import 'package:client/data/providers/network/api_request_representable.dart';
import 'package:client/data/providers/network/api_provider.dart';
import 'package:get/get.dart';

enum BadgeActionType { getAll, getByStudent }

class BadgeAPI implements APIRequestRepresentable {
  final BadgeActionType actionType;
  final int? studentId;
  final LocalStorageService store = Get.find<LocalStorageService>();

  BadgeAPI._({
    required this.actionType,
    this.studentId,
  });

  BadgeAPI.getAll() : this._(actionType: BadgeActionType.getAll);

  BadgeAPI.getByStudent(int studentId) : this._(
      actionType: BadgeActionType.getByStudent,
      studentId: studentId
  );

  @override
  String get endpoint => APIEndpoint.baseURL;

  @override
  String get path {
    switch (actionType) {
      case BadgeActionType.getAll:
        return "/badges";
      case BadgeActionType.getByStudent:
        return "/students/$studentId/badges";
      default:
        return "";
    }
  }

  @override
  HTTPMethod get method {
    return HTTPMethod.get;
  }

  @override
  Map<String, String> get headers => {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ${store.token}',
  };

  @override
  Map<String, String>? get query => null;

  @override
  dynamic get body => null;

  @override
  String get url => endpoint + path;

  @override
  Future request() {
    return APIProvider.instance.request(this);
  }
}