// Modal class for the data we are getting from the API
class Activitas {
  Activitas({
    required this.id,
    required this.aktivitas_nama,
    required this.aktivitas_aksi,
  });

  final String id;
  final String aktivitas_nama;
  final int aktivitas_aksi;

  factory Activitas.fromJson(Map<String, dynamic> json) => Activitas(
        id: json["id"],
        aktivitas_nama: json["aktivitas_nama"],
        aktivitas_aksi: json["aktivitas_aksi"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "aktivitas_nama": aktivitas_nama,
        "aktivitas_aksi": aktivitas_aksi,
      };
}
