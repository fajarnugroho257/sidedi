class ProfesiModel {
  String? profesi_id;
  String? profesi_nama;

  ProfesiModel({this.profesi_id, this.profesi_nama});

  ProfesiModel.fromJson(Map<String, dynamic> json) {
    profesi_id = json['profesi_id'];
    profesi_nama = json['profesi_nama'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profesi_id'] = this.profesi_id;
    data['profesi_nama'] = this.profesi_nama;
    return data;
  }
}
