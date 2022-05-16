import 'package:happy_hearts_pet_care_services/models/DyLink_model.dart';
import 'package:happy_hearts_pet_care_services/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';

class DyLinkBloc {
  final allres = PublishSubject<DynLinkModel>();

  Observable<DynLinkModel> get dyLinkStream => allres.stream;

  Future allresSink() async {
    DynLinkModel nearbyModal = await Repository().dyLinkRepository();
    allres.sink.add(nearbyModal);
  }

  dispose() {
    allres.close();
  }
}

final dylink = DyLinkBloc();
