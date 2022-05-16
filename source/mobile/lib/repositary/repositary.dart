import 'dart:io';

import 'package:happy_hearts_pet_care_services/models/DyLink_model.dart';
import 'package:happy_hearts_pet_care_services/models/allrestaurent_model.dart';
import 'package:happy_hearts_pet_care_services/models/categories_model.dart';
import 'package:happy_hearts_pet_care_services/models/dynamicTxtModel.dart';
import 'package:happy_hearts_pet_care_services/models/favourite_restaurent_modal.dart';
import 'package:happy_hearts_pet_care_services/models/getResModel.dart';
import 'package:happy_hearts_pet_care_services/models/get_review.dart';
import 'package:happy_hearts_pet_care_services/models/getvipresCate_model.dart';
import 'package:happy_hearts_pet_care_services/models/google_model.dart';
import 'package:happy_hearts_pet_care_services/models/like_modal.dart';
import 'package:happy_hearts_pet_care_services/models/login_modal.dart';
import 'package:happy_hearts_pet_care_services/models/nearByStore.dart';
import 'package:happy_hearts_pet_care_services/models/profile_model.dart';
import 'package:happy_hearts_pet_care_services/models/search_modal.dart';
import 'package:happy_hearts_pet_care_services/models/signup_model.dart';
import 'package:happy_hearts_pet_care_services/models/sorting_model.dart';
import 'package:happy_hearts_pet_care_services/models/uProfileImg.dart';
import 'package:happy_hearts_pet_care_services/models/uProfileModal.dart';
import 'package:happy_hearts_pet_care_services/models/unlike_modal.dart';
import 'package:happy_hearts_pet_care_services/provider/allcate_api.dart';
import 'package:happy_hearts_pet_care_services/provider/allres_api.dart';
import 'package:happy_hearts_pet_care_services/provider/dyLink_api.dart';
import 'package:happy_hearts_pet_care_services/provider/dynamicTxt_api.dart';
import 'package:happy_hearts_pet_care_services/provider/favourite_api.dart';
import 'package:happy_hearts_pet_care_services/provider/getRes_api.dart';
import 'package:happy_hearts_pet_care_services/provider/getVipResCate_api.dart';
import 'package:happy_hearts_pet_care_services/provider/get_review_api.dart';
import 'package:happy_hearts_pet_care_services/provider/google_api.dart';
import 'package:happy_hearts_pet_care_services/provider/like_api.dart';
import 'package:happy_hearts_pet_care_services/provider/login_api.dart';
import 'package:happy_hearts_pet_care_services/provider/nearByStore_api.dart';
import 'package:happy_hearts_pet_care_services/provider/profile_api.dart';
import 'package:happy_hearts_pet_care_services/provider/search_api.dart';
import 'package:happy_hearts_pet_care_services/provider/signup_api.dart';
import 'package:happy_hearts_pet_care_services/provider/sorting_api.dart';
import 'package:happy_hearts_pet_care_services/provider/uProfile.dart';
import 'package:happy_hearts_pet_care_services/provider/uProfileImg_api.dart';
import 'package:happy_hearts_pet_care_services/provider/unlike_api.dart';

class Repository {
  Future<LoginModel> loginApiRepository(
      String username, String password) async {
    return await LoginApi().loginApi(username, password);
  }

  Future<signupModel> signupRepository(
    String email,
    String password,
    String username,
  ) async {
    return await SignupApi().signupApi(
      email,
      password,
      username,
    );
  }

  Future<allResModel> allresRepository() async {
    return await AllResApi().resApi();
  }

  Future<GoogleModel> googleRepository(
      String username, String email, String type) async {
    return await GoogleApi().googleApi(username, email, type);
  }

  Future<LikeModal> likeRepository(String userID, String restID) async {
    return await LikeApi().likeApi(userID, restID);
  }

  Future<UnlikeModel> unlikeRepository(String userID, String restID) async {
    return await UnlikeApi().unlikeApi(userID, restID);
  }

  Future<FavouriteModal> favouriteRepository(String userID) async {
    return await FavouriteApi().favouriteApi(userID);
  }

  Future<GetRestReview> getReviewRepository(String restID) async {
    return await RestReviewApi().restReviewApi(restID);
  }

  Future<SearchModal> searchRepository(String text) async {
    return await SearchApi().searchApi(text);
  }

  Future<cateModel> allcateRepository() async {
    return await AllCateApi().cateApi();
  }

  Future<GetResModel> getResRepository(String userID) async {
    return await GetResApi().getResApi(userID);
  }

  Future<VipResCateModel> getVipCateRepository(String catId) async {
    return await AllVipResCateApi().getVipResCateApi(catId);
  }

  Future<SortingModel> sortingRepository() async {
    return await SortingApi().getResApi();
  }

  Future<NearByStores> allNearByStoreRepository(String catId) async {
    return await NearByStoreApi().resApi(catId);
  }

  Future<DyamicTxtModel> allDynamicTxtRepository() async {
    return await DynamicTxtApi().txtApi();
  }

  Future<DynLinkModel> dyLinkRepository() async {
    return await DyLinkApi().dylinkApi();
  }

  Future<ProfileModel> profileRepository(String userID) async {
    return await ProfileApi().profileApi(userID);
  }

  Future<UpdateProImg> uProfileImg(
      String email, String username, File image, String id) async {
    return await UprofileImgApi().uProfileimgApi(email, username, image, id);
  }

  Future<UpdatePro> uProfile(String email, String username, String id) async {
    return await UprofileApi().uProfileApi(email, username, id);
  }
}
