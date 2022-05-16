import 'dart:convert';

import 'package:happy_hearts_pet_care_services/models/like_modal.dart';
import 'package:http/http.dart' as http;

class LikeApi {
  Future<LikeModal> likeApi(String userID, String restID) async {
    var responseJson;
    await http.post('http://primocysapp.com/business/api/likeRes', body: {
      'user_id': userID,
      'res_id': restID,
    }).then((response) {
      responseJson = _returnResponse(response);
    }).catchError((onError) {
      print(onError);
    });
    return LikeModal.fromJson(responseJson);
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);

        return responseJson;
      case 400:
        throw Exception(response.body.toString());
      case 401:
        throw Exception(response.body.toString());
      case 403:
        throw Exception(response.body.toString());
      case 500:
      default:
        throw Exception(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
