import 'dart:convert';

extension ObjectExtension on Object {
  dynamic toDynamic() {
    if (this is String) {
      return this;
    }
    if (this is int) {
      return this;
    }
    if (this is double) {
      return this;
    }
    if (this is bool) {
      return this;
    }
    if (this is Iterable) {
      return List.from(json.decode(json.encode(this)))
          .map((e) => e is Object ? e.toDynamic() : e)
          .toList();
    }
    return json.decode(json.encode(this));
  }
}
