class ErrorModel {
  String? message;
  int? code;

  ErrorModel({this.message, this.code});
  ErrorModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson(decode) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = message;
    data['code'] = code;
    return data;
  }
}
