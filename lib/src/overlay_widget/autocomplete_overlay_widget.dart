import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AutoCompleteSearchableOverlayWidgt extends StatefulWidget {
  const AutoCompleteSearchableOverlayWidgt({super.key});

  @override
  State<AutoCompleteSearchableOverlayWidgt> createState() =>
      _AutoCompleteSearchableOverlayWidgtState();
}

class _AutoCompleteSearchableOverlayWidgtState
    extends State<AutoCompleteSearchableOverlayWidgt> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 80,
              ),
            ),
            SliverToBoxAdapter(
              child: TextFieldOverlayWidget(),
            ),
            SliverFillRemaining(),
          ],
        ),
      ),
    );
  }
}

class TextFieldOverlayWidget extends StatefulWidget {
  const TextFieldOverlayWidget({super.key});

  @override
  State<TextFieldOverlayWidget> createState() => _TextFieldOverlayWidgetState();
}

class _TextFieldOverlayWidgetState extends State<TextFieldOverlayWidget> {
  OverlayEntry? entry;
  late TextEditingController _controller;
  final layerLink = LayerLink();

  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    // WidgetsBinding.instance.addPostFrameCallback((_) => showOverlay());

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        showOverlay();
      } else {
        hideOverlay();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showOverlay() {
    final overlay = Overlay.of(context);

    final renderBox = context.findRenderObject() as RenderBox;

    final size = renderBox.size;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 8),
          child: buildOverlay(),
        ),
      ),
    );

    overlay.insert(entry!);
  }

  Widget buildOverlay() {
    return Material(
      elevation: 8,
      child: Column(
        children: [
          ...List.generate(
            5,
            (index) => ListTile(
              leading: const Icon(
                CupertinoIcons.person_alt,
                color: Colors.grey,
              ),
              title: const Text("User Full Name"),
              subtitle: const Text("Flutter developer"),
              onTap: () {
                _controller.text = '$index user';

                hideOverlay();
                _focusNode.unfocus();
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
            label: const Text('Username'),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12.0))),
      ),
    );
  }

  void hideOverlay() {
    entry?.remove();
    entry = null;
  }
}
