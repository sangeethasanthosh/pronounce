import 'package:happy_hearts_pet_care_services/constant/global.dart';
import 'package:http/http.dart' as http;

class AddReviewApi {
  Future addReviewApi(
    String userID,
    String resID,
    String ratings,
    String text,
  ) async {
    await http.post('${baseUrl()}/give_review', body: {
      'user_id': userID,
      'res_id': resID,
      'ratings': ratings,
      'text': text,
    }).then((response) {
      if (response.statusCode == 200) {
        // ToastActive().showToast(msg: 'Review added');
      } else {
        // ToastActive().showToast(msg: 'Something went wrong');
      }
    }).catchError((onError) {
      print(onError);
    });
  }
}
