class GoogleModel {
  String responseCode;
  String message;
  User user;
  String status;

  GoogleModel({this.responseCode, this.message, this.user, this.status});

  GoogleModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class User {
  String id;
  String fname;
  String number;
  String userType;
  String loginType;
  String email;
  String password;
  String gender;
  String bdate;
  String location;
  String profilePic;
  String date;
  String role;

  User(
      {this.id,
      this.fname,
      this.number,
      this.userType,
      this.loginType,
      this.email,
      this.password,
      this.gender,
      this.bdate,
      this.location,
      this.profilePic,
      this.date,
      this.role});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fname = json['fname'];
    number = json['number'];
    userType = json['user_type'];
    loginType = json['login_type'];
    email = json['email'];
    password = json['password'];
    gender = json['gender'];
    bdate = json['bdate'];
    location = json['location'];
    profilePic = json['profile_pic'];
    date = json['date'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fname'] = this.fname;
    data['number'] = this.number;
    data['user_type'] = this.userType;
    data['login_type'] = this.loginType;
    data['email'] = this.email;
    data['password'] = this.password;
    data['gender'] = this.gender;
    data['bdate'] = this.bdate;
    data['location'] = this.location;
    data['profile_pic'] = this.profilePic;
    data['date'] = this.date;
    data['role'] = this.role;
    return data;
  }
}