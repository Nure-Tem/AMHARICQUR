/// Types of structured book content blocks.
enum ContentBlockType {
  bookTitle,
  surahTitle,
  sectionHeading,
  subHeading,
  arabicVerse,
  arabicText,
  amharicTranslation,
  tafsir,
  decorative,
  pageBreak,
  footnote,
  unknown;

  String get storageValue => name;

  static ContentBlockType fromStorage(String? value) {
    if (value == null) return ContentBlockType.unknown;
    return ContentBlockType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ContentBlockType.unknown,
    );
  }
}
