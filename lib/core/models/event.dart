import 'package:grace_nation/core/models/api_asset.dart';

class Event {
  int id;
  String uuid;
  String title;
  String description;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;
  int? status;
  String? statusReadable;
  ApiImage? coverImage;

  Event({
    required this.id,
    required this.uuid,
    required this.title,
    required this.description,
    this.startDate,
    this.endDate,
    this.status,
    this.statusReadable,
    this.coverImage,
    this.createdAt,
    this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        uuid: json["uuid"],
        title: json["title"],
        description: json["description"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        status: json["status"],
        statusReadable: json["status_readable"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        coverImage: (json['cover_image'].toString() == "[]" ||
                json['cover_image'].toString() == "")
            ? null
            : ApiImage(
                id: (json["cover_image"] as Map)["id"].toString(),
                url: (json["cover_image"] as Map)["url"].toString(),
                fileName: (json["cover_image"] as Map)["file_name"].toString(),
                filePath: (json["cover_image"] as Map)["file_path"].toString(),
              ),
      );
}
