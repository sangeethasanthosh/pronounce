import 'dart:io';

import 'package:happy_hearts_pet_care_services/models/uProfileImg.dart';
import 'package:happy_hearts_pet_care_services/repositary/repositary.dart';
import 'package:rxdart/rxdart.dart';

class UprofileImgBloc {
  final _signupBlocController = PublishSubject<UpdateProImg>();

  Observable<UpdateProImg> get signupStream => _signupBlocController.stream;

  Future<UpdateProImg> uProfileImgSink(
    String email,
    String username,
    File image,
    String userID,
  ) async {
    return await Repository().uProfileImg(email, username, image, userID);
  }

  dispose() {
    _signupBlocController.close();
  }
}

final uProfileImgBloc = UprofileImgBloc();
