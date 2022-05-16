class DynLinkModel {
  int status;
  String msg;
  List<Dytext> dytext;

  DynLinkModel({this.status, this.msg, this.dytext});

  DynLinkModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['text'] != null) {
      dytext = new List<Dytext>();
      json['text'].forEach((v) {
        dytext.add(new Dytext.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.dytext != null) {
      data['text'] = this.dytext.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dytext {
  String id;
  String weblink;

  Dytext({this.id, this.weblink});

  Dytext.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weblink = json['weblink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['weblink'] = this.weblink;
    return data;
  }
}
