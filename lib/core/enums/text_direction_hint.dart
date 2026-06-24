/// Reading direction hint for a content block.
enum TextDirectionHint {
  rtl,
  ltr,
  auto;

  String get storageValue => name;

  static TextDirectionHint fromStorage(String? value) {
    if (value == null) return TextDirectionHint.auto;
    return TextDirectionHint.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TextDirectionHint.auto,
    );
  }
}
