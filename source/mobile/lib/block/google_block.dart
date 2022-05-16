import 'package:happy_hearts_pet_care_services/models/google_model.dart';
import 'package:happy_hearts_pet_care_services/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';


class GoogleBloc {
  final _googleBlocController = PublishSubject<GoogleModel>();

  Observable<GoogleModel> get googleStream => _googleBlocController.stream;

  Future<GoogleModel> googleSink(
  String username,
  String email,
  String type,
    ) async {
    return await Repository()
        .googleRepository(username,email, type);
  }

  dispose() {
    _googleBlocController.close();
  }
}

final googleBloc =GoogleBloc();
