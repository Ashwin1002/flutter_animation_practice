import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const Duration _imageResizeDuration = Duration(milliseconds: 500);

var imageData =
    List.generate(50, (index) => 'https://picsum.photos/${index + 1}00');

class ResizableGridView extends StatefulWidget {
  const ResizableGridView({super.key});

  @override
  State<ResizableGridView> createState() => _ResizableGridViewState();
}

class _ResizableGridViewState extends State<ResizableGridView> {
  List<String> data = [];

  var gridSize = GridSize.xSmall;

  bool isReverse = false;
  bool isSmallGrid = false;

  @override
  void initState() {
    super.initState();

    data = [...imageData];

    isSmallGrid = data.length <= 50;

    if (isSmallGrid) {
      gridSize = GridSize.small;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resizable Grid View')),
      body: AnimatedSwitcher(
        duration: _imageResizeDuration,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        child: GridView.builder(
          key: ValueKey<GridSize>(gridSize),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize.crossAxisCount,
            // mainAxisExtent: gridSize.dimension,
            childAspectRatio: 4 / 4,
            mainAxisSpacing: gridSize.spacing,
            crossAxisSpacing: gridSize.spacing,
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return AnimatedSwitcher(
              duration: _imageResizeDuration,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                );
              },
              child: _imageView(data[index]),
            );
          },
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
    setState(() {
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
    });
  }

  void _antiClockWise() {
    setState(() {
      switch (gridSize) {
        case GridSize.large:
          gridSize = GridSize.medium;

        case GridSize.medium:
          gridSize = GridSize.small;

        case GridSize.small:
          if (isSmallGrid) {
            isReverse = false;
            return;
          }
          gridSize = GridSize.xSmall;
          isReverse = false;

        default:
      }
    });
  }

  Widget _imageView(String url) => CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (_, __, ___) => Container(
          color: Colors.grey.shade300,
        ),
      );
}

enum GridSize {
  xSmall(0, 13),
  small(2, 5),
  medium(2, 3),
  large(2, 1);

  const GridSize(this.spacing, this.crossAxisCount);

  final double spacing;
  final int crossAxisCount;
}

extension GridSizeExt on GridSize {
  A when<A>({
    required A Function() xSmall,
    required A Function() small,
    required A Function() medium,
    required A Function() large,
  }) {
    return switch (this) {
      GridSize.large => large(),
      GridSize.medium => medium(),
      GridSize.small => small(),
      GridSize.xSmall => xSmall(),
    };
  }
}
