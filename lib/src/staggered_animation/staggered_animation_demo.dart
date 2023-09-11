import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AnimProps {
  opacity,
  width,
  height,
  padding,
  borderRadius,
  color,
}

class StaggeredDemo extends StatelessWidget {
  const StaggeredDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final animation = MovieTween()
      ..scene(
        begin: 0.milliseconds,
        end: 200.milliseconds,
        curve: Curves.ease,
      )
          .tween(
            AnimProps.opacity,
            Tween<double>(begin: 0, end: 1),
          )
          .thenFor(
            duration: 225.milliseconds,
            delay: 25.milliseconds,
            curve: Curves.ease,
          )
          .tween(
            AnimProps.width,
            Tween<double>(begin: 50, end: 150),
          )
          .thenFor(
            duration: 225.milliseconds,
            curve: Curves.ease,
          )
          .tween(
            AnimProps.height,
            Tween<double>(begin: 50, end: 150),
          )
          .tween(
            AnimProps.padding,
            EdgeInsetsTween(
              begin: const EdgeInsets.only(bottom: 16.0),
              end: const EdgeInsets.only(bottom: 75.0),
            ),
          )
          .thenFor(
            duration: 225.milliseconds,
            curve: Curves.ease,
          )
          .tween(
            AnimProps.borderRadius,
            BorderRadiusTween(
              begin: BorderRadius.circular(4.0),
              end: BorderRadius.circular(75.0),
            ),
          )
          .thenFor(
            duration: 350.milliseconds,
            curve: Curves.ease,
          )
          .tween(
            AnimProps.color,
            ColorTween(
              begin: Colors.indigo.shade100,
              end: Colors.orange.shade400,
            ),
          );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staggered Animation'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // if (controller.status == AnimationStatus.dismissed) {
          //   controller.forward();
          // } else if (controller.status == AnimationStatus.completed) {
          //   controller.reverse();
          // }
        },
        child: Center(
          child: Container(
              width: 300.0,
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                border: Border.all(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              child: PlayAnimationBuilder<Movie>(
                tween: animation,
                duration: animation.duration,
                builder: (context, value, _) {
                  return Container(
                    padding: value.get(AnimProps.padding),
                    alignment: Alignment.bottomCenter,
                    child: Opacity(
                      opacity: value.get(AnimProps.opacity),
                      child: Container(
                        width: value.get(AnimProps.width),
                        height: value.get(AnimProps.height),
                        decoration: BoxDecoration(
                          color: value.get(AnimProps.color),
                          border: Border.all(
                            color: Colors.indigo.shade300,
                            width: 3.0,
                          ),
                          borderRadius: value.get(AnimProps.borderRadius),
                        ),
                      ),
                    ),
                  );
                },
              )),
        ),
      ),
    );
  }
}
