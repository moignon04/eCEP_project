import 'dart:io';
import 'package:client/app/services/local_storage.dart';
import 'package:client/data/providers/network/api_endpoint.dart';
import 'package:client/data/providers/network/api_request_representable.dart';
import 'package:client/data/providers/network/api_provider.dart';
import 'package:get/get.dart';

enum CourseActionType { getAll, getById, search, getBySubject }

class CourseAPI implements APIRequestRepresentable {
  final CourseActionType actionType;
  final int? id;
  final String? searchTerm;
  final String? subject;
  final LocalStorageService store = Get.find<LocalStorageService>();

  CourseAPI._({
    required this.actionType,
    this.id,
    this.searchTerm,
    this.subject,
  });

  CourseAPI.getAll() : this._(actionType: CourseActionType.getAll);

  CourseAPI.getById(int id) : this._(actionType: CourseActionType.getById, id: id);

  CourseAPI.search(String term) : this._(actionType: CourseActionType.search, searchTerm: term);

  CourseAPI.getBySubject(String subject) : this._(actionType: CourseActionType.getBySubject, subject: subject);

  @override
  String get endpoint => APIEndpoint.baseURL;

  @override
  String get path {
    switch (actionType) {
      case CourseActionType.getAll:
        return "/courses";
      case CourseActionType.getById:
        return "/courses/$id";
      case CourseActionType.search:
        return "/courses/search";
      case CourseActionType.getBySubject:
        return "/courses/subject/$subject";
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
  Map<String, String>? get query {
    if (actionType == CourseActionType.search && searchTerm != null) {
      return {
        "query": searchTerm!,
      };
    }
    return null;
  }

  @override
  dynamic get body => null;

  @override
  String get url => endpoint + path;

  @override
  Future request() {
    return APIProvider.instance.request(this);
  }
}