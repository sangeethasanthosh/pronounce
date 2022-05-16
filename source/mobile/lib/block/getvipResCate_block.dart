import 'package:happy_hearts_pet_care_services/models/getvipresCate_model.dart';
import 'package:happy_hearts_pet_care_services/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';

class GetVipCateBloc {
  final getVipResCate = PublishSubject<VipResCateModel>();

  Observable<VipResCateModel> get getVipResStream => getVipResCate.stream;

  Future getVipResCateSink(String catId) async {
    VipResCateModel nearbyModal =
        await Repository().getVipCateRepository(catId);
    getVipResCate.sink.add(nearbyModal);
  }

  dispose() {
    getVipResCate.close();
  }
}

final getVipCatebloc = GetVipCateBloc();
