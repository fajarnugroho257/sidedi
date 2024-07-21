class KkModel {
  String? no_kk;
  String? nama_kk;

  KkModel({this.no_kk, this.nama_kk});

  KkModel.fromJson(Map<String, dynamic> json) {
    no_kk = json['no_kk'];
    nama_kk = json['nama_kk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['no_kk'] = this.no_kk;
    data['nama_kk'] = this.nama_kk;
    return data;
  }
}
