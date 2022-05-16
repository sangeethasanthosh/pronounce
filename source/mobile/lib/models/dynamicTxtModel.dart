class DyamicTxtModel {
  int status;
  String msg;
  List<DynamicText> text;

  DyamicTxtModel({this.status, this.msg, this.text});

  DyamicTxtModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['text'] != null) {
      text = new List<DynamicText>();
      json['text'].forEach((v) {
        text.add(new DynamicText.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.text != null) {
      data['text'] = this.text.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DynamicText {
  String id;
  String textEn;
  String textAr;
  String popupText;

  DynamicText({this.id, this.textEn, this.textAr, this.popupText});

  DynamicText.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    textEn = json['text_en'];
    textAr = json['text_ar'];
    popupText = json['popup_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text_en'] = this.textEn;
    data['text_ar'] = this.textAr;
    data['popup_text'] = this.popupText;
    return data;
  }
}
