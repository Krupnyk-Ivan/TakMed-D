import 'content_block.dart';

/// Контент теоретичного уроку.
class TheoryContent {
  /// Створює теоретичний контент.
  const TheoryContent({
    required this.title,
    required this.blocks,
    this.keyTerms = const [],
  });

  /// Назва.
  final String title;

  /// Блоки контенту.
  final List<ContentBlock> blocks;

  /// Ключові поняття.
  final List<String> keyTerms;

  /// Парсить JSON map.
  factory TheoryContent.fromJson(Map<String, dynamic> json) {
    final blocksJson = json['blocks'] as List<dynamic>? ?? [];
    final keyTermsJson = json['keyTerms'] as List<dynamic>? ?? [];

    return TheoryContent(
      title: json['title'] as String? ?? '',
      blocks: blocksJson
          .map((b) => ContentBlock.fromJson(b as Map<String, dynamic>))
          .toList(),
      keyTerms: keyTermsJson.map((t) => t as String).toList(),
    );
  }
}
