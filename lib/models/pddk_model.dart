class PddkModel {
  String? nik;
  String? nama_lengkap;

  PddkModel({this.nik, this.nama_lengkap});

  PddkModel.fromJson(Map<String, dynamic> json) {
    nik = json['nik'];
    nama_lengkap = json['nama_lengkap'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nik'] = this.nik;
    data['nama_lengkap'] = this.nama_lengkap;
    return data;
  }
}
