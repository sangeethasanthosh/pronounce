import 'package:happy_hearts_pet_care_services/models/categories_model.dart';
import 'package:happy_hearts_pet_care_services/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';

class AllCateBloc {
  final allcate = PublishSubject<cateModel>();

  Observable<cateModel> get allcateStream => allcate.stream;

  Future allcateSink() async {
    cateModel nearbyModal = await Repository().allcateRepository();
    allcate.sink.add(nearbyModal);
  }

  dispose() {
    allcate.close();
  }
}

final allcate = AllCateBloc();
