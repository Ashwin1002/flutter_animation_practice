import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const Duration _imageResizeDuration = Duration(milliseconds: 500);

class ResizableGridView extends StatefulWidget {
  const ResizableGridView({super.key});

  @override
  State<ResizableGridView> createState() => _ResizableGridViewState();
}

class _ResizableGridViewState extends State<ResizableGridView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<String> data = [];

  var gridSize = GridSize.xSmall;

  bool isReverse = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceIn,
    );
    data = List.generate(50, (index) => 'https://picsum.photos/${index + 1}00');

    data.addAll([
      ...List.generate(50, (index) => 'https://picsum.photos/${index + 1}00')
    ]);

    data.addAll([
      ...List.generate(50, (index) => 'https://picsum.photos/${index + 1}00')
    ]);

    data.addAll([
      ...List.generate(50, (index) => 'https://picsum.photos/${index + 1}00')
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resizable Grid View')),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Wrap(
            runSpacing: gridSize.spacing,
            spacing: gridSize.spacing,
            children: data.map(
              (e) {
                return AnimatedContainer(
                  duration: _imageResizeDuration,
                  height: gridSize.dimension,
                  width: gridSize.dimension,
                  child: CachedNetworkImage(
                    imageUrl: e,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade300,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!isReverse) {
            _clockWise();
          } else {
            _antiClockWise();
          }

          setState(() {});
        },
        child: const Icon(Icons.abc),
      ),
    );
  }

  void _clockWise() {
    switch (gridSize) {
      case GridSize.xSmall:
        gridSize = GridSize.small;
      case GridSize.small:
        gridSize = GridSize.medium;
      case GridSize.medium:
        gridSize = GridSize.large;
        isReverse = true;
      default:
    }
  }

  void _antiClockWise() {
    switch (gridSize) {
      case GridSize.large:
        gridSize = GridSize.medium;
      case GridSize.medium:
        gridSize = GridSize.small;
      case GridSize.small:
        gridSize = GridSize.xSmall;
        isReverse = false;

      default:
    }
  }
}

enum GridSize {
  xSmall(35.0, 0),
  small(70.0, 2),
  medium(90.0, 2),
  large(180.0, 2);

  const GridSize(this.dimension, this.spacing);

  final double dimension;
  final double spacing;
}
