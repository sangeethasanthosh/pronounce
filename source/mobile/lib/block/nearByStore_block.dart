import 'package:happy_hearts_pet_care_services/models/nearByStore.dart';
import 'package:happy_hearts_pet_care_services/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';

class NearByStoreBloc {
  final allres = PublishSubject<NearByStores>();

  Observable<NearByStores> get allresStream => allres.stream;

  Future allresSink(String catId) async {
    NearByStores nearbyModal =
        await Repository().allNearByStoreRepository(catId);
    allres.sink.add(nearbyModal);
  }

  dispose() {
    allres.close();
  }
}

final allres = NearByStoreBloc();
