import 'package:happy_hearts_pet_care_services/models/signup_model.dart';
import 'package:happy_hearts_pet_care_services/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';

class SignupBloc {
  final _signupBlocController = PublishSubject<signupModel>();

  Observable<signupModel> get signupStream => _signupBlocController.stream;

  Future<signupModel> signupSink(
    String email,
    String password,
    String username,
  ) async {
    return await Repository().signupRepository(
      email,
      password,
      username,
    );
  }

  dispose() {
    _signupBlocController.close();
  }
}

final signupBloc = SignupBloc();
