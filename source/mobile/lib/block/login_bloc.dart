import 'package:happy_hearts_pet_care_services/models/login_modal.dart';
import 'package:happy_hearts_pet_care_services/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  final _loginBlocController = PublishSubject<LoginModel>();

  Observable<LoginModel> get loginStream => _loginBlocController.stream;

  Future<LoginModel> loginSink(String username, String password) async {
    return await Repository().loginApiRepository(username, password);
  }

  dispose() {
    _loginBlocController.close();
  }
}

final loginBloc = LoginBloc();
