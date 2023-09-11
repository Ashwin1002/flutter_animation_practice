import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class ChatBubbleRenderWidget extends StatefulWidget {
  const ChatBubbleRenderWidget({super.key});

  @override
  State<ChatBubbleRenderWidget> createState() => _ChatBubbleRenderWidgetState();
}

class _ChatBubbleRenderWidgetState extends State<ChatBubbleRenderWidget> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = "Hello, Good morning";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 220,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    color: Colors.blue.shade100,
                    padding: const EdgeInsets.all(15),

                    /// first create a custom widget with possible arguments
                    /// here listenable builder is wrapper to listen to the changes in the text editing controller
                    child: ListenableBuilder(
                      listenable: _controller,
                      builder: (context, child) => TimestampedChatMessage(
                        text: _controller.text.isEmpty
                            ? "Write a message..."
                            : _controller.text,
                        sentAt: '2 minutes ago',
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: TextField(controller: _controller),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// second, create a custom class which extends [LeafRenderObjectWidget] and pass the arguments. LeafRenderObject overrider a method 'createRenderObject'. we create another @override called updateRenderObject which replaces the widget changes in the render tree
class TimestampedChatMessage extends LeafRenderObjectWidget {
  const TimestampedChatMessage({
    super.key,
    required this.text,
    required this.sentAt,
    required this.style,
  });

  final String text;
  final String sentAt;
  final TextStyle style;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TimestampedChatMessageRenderObject(
      text: text,
      sentAt: sentAt,
      style: style,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    TimestampedChatMessageRenderObject renderObject,
  ) {
    renderObject.text = text;
    renderObject.sentAt = sentAt;
    renderObject.style = style;
    renderObject.textDirection = Directionality.of(context);
  }
}

// third we create a custom class [TimestampedChatMessageRenderObject] which extends [RenderBox]. After that we create _private field for all the named parameters. Then, we create getter and setter for each filed. TextPainter is created for String sentAt and text.
class TimestampedChatMessageRenderObject extends RenderBox {
  TimestampedChatMessageRenderObject({
    required String sentAt,
    required String text,
    required TextStyle style,
    required TextDirection textDirection,
  }) {
    _sentAt = sentAt;
    _text = text;
    _style = style;
    _textDirection = textDirection;

    _textPainter = TextPainter(
      text: textTextSpan,
      textDirection: _textDirection,
    );

    _sentAtTextPainter = TextPainter(
      text: sentAtTextSpan,
      textDirection: _textDirection,
    );
  }
  late String _sentAt;
  late String _text;
  late TextStyle _style;
  late TextDirection _textDirection;

  late TextPainter _textPainter;
  late TextPainter _sentAtTextPainter;

  // Saved values from 'performLayout'
  late bool _sentAtFitsOnLastLine;
  late double _lineHeight;
  late double _lastMessageLineWidth;
  late double _longestLineWidth;
  late double _sentAtLineWidth;
  late int _numberMessageLines;

  String get sentAt => _sentAt;

  set sentAt(String value) {
    if (value == _sentAt) {
      return;
    }
    _sentAt = value;
    _sentAtTextPainter.text = sentAtTextSpan;
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  TextSpan get sentAtTextSpan => TextSpan(
        text: _sentAt,
        style: _style.copyWith(color: Colors.grey),
      );

  String get text => _text;

  set text(String value) {
    if (value == _text) {
      return;
    }
    _text = value;
    _textPainter.text = textTextSpan;
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  TextSpan get textTextSpan => TextSpan(
        text: _text,
        style: _style,
      );

  TextStyle get style => _style;
  set style(TextStyle value) {
    if (value == _style) {
      return;
    }
    _style = value;
    _textPainter.text = textTextSpan;
    _sentAtTextPainter.text = sentAtTextSpan;
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    _textPainter.textDirection = _textDirection;
    _sentAtTextPainter.textDirection = _textDirection;
  }

  /// this method is crucial because it determines the dimension of what we are rendering and saves it to the size attribute.
  @override
  void performLayout() {
    _textPainter.layout(maxWidth: constraints.maxWidth);

    final textLines = _textPainter.computeLineMetrics();

    _longestLineWidth = 0;
    for (final line in textLines) {
      _longestLineWidth = max(_longestLineWidth, line.width);
    }
    _lastMessageLineWidth = textLines.last.width;
    _lineHeight = textLines.last.height;
    _numberMessageLines = textLines.length;

    _sentAtTextPainter.layout(maxWidth: constraints.maxWidth);
    _sentAtLineWidth = _sentAtTextPainter.computeLineMetrics().first.width;

    final sizeOfMessage = Size(_longestLineWidth, _textPainter.height);

    // Set _sentAtFitsOnLastLine
    final lastLineWidthDate = _lastMessageLineWidth + (_sentAtLineWidth * 1.1);
    if (textLines.length == 1) {
      _sentAtFitsOnLastLine = lastLineWidthDate < constraints.maxWidth;
    } else {
      _sentAtFitsOnLastLine =
          lastLineWidthDate < min(_longestLineWidth, constraints.maxWidth);
    }

    late Size computedSize;
    if (!_sentAtFitsOnLastLine) {
      computedSize = Size(
        sizeOfMessage.width,
        sizeOfMessage.height + _sentAtTextPainter.height,
      );
    } else {
      if (textLines.length == 1) {
        computedSize = Size(lastLineWidthDate, sizeOfMessage.height);
      } else {
        computedSize = Size(_longestLineWidth, sizeOfMessage.height);
      }
    }

    size = constraints.constrain(computedSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _textPainter.paint(context.canvas, offset);

    late Offset sentAtOffset;
    if (_sentAtFitsOnLastLine) {
      sentAtOffset = Offset(
        offset.dx + (size.width - _sentAtLineWidth),
        offset.dy + (_lineHeight * (_numberMessageLines - 1)),
      );
    } else {
      sentAtOffset = Offset(
        offset.dx + (size.width - _sentAtLineWidth),
        offset.dy + (_lineHeight * _numberMessageLines),
      );
    }

    _sentAtTextPainter.paint(context.canvas, sentAtOffset);
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    config.isSemanticBoundary = true;
    config.label = "$_text, sent at $_sentAt";
    config.textDirection = _textDirection;
  }
}
