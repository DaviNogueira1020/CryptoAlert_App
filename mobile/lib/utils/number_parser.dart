double? parseDouble(dynamic value) {
  if (value == null) return null;

  return double.parse(value.toString());
}