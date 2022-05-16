import 'package:happy_hearts_pet_care_services/models/like_modal.dart';
import 'package:happy_hearts_pet_care_services/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';

class LikeBloc {
  final _like = PublishSubject<LikeModal>();

  Observable<LikeModal> get likeStream => _like.stream;

  Future likeSink(String userID, String restID) async {
    // ignore: unused_local_variable
    LikeModal likeModal = await Repository().likeRepository(userID, restID);
    // _like.sink.add(likeModal);
  }

  dispose() {
    _like.close();
  }
}

final likeBloc = LikeBloc();
