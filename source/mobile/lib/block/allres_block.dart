import 'package:happy_hearts_pet_care_services/models/allrestaurent_model.dart';
import 'package:happy_hearts_pet_care_services/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';

class AllRestaurentBloc {
  final allres = PublishSubject<allResModel>();

  Observable<allResModel> get allresStream => allres.stream;

  Future allresSink() async {
    allResModel nearbyModal = await Repository().allresRepository();
    allres.sink.add(nearbyModal);
  }

  dispose() {
    allres.close();
  }
}

final allres = AllRestaurentBloc();
