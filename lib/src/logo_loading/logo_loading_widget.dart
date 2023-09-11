import 'dart:ui';

import 'package:flutter/material.dart';

class LogoLoadingWidget extends StatefulWidget {
  const LogoLoadingWidget({super.key});

  @override
  State<LogoLoadingWidget> createState() => _LogoLoadingWidgetState();
}

class _LogoLoadingWidgetState extends State<LogoLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _linearProgressController;

  late Animation<double> _progressAnimation;

  late bool _showLogo = false;

  _setupAnimation() {
    _linearProgressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..addListener(() {
        if (_linearProgressController.isCompleted) {
          // _linearProgressController.repeat();
        }
      });

    _progressAnimation = CurvedAnimation(
      parent: _linearProgressController,
      curve: const Interval(0, 1),
    );
  }

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _linearProgressController.forward();
    setState(() {});
  }

  @override
  void dispose() {
    _linearProgressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.sizeOf(context);
    // print(_progressAnimation.value);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Transform.scale(
        scale: 1,
        child: AnimatedBuilder(
          animation: _linearProgressController,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: SizedBox.square(
                    dimension: 100,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: LinePainter(
                          progressValue: _progressAnimation.value,
                          strokeWidth: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 45,
                  child: RepaintBoundary(
                    child: AnimatedOpacity(
                      opacity: _progressAnimation.value,
                      // opacity: 1,
                      duration: const Duration(milliseconds: 150),
                      child: const Center(
                        child: SizedBox.square(
                          dimension: 100,
                          child: CustomPaint(
                            painter: LogoPainter(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // const LinearProgressIndicator(
                //   value: .9,
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final Color progressColor;
  final Color defaultColor;
  final double progressValue;
  final double strokeWidth;

  const LinePainter({
    this.progressColor = const Color(0xFF2E3192),
    this.defaultColor = Colors.grey,
    required this.progressValue,
    this.strokeWidth = 5,
  });

  getPaint(Color color) {
    return Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final progressLinePaint = getPaint(progressColor);

    // Path path = Path();
    // path.moveTo(0, size.width * .625);
    // path.lineTo(0, 0);
    // path.lineTo(size.width, 0);
    // path.lineTo(size.width, size.width * .2);
    // path.lineTo(size.width * .9, size.width * .2);
    // path.lineTo(size.width * .9, size.width * .1);
    // path.lineTo(size.width * .1, size.width * .1);
    // path.lineTo(size.width * .1, size.width * .625);
    // path.close();

    // Path path2 = Path();
    // path2.moveTo(0, size.width * .825);
    // path2.lineTo(0, size.width);
    // path2.lineTo(size.width, size.width);
    // path2.lineTo(size.width, size.width * .4105);
    // path2.lineTo(size.width * .9, size.width * .4105);
    // path2.lineTo(size.width * .9, size.width * .9);
    // path2.lineTo(size.width * .1, size.width * .9);
    // path2.lineTo(size.width * .1, size.width * .825);
    // path2.close();

    //left upper line => new point = 0.0 - .15
    //top line => new point = 0.15 - .40
    // right upper line => new point = .40 - .50
    // right lower line => new point = .50 - .65
    // bottom line => new point = .65 - .90
    // left lower line => new point = .9 - 1
    Path fillPath = Path();

    if (progressValue >= 0.0 && progressValue <= 0.15) {
      var k = ((progressValue / 0.15) * 100) / 100;
      fillPath.moveTo(0, size.width * .625);
      fillPath.lineTo(0, size.width * (.625 * (1 - k)).clamp(0, .625));
    } else if (progressValue >= 0.15 && progressValue <= 0.40) {
      var k = ((progressValue / 0.40) * 100) / 100;
      fillPath.moveTo(0, size.width * .625);
      fillPath.lineTo(0, 0);
      fillPath.quadraticBezierTo(0, 0, size.width * k, 0);
    } else if (progressValue >= 0.4 && progressValue <= 0.5) {
      var k = ((progressValue / 0.5) * 100) / 100;
      fillPath.moveTo(0, size.width * .625);
      fillPath.lineTo(0, 0);
      fillPath.quadraticBezierTo(0, 0, size.width, 0);
      fillPath.quadraticBezierTo(
          size.width, 0, size.width, size.width * .2 * k);
    } else if (progressValue >= .5) {
      fillPath.moveTo(0, size.width * .625);
      fillPath.lineTo(0, 0);
      fillPath.quadraticBezierTo(0, 0, size.width, 0);
      fillPath.quadraticBezierTo(size.width, 0, size.width, size.width * .2);

      // fillPath.lineTo(size.width, size.width * .2);
    }

    Path fillPath2 = Path();

    if (progressValue >= .5 && progressValue <= 0.65) {
      var k = ((progressValue / 0.65) * 100) / 100;
      fillPath2.moveTo(size.width, size.width * .4105);
      fillPath2.lineTo(size.width, size.width * k);
    } else if (progressValue >= .55 && progressValue <= 0.9) {
      var k = ((progressValue / 0.9) * 100) / 100;
      fillPath2.moveTo(size.width, size.width * .4105);
      fillPath2.lineTo(size.width, size.width);
      fillPath2.lineTo((size.width * (1 - k)).clamp(0, size.width), size.width);
    } else if (progressValue >= .9 && progressValue <= 1) {
      var k = ((progressValue / 1) * 100) / 100;
      fillPath2.moveTo(size.width, size.width * .4105);
      fillPath2.quadraticBezierTo(
          size.width, size.width * .4105, size.width, size.width);
      fillPath2.quadraticBezierTo(0, size.width, 0, size.width);
      fillPath2.lineTo(
          0, ((size.width * .825 * k).clamp(size.width * .825, size.width)));
      // fillPath2.lineTo(0, size.width);
      // fillPath2.lineTo(0,
      //     ((size.width * .825 * (1 - k)).clamp(size.width * .825, size.width)));
    } else if (progressValue == 1) {
      fillPath2.moveTo(size.width, size.width * .4105);
      fillPath2.lineTo(size.width, size.width);
      fillPath2.lineTo(0, size.width);
      fillPath2.lineTo(0, size.width * .825);
    }

    // canvas.drawPath(path, defaultLinePaint);
    // canvas.drawPath(path2, defaultLinePaint);
    canvas.drawPath(fillPath, progressLinePaint);
    canvas.drawPath(fillPath2, progressLinePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class LogoPainter extends CustomPainter {
  final Color? color;
  final double strokeWidth;

  const LogoPainter({this.strokeWidth = 5, this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? const Color(0xFF00904B)
      ..strokeWidth = 5
      ..style = PaintingStyle.fill;

    Path path = Path()..moveTo(size.width * .96, 0);
    path.lineTo(size.width * .4, 0);
    path.quadraticBezierTo(
        size.width * .2, 0, size.width * .2, size.height * .13);
    path.lineTo(size.width * .96, size.height * .13);
    path.close();

    Path path2 = Path()..moveTo(size.width * .2, size.height * .21);
    path2.lineTo(size.width * .65, size.height * .21);
    path2.arcToPoint(Offset(size.width * .65, size.height * .55),
        radius: const Radius.circular(10), clockwise: true);
    path2.lineTo(size.width * .04, size.height * .55);
    path2.lineTo(size.width * .04, size.height * .43);
    path2.lineTo(size.width * .63, size.height * .43);
    path2.arcToPoint(Offset(size.width * .63, size.height * .33),
        radius: const Radius.circular(10), clockwise: false);
    path2.lineTo(size.width * .38, size.height * .33);
    path2.quadraticBezierTo(size.width * .21, size.height * .33,
        size.width * .2, size.height * .22);
    path2.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// if (progressValue >= 0.0 && progressValue <= .2) {
//       var k = ((progressValue / 0.2) * 100) / 100;
//       fillPath.moveTo(0, size.width * (.625 * (1 - k)).clamp(0, .625));
//       fillPath.lineTo(0, 0);
//       fillPath.lineTo(size.width * (k.clamp(.25, .85)), 0);
//     } else if (progressValue >= 0.2 && progressValue <= .4) {
//       // print("offset start from 0, 0");
//       var k = ((progressValue / 0.4) * 100) / 100;
//       fillPath.moveTo(size.width * .85 * k, 0);
//       fillPath.lineTo(size.width * (1 * k).clamp(.25, 1), 0);
//       fillPath.lineTo(size.width * 1, size.width * .2 * k);
//     } else {
//       fillPath.moveTo(size.width * .25, 0);
//       fillPath.lineTo(size.width * 1, 0);
//       fillPath.lineTo(size.width, size.width * .2);
//       // fillPath.moveTo(0, size.width * .625);
//       // fillPath.lineTo(0, 0);
//       // fillPath.lineTo(size.width, 0);
//       // fillPath.lineTo(size.width, size.width * .2);
//     }