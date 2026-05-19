import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takmed/features/learning/domain/entities/lesson_content/content_block.dart';
import 'package:takmed/features/learning/presentation/widgets/content_block_renderer.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

void main() {
  group('ContentBlockRenderer', () {
    group('TextBlock', () {
      testWidgets('renders text content', (tester) async {
        const block = TextBlock(text: 'Тактична медицина');
        await tester.pumpWidget(_wrap(const ContentBlockRenderer(block: block)));

        expect(find.text('Тактична медицина'), findsOneWidget);
      });

      testWidgets('renders empty text without error', (tester) async {
        const block = TextBlock(text: '');
        await tester.pumpWidget(_wrap(const ContentBlockRenderer(block: block)));

        expect(find.byType(Text), findsOneWidget);
      });
    });

    group('HeadingBlock', () {
      testWidgets('renders heading text', (tester) async {
        const block = HeadingBlock(text: 'Зупинка кровотечі', level: 1);
        await tester.pumpWidget(_wrap(const ContentBlockRenderer(block: block)));

        expect(find.text('Зупинка кровотечі'), findsOneWidget);
      });

      testWidgets('H1 has larger font than H3', (tester) async {
        const h1 = HeadingBlock(text: 'Заголовок', level: 1);
        const h3 = HeadingBlock(text: 'Заголовок', level: 3);

        await tester.pumpWidget(_wrap(const ContentBlockRenderer(block: h1)));
        final h1Text = tester.widget<Text>(find.text('Заголовок'));
        final h1Size = h1Text.style?.fontSize;

        await tester.pumpWidget(_wrap(const ContentBlockRenderer(block: h3)));
        final h3Text = tester.widget<Text>(find.text('Заголовок'));
        final h3Size = h3Text.style?.fontSize;

        expect(h1Size, greaterThan(h3Size!));
      });

      testWidgets('H2 has correct font size 20', (tester) async {
        const block = HeadingBlock(text: 'H2', level: 2);
        await tester.pumpWidget(_wrap(const ContentBlockRenderer(block: block)));

        final textWidget = tester.widget<Text>(find.text('H2'));
        expect(textWidget.style?.fontSize, 20);
      });
    });

    group('ImageBlock', () {
      testWidgets('shows placeholder for empty URL', (tester) async {
        const block = ImageBlock(url: '', caption: null);
        await tester.pumpWidget(_wrap(const ContentBlockRenderer(block: block)));

        expect(find.text('Зображення недоступне'), findsOneWidget);
        expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
      });

      testWidgets('shows placeholder for non-http URL', (tester) async {
        const block = ImageBlock(url: 'assets/image.png', caption: null);
        await tester.pumpWidget(_wrap(const ContentBlockRenderer(block: block)));

        expect(find.text('Зображення недоступне'), findsOneWidget);
      });

      testWidgets('shows CachedNetworkImage for valid http URL', (tester) async {
        const block = ImageBlock(url: 'https://example.com/image.png', caption: null);
        await tester.pumpWidget(_wrap(const ContentBlockRenderer(block: block)));

        expect(find.byType(CachedNetworkImage), findsOneWidget);
      });

      testWidgets('shows caption when provided', (tester) async {
        const block = ImageBlock(url: 'https://example.com/image.png', caption: 'Накладання джгута');
        await tester.pumpWidget(_wrap(const ContentBlockRenderer(block: block)));

        expect(find.text('Накладання джгута'), findsOneWidget);
      });

      testWidgets('does not show caption when null', (tester) async {
        const block = ImageBlock(url: '', caption: null);
        await tester.pumpWidget(_wrap(const ContentBlockRenderer(block: block)));

        expect(find.text('Накладання джгута'), findsNothing);
      });

      testWidgets('does not show caption when empty string', (tester) async {
        const block = ImageBlock(url: '', caption: '   ');
        await tester.pumpWidget(_wrap(const ContentBlockRenderer(block: block)));

        // тільки плейсхолдер, без підпису
        expect(find.text('Зображення недоступне'), findsOneWidget);
      });

      testWidgets('image is wrapped in ClipRRect for rounded corners', (tester) async {
        const block = ImageBlock(url: '', caption: null);
        await tester.pumpWidget(_wrap(const ContentBlockRenderer(block: block)));

        expect(find.byType(ClipRRect), findsOneWidget);
      });
    });

    group('WarningBlock', () {
      testWidgets('renders warning text', (tester) async {
        const block = WarningBlock(text: 'Небезпека кровотечі');
        await tester.pumpWidget(_wrap(const ContentBlockRenderer(block: block)));

        expect(find.text('Небезпека кровотечі'), findsOneWidget);
      });

      testWidgets('shows warning icon', (tester) async {
        const block = WarningBlock(text: 'Увага');
        await tester.pumpWidget(_wrap(const ContentBlockRenderer(block: block)));

        expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      });
    });

    group('InfoBlock', () {
      testWidgets('renders info text', (tester) async {
        const block = InfoBlock(text: 'Інформація про MARCH');
        await tester.pumpWidget(_wrap(const ContentBlockRenderer(block: block)));

        expect(find.text('Інформація про MARCH'), findsOneWidget);
      });

      testWidgets('shows info icon', (tester) async {
        const block = InfoBlock(text: 'Підказка');
        await tester.pumpWidget(_wrap(const ContentBlockRenderer(block: block)));

        expect(find.byIcon(Icons.info_outline), findsOneWidget);
      });
    });

    group('ContentBlock.fromJson', () {
      test('parses TextBlock correctly', () {
        final block = ContentBlock.fromJson({'type': 'text', 'text': 'Абзац'});
        expect(block, isA<TextBlock>());
        expect((block as TextBlock).text, 'Абзац');
      });

      test('parses HeadingBlock with default level 2', () {
        final block = ContentBlock.fromJson({'type': 'heading', 'text': 'Заголовок'});
        expect(block, isA<HeadingBlock>());
        final h = block as HeadingBlock;
        expect(h.text, 'Заголовок');
        expect(h.level, 2);
      });

      test('parses HeadingBlock with explicit level', () {
        final block = ContentBlock.fromJson({'type': 'heading', 'text': 'H1', 'level': 1});
        expect((block as HeadingBlock).level, 1);
      });

      test('parses ImageBlock with caption', () {
        final block = ContentBlock.fromJson({
          'type': 'image',
          'url': 'https://example.com/img.png',
          'caption': 'Підпис',
        });
        expect(block, isA<ImageBlock>());
        final img = block as ImageBlock;
        expect(img.url, 'https://example.com/img.png');
        expect(img.caption, 'Підпис');
      });

      test('parses ImageBlock without caption', () {
        final block = ContentBlock.fromJson({'type': 'image', 'url': 'https://x.com/a.png'});
        final img = block as ImageBlock;
        expect(img.caption, isNull);
      });

      test('parses WarningBlock', () {
        final block = ContentBlock.fromJson({'type': 'warning', 'text': 'Увага!'});
        expect(block, isA<WarningBlock>());
        expect((block as WarningBlock).text, 'Увага!');
      });

      test('parses InfoBlock', () {
        final block = ContentBlock.fromJson({'type': 'info', 'text': 'Підказка'});
        expect(block, isA<InfoBlock>());
        expect((block as InfoBlock).text, 'Підказка');
      });

      test('unknown type falls back to TextBlock', () {
        final block = ContentBlock.fromJson({'type': 'unknown', 'text': 'fallback'});
        expect(block, isA<TextBlock>());
        expect((block as TextBlock).text, 'fallback');
      });

      test('unknown type with missing text returns empty TextBlock', () {
        final block = ContentBlock.fromJson({'type': 'unknown'});
        expect(block, isA<TextBlock>());
        expect((block as TextBlock).text, '');
      });
    });
  });
}
