class ImageModel {
  final int? id;
  final String path;

  ImageModel({this.id, required this.path});

  factory ImageModel.fromMap(Map<String, dynamic> json) => ImageModel(
        id: json['id'],
        path: json['path'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
    };
  }
}
