import 'package:happy_hearts_pet_care_services/models/profile_model.dart';
import 'package:happy_hearts_pet_care_services/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc {
  final _profile = PublishSubject<ProfileModel>();

  Observable<ProfileModel> get profileStream => _profile.stream;

  Future profileSink(String userID) async {
    ProfileModel profileModal = await Repository().profileRepository(userID);
    _profile.sink.add(profileModal);
  }

  dispose() {
    _profile.close();
  }
}

final profileBloc = ProfileBloc();
