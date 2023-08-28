import 'package:flutter/material.dart';

class LogoLoadingWidget extends StatefulWidget {
  const LogoLoadingWidget({super.key});

  @override
  State<LogoLoadingWidget> createState() => _LogoLoadingWidgetState();
}

class _LogoLoadingWidgetState extends State<LogoLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 300,
            width: 300,
            child: CustomPaint(
              painter: LinePainter(),
            ),
          ),
          Positioned(
            top: 35,
            child: Transform.scale(
              scale: .5,
              child: const SizedBox(
                height: 300,
                width: 300,
                child: CustomPaint(
                  painter: LogoPainter(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2E3192)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke;

    final a = Offset(size.width * 1 / 4, size.height * 1 / 4);
    final b = Offset(size.width * 3 / 4, size.height * 3 / 4);

    final rect = Rect.fromPoints(a, b);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
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

    // Path path = Path()..moveTo(0, 20);
    // path.quadraticBezierTo(size.width * .2, 0, size.width * .35, 0);
    // path.quadraticBezierTo(size.width * .40, 0, size.width * .40, 20);
    // path.arcToPoint(Offset(size.width * .60, 20),
    //     radius: const Radius.circular(10), clockwise: false);
    // path.quadraticBezierTo(size.width * .60, 0, size.width * .65, 0);
    // path.quadraticBezierTo(size.width * .80, 0, size.width, 20);
    // path.lineTo(size.width, size.height);
    // path.lineTo(0, size.height);
    // path.close();
    // canvas.drawShadow(path, Colors.black, 5, true);
    // canvas.drawPath(path, paint);

    Path path = Path()..moveTo(size.width, 0);
    path.lineTo(size.width * .4, 0);
    path.quadraticBezierTo(
        size.width * .2, 0, size.width * .2, size.height * .13);
    path.lineTo(size.width, size.height * .13);
    path.close();

    Path path2 = Path()..moveTo(size.width * .2, size.height * .22);
    path2.lineTo(size.width * .7, size.height * .22);
    path2.arcToPoint(Offset(size.width * .70, size.height * .55),
        radius: const Radius.circular(10), clockwise: true);
    path2.lineTo(0, size.height * .55);
    path2.lineTo(0, size.height * .43);
    path2.lineTo(size.width * .68, size.height * .43);
    path2.arcToPoint(Offset(size.width * .70, size.height * .35),
        radius: const Radius.circular(10), clockwise: false);
    path2.lineTo(size.width * .38, size.height * .35);
    path2.quadraticBezierTo(size.width * .22, size.height * .35,
        size.width * .2, size.height * .25);
    path2.close();

    path.close();
    path2.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
