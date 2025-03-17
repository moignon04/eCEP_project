import 'dart:io';
import 'package:client/app/services/local_storage.dart';
import 'package:client/data/providers/network/api_endpoint.dart';
import 'package:client/data/providers/network/api_request_representable.dart';
import 'package:client/data/providers/network/api_provider.dart';
import 'package:get/get.dart';

enum ProgressActionType { getByStudent, getByCourse, getAll }

class ProgressAPI implements APIRequestRepresentable {
  final ProgressActionType actionType;
  final int? studentId;
  final int? courseId;
  final LocalStorageService store = Get.find<LocalStorageService>();

  ProgressAPI._({
    required this.actionType,
    this.studentId,
    this.courseId,
  });

  ProgressAPI.getByStudent(int studentId) : this._(
      actionType: ProgressActionType.getByStudent,
      studentId: studentId
  );

  ProgressAPI.getByCourse(int courseId) : this._(
      actionType: ProgressActionType.getByCourse,
      courseId: courseId
  );

  ProgressAPI.getAll() : this._(actionType: ProgressActionType.getAll);

  @override
  String get endpoint => APIEndpoint.baseURL;

  @override
  String get path {
    switch (actionType) {
      case ProgressActionType.getByStudent:
        return "/students/$studentId/progress";
      case ProgressActionType.getByCourse:
        return "/courses/$courseId/progress";
      case ProgressActionType.getAll:
        return "/progress";
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