import 'package:happy_hearts_pet_care_services/models/sorting_model.dart';
import 'package:happy_hearts_pet_care_services/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';

class SortingBloc {
  final getRes = PublishSubject<SortingModel>();

  Observable<SortingModel> get sortingStream => getRes.stream;

  Future getResSink() async {
    SortingModel nearbyModal = await Repository().sortingRepository();
    getRes.sink.add(nearbyModal);
  }

  dispose() {
    getRes.close();
  }
}

final sortingbloc = SortingBloc();
