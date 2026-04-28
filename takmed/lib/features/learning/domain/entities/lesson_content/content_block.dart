/// Sealed class для блоків контенту уроку.
sealed class ContentBlock {
  /// Створює блок контенту.
  const ContentBlock();

  /// Парсить JSON map у ContentBlock.
  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'text':
        return TextBlock(text: json['text'] as String);
      case 'heading':
        return HeadingBlock(
          text: json['text'] as String,
          level: json['level'] as int? ?? 2,
        );
      case 'image':
        return ImageBlock(
          url: json['url'] as String,
          caption: json['caption'] as String?,
        );
      case 'warning':
        return WarningBlock(text: json['text'] as String);
      case 'info':
        return InfoBlock(text: json['text'] as String);
      default:
        return TextBlock(text: json['text'] as String? ?? '');
    }
  }
}

/// Текстовий блок.
class TextBlock extends ContentBlock {
  /// Створює текстовий блок.
  const TextBlock({required this.text});

  /// Текст.
  final String text;
}

/// Заголовок.
class HeadingBlock extends ContentBlock {
  /// Створює заголовок.
  const HeadingBlock({required this.text, this.level = 2});

  /// Текст заголовку.
  final String text;

  /// Рівень (1-3).
  final int level;
}

/// Зображення.
class ImageBlock extends ContentBlock {
  /// Створює блок зображення.
  const ImageBlock({required this.url, this.caption});

  /// URL зображення.
  final String url;

  /// Підпис.
  final String? caption;
}

/// Попередження (⚠️).
class WarningBlock extends ContentBlock {
  /// Створює блок попередження.
  const WarningBlock({required this.text});

  /// Текст попередження.
  final String text;
}

/// Інформація (ℹ️).
class InfoBlock extends ContentBlock {
  /// Створює інформаційний блок.
  const InfoBlock({required this.text});

  /// Текст.
  final String text;
}
