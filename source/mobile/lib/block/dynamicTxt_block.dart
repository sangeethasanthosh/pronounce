import 'package:happy_hearts_pet_care_services/models/dynamicTxtModel.dart';
import 'package:happy_hearts_pet_care_services/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';

class AllDynamicTxtBloc {
  final allres = PublishSubject<DyamicTxtModel>();

  Observable<DyamicTxtModel> get allresStream => allres.stream;

  Future allresSink() async {
    DyamicTxtModel nearbyModal = await Repository().allDynamicTxtRepository();
    allres.sink.add(nearbyModal);
  }

  dispose() {
    allres.close();
  }
}

final allres = AllDynamicTxtBloc();
