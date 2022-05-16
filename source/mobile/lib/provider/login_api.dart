import 'dart:convert';

import 'package:happy_hearts_pet_care_services/block/handleResponse.dart';
import 'package:happy_hearts_pet_care_services/constant/global.dart';
import 'package:happy_hearts_pet_care_services/models/login_modal.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  Future<LoginModel> loginApi(String username, String password) async {
    var responseJson;
    await http.post('${baseUrl()}/login', body: {
      'email': username,
      'password': password,
    }).then((response) {
      responseJson = _returnResponse(response);
    }).catchError((onError) {
      print(onError);
    });
    return LoginModel.fromJson(responseJson);
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        handleResponse.handleResponseSink(true);
        return responseJson;
      case 400:
        handleResponse.handleResponseSink(false);
        throw Exception(response.body.toString());
      case 401:
        handleResponse.handleResponseSink(false);
        throw Exception(response.body.toString());
      case 403:
        handleResponse.handleResponseSink(false);
        throw Exception(response.body.toString());
      case 500:
      default:
        handleResponse.handleResponseSink(false);
        throw Exception(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
