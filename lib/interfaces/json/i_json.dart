abstract interface class IJson {
  Map<String, dynamic> toJson();
  static IJson fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();
}
