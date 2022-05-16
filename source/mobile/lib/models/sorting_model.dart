class SortingModel {
  int status;
  String msg;
  List<RestaurantsSort> restaurants;

  SortingModel({this.status, this.msg, this.restaurants});

  SortingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['restaurants'] != null) {
      restaurants = new List<RestaurantsSort>();
      json['restaurants'].forEach((v) {
        restaurants.add(new RestaurantsSort.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.restaurants != null) {
      data['restaurants'] = this.restaurants.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RestaurantsSort {
  String resId;
  String catId;
  String resName;
  String resNameU;
  String resDesc;
  String resDescU;
  String resWebsite;
  ResImage resImage;
  String logo;
  String resPhone;
  String resAddress;
  String resIsOpen;
  String resStatus;
  String resCreateDate;
  String resRatings;
  String status;
  String resVideo;
  String resUrl;
  String mfo;
  String lat;
  String lon;
  String vid;
  String cName;
  int reviewCount;
  List<String> allImage;

  RestaurantsSort(
      {this.resId,
      this.catId,
      this.resName,
      this.resNameU,
      this.resDesc,
      this.resDescU,
      this.resWebsite,
      this.resImage,
      this.logo,
      this.resPhone,
      this.resAddress,
      this.resIsOpen,
      this.resStatus,
      this.resCreateDate,
      this.resRatings,
      this.status,
      this.resVideo,
      this.resUrl,
      this.mfo,
      this.lat,
      this.lon,
      this.vid,
      this.cName,
      this.reviewCount,
      this.allImage});

  RestaurantsSort.fromJson(Map<String, dynamic> json) {
    resId = json['res_id'];
    catId = json['cat_id'];
    resName = json['res_name'];
    resNameU = json['res_name_u'];
    resDesc = json['res_desc'];
    resDescU = json['res_desc_u'];
    resWebsite = json['res_website'];
    resImage = json['res_image'] != null
        ? new ResImage.fromJson(json['res_image'])
        : null;
    logo = json['logo'];
    resPhone = json['res_phone'];
    resAddress = json['res_address'];
    resIsOpen = json['res_isOpen'];
    resStatus = json['res_status'];
    resCreateDate = json['res_create_date'];
    resRatings = json['res_ratings'];
    status = json['status'];
    resVideo = json['res_video'];
    resUrl = json['res_url'];
    mfo = json['mfo'];
    lat = json['lat'];
    lon = json['lon'];
    vid = json['vid'];
    cName = json['c_name'];
    reviewCount = json['review_count'];
    allImage = json['all_image'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res_id'] = this.resId;
    data['cat_id'] = this.catId;
    data['res_name'] = this.resName;
    data['res_name_u'] = this.resNameU;
    data['res_desc'] = this.resDesc;
    data['res_desc_u'] = this.resDescU;
    data['res_website'] = this.resWebsite;
    if (this.resImage != null) {
      data['res_image'] = this.resImage.toJson();
    }
    data['logo'] = this.logo;
    data['res_phone'] = this.resPhone;
    data['res_address'] = this.resAddress;
    data['res_isOpen'] = this.resIsOpen;
    data['res_status'] = this.resStatus;
    data['res_create_date'] = this.resCreateDate;
    data['res_ratings'] = this.resRatings;
    data['status'] = this.status;
    data['res_video'] = this.resVideo;
    data['res_url'] = this.resUrl;
    data['mfo'] = this.mfo;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['vid'] = this.vid;
    data['c_name'] = this.cName;
    data['review_count'] = this.reviewCount;
    data['all_image'] = this.allImage;
    return data;
  }
}

class ResImage {
  String resImag0;
  String resImag1;
  String resImag2;

  ResImage({this.resImag0, this.resImag1, this.resImag2});

  ResImage.fromJson(Map<String, dynamic> json) {
    resImag0 = json['res_imag0'];
    resImag1 = json['res_imag1'];
    resImag2 = json['res_imag2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res_imag0'] = this.resImag0;
    data['res_imag1'] = this.resImag1;
    data['res_imag2'] = this.resImag2;
    return data;
  }
}
