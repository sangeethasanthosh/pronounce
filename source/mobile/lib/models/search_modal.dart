class SearchModal {
  String responseCode;
  String message;
  List<SearchRestaurants> restaurants;
  String status;

  SearchModal({this.responseCode, this.message, this.restaurants, this.status});

  SearchModal.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    if (json['restaurants'] != null) {
      restaurants = new List<SearchRestaurants>();
      json['restaurants'].forEach((v) {
        restaurants.add(new SearchRestaurants.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    if (this.restaurants != null) {
      data['restaurants'] = this.restaurants.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class SearchRestaurants {
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
  String mfo;
  String lat;
  String lon;
  int reviewCount;
  List<String> allImage;

  SearchRestaurants(
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
      this.mfo,
      this.lat,
      this.lon,
      this.allImage,
      this.reviewCount});

  SearchRestaurants.fromJson(Map<String, dynamic> json) {
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
    mfo = json['mfo'];
    lat = json['lat'];
    lon = json['lon'];
    allImage = json['all_image'].cast<String>();
    reviewCount = json['review_count'];
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
    data['mfo'] = this.mfo;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['all_image'] = this.allImage;
    data['review_count'] = this.reviewCount;

    return data;
  }
}

class ResImage {
  String resImag0;

  ResImage({this.resImag0});

  ResImage.fromJson(Map<String, dynamic> json) {
    resImag0 = json['res_imag0'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res_imag0'] = this.resImag0;
    return data;
  }
}
