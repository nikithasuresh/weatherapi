class PublicApiEntriesOutlineModel {
  int count;
  List<Map> entries;
  PublicApiEntriesOutlineModel({required this.count, required this.entries});
  factory PublicApiEntriesOutlineModel.fromJson(Map<String, dynamic> json) {
    return PublicApiEntriesOutlineModel(
        count: json['count'], entries: List<Map>.from(json['entries']));
  }
}
