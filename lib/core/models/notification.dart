class Notifications {
  String? id;
  String? type;
  String? message;
  String? readAt;
  String? createdAt;
  var object;

  Notifications(
      {this.id,
      this.message,
      this.type,
      this.readAt,
      this.createdAt,
      this.object});

  @override
  String toString() {
    return "id: $id, type: $type, message: $message, readAt: $readAt, createdAt: $createdAt";
  }

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json["id"],
      type: json['type'],
      message: json["message"],
      readAt: json["read_at"],
      createdAt: json['created_at'],
    );
  }
}
