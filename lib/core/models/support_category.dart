class SupportCategory {
  int id;
  String name;
  int count;

  SupportCategory({
    required this.id,
    required this.name,
    required this.count,
  });

  @override
  String toString() {
    return "id: $id, name: $name, count: $count";
  }

  factory SupportCategory.fromJson(Map<String, dynamic> json) =>
      SupportCategory(
        id: json["id"],
        name: json["name"],
        count: json["count"],
      );
}
