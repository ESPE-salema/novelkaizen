import 'dart:convert';

Capitulo capituloFromJson(String str) => Capitulo.fromJson(json.decode(str));

String capituloToJson(Capitulo data) => json.encode(data.toJson());

class Capitulo {
  Capitulo({
    this.idCapitulo,
    this.tituloCapitulo,
    this.contenido,
    this.fechaPublicacion,
    this.leido,
  });

  int? idCapitulo;
  String? tituloCapitulo;
  String? contenido;
  DateTime? fechaPublicacion;
  bool? leido;

  factory Capitulo.fromJson(Map<String, dynamic> json) => Capitulo(
        idCapitulo: json["id_capitulo"],
        tituloCapitulo: json["titulo_capitulo"],
        contenido: json["contenido"],
        fechaPublicacion: DateTime.parse(json["fecha_publicacion"]),
        leido: json["leido"],
      );

  Map<String, dynamic> toJson() => {
        "id_capitulo": idCapitulo,
        "titulo_capitulo": tituloCapitulo,
        "contenido": contenido,
        "fecha_publicacion": fechaPublicacion!.toIso8601String(),
        "leido": leido,
      };
}
