import 'dart:convert';
import 'package:happy_hearts_pet_care_services/constant/global.dart';
import 'package:happy_hearts_pet_care_services/models/getvipresCate_model.dart';
import 'package:http/http.dart' as http;

class AllVipResCateApi {
  Future<VipResCateModel> getVipResCateApi(String catId) async {
    var responseJson;
    await http.post('${baseUrl()}/get_all_cat_byid', body: {
      'cat_id': catId,
    }).then((response) {
      responseJson = _returnResponse(response);
    }).catchError((onError) {
      print(onError);
    });
    return VipResCateModel.fromJson(responseJson);
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

final allviprestcateapi = AllVipResCateApi();
