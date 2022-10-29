import 'package:grace_nation/core/models/api_asset.dart';

class Testimony {
  String uuid;
  String title;
  String description;
  String testifier;
  String createdAt;
  String? imageId;
  String? imageUrl;
  String? imagefileName;
  String? imagefilePath;

  Testimony({
    required this.uuid,
    required this.title,
    required this.description,
    required this.testifier,
    required this.createdAt,
    this.imageId,
    this.imageUrl,
    this.imagefileName,
    this.imagefilePath,
  });
}
