import 'package:happy_hearts_pet_care_services/models/favourite_restaurent_modal.dart';
import 'package:happy_hearts_pet_care_services/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';

class FavouriteBloc {
  final _favourite = PublishSubject<FavouriteModal>();

  Observable<FavouriteModal> get favouriteStream => _favourite.stream;

  Future favouriteSink(String userID) async {
    FavouriteModal favouriteModal =
        await Repository().favouriteRepository(userID);
    _favourite.sink.add(favouriteModal);
  }

  dispose() {
    _favourite.close();
  }
}

final favouriteBloc = FavouriteBloc();
