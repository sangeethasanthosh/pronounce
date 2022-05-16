import 'package:happy_hearts_pet_care_services/models/unlike_modal.dart';
import 'package:happy_hearts_pet_care_services/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';

class UnlikeBloc {
  final _like = PublishSubject<UnlikeModel>();

  Observable<UnlikeModel> get likeStream => _like.stream;

  Future likeSink(String userID, String restID) async {
    // ignore: unused_local_variable
    UnlikeModel likeModal = await Repository().unlikeRepository(userID, restID);
    // _like.sink.add(likeModal);
  }

  dispose() {
    _like.close();
  }
}

final unlikeBloc = UnlikeBloc();
