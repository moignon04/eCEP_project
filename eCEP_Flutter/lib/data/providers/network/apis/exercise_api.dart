import 'dart:io';
import 'package:client/app/services/local_storage.dart';
import 'package:client/data/providers/network/api_endpoint.dart';
import 'package:client/data/providers/network/api_request_representable.dart';
import 'package:client/data/providers/network/api_provider.dart';
import 'package:get/get.dart';

enum ExerciseActionType { getAll, getById, getByCourse, submit }

class ExerciseAPI implements APIRequestRepresentable {
  final ExerciseActionType actionType;
  final int? id;
  final int? courseId;
  final Map<String, dynamic>? answers;
  final LocalStorageService store = Get.find<LocalStorageService>();

  ExerciseAPI._({
    required this.actionType,
    this.id,
    this.courseId,
    this.answers,
  });

  ExerciseAPI.getAll() : this._(actionType: ExerciseActionType.getAll);

  ExerciseAPI.getById(int id) : this._(actionType: ExerciseActionType.getById, id: id);

  ExerciseAPI.getByCourse(int courseId) : this._(
      actionType: ExerciseActionType.getByCourse,
      courseId: courseId
  );

  ExerciseAPI.submit(int id, Map<String, dynamic> answers) : this._(
      actionType: ExerciseActionType.submit,
      id: id,
      answers: answers
  );

  @override
  String get endpoint => APIEndpoint.baseURL;

  @override
  String get path {
    switch (actionType) {
      case ExerciseActionType.getAll:
        return "/exercises";
      case ExerciseActionType.getById:
        return "/exercises/$id";
      case ExerciseActionType.getByCourse:
        return "/courses/$courseId/exercises";
      case ExerciseActionType.submit:
        return "/exercises/$id/submit";
      default:
        return "";
    }
  }

  @override
  HTTPMethod get method {
    return actionType == ExerciseActionType.submit
        ? HTTPMethod.post
        : HTTPMethod.get;
  }

  @override
  Map<String, String> get headers => {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ${store.token}',
  };

  @override
  Map<String, String>? get query => null;

  @override
  dynamic get body {
    if (actionType == ExerciseActionType.submit) {
      return {
        "answers": answers,
      };
    }
    return null;
  }

  @override
  String get url => endpoint + path;

  @override
  Future request() {
    return APIProvider.instance.request(this);
  }
}