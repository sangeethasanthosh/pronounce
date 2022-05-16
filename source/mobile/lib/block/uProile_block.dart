import 'package:happy_hearts_pet_care_services/models/uProfileModal.dart';
import 'package:happy_hearts_pet_care_services/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';

class UprofileBloc {
  final _signupBlocController = PublishSubject<UpdatePro>();

  Observable<UpdatePro> get signupStream => _signupBlocController.stream;

  Future<UpdatePro> uProfileSink(
    String email,
    String username,
    String userID,
  ) async {
    return await Repository().uProfile(email, username, userID);
  }

  dispose() {
    _signupBlocController.close();
  }
}

final uProfileBloc = UprofileBloc();
