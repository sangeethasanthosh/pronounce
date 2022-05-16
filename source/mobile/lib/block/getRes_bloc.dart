
import 'package:happy_hearts_pet_care_services/models/getResModel.dart';
import 'package:happy_hearts_pet_care_services/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';


class GetResBloc {
  final getRes = PublishSubject<GetResModel>();

  Observable<GetResModel> get getResStream => getRes.stream;

  Future getResSink(String userID) async {
    GetResModel nearbyModal = await Repository().getResRepository(userID);
    getRes.sink.add(nearbyModal);
  }

  dispose() {
    getRes.close();
  }
}

final getResbloc = GetResBloc();
