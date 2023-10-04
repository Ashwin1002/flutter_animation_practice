import 'package:flutter/material.dart';

class RelativeImagePosition extends StatelessWidget {
  const RelativeImagePosition({super.key});

  @override
  Widget build(BuildContext context) {
    final renderObect = context.findRenderObject() as RenderBox;
    final offsetY = renderObect.localToGlobal(Offset.zero).dy;
    final deviceHeight = MediaQuery.sizeOf(context).height;
    final relativePosition = offsetY / deviceHeight;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.builder(
          itemCount: 8,
          itemBuilder: (context, index) {
            return Center(
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: deviceHeight * .18,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: Alignment(0, relativePosition - .5),
                    image: const AssetImage('assets/images/music.jpeg'),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class VeryGoodWrapper extends StatelessWidget {
  const VeryGoodWrapper({
    super.key,
    required this.child,
    required this.scrollController,
  });

  final Widget child;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        final renderObject = context.findRenderObject() as RenderBox;
        final offsetY = renderObject.localToGlobal(Offset.zero).dy;
        if (offsetY <= 0) {
          return child!;
        }
        final deviceHeight = MediaQuery.sizeOf(context).height;
        final heightVisible = deviceHeight - offsetY;
        final widgetHeight = renderObject.size.height;

        final howMuchShown = (heightVisible / widgetHeight).clamp(0.0, 1.0);
        final scale = .8 + howMuchShown * .2;
        final opacity = 0.25 + howMuchShown * .75;
        return Transform.scale(
          scale: scale,
          alignment: Alignment.center,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
