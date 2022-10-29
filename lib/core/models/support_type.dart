class SupportType {
  int id;
  String title;
  String displayName;
  int status;
  String statusReadable;

  SupportType(
      {required this.id,
      required this.title,
      required this.displayName,
      required this.status,
      required this.statusReadable});

  factory SupportType.fromJson(Map<String, dynamic> json) => SupportType(
        id: json["id"],
        title: json["title"],
        displayName: json["display_name"],
        status: json["status"],
        statusReadable: json['status_readable'],
      );
}
