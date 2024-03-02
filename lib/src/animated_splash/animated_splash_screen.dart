import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({Key? key}) : super(key: key);

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with TickerProviderStateMixin {
  final int _splashAnimationDuration = 5500;

  final int _doughnutAnimationDuration = 3000;

  final int _textAnimationDuration = 4500;

  final int _loginAnimationDuration = 1500;

  late AnimationController _splashAnimationController;
  late AnimationController _doughnutAnimationController;
  late AnimationController _textAnimationController;
  late AnimationController _loginAnimationController;

  late Animation<double> _doughnut1Animation;
  late Animation<double> _doughnut2Animation;
  late Animation<double> _doughnut3Animation;
  late Animation<double> _splashTitleShowAnimation;
  late Animation<double> _splashTitleAnimation;
  late Animation<double> _shadeAnimation;
  late Animation<double> _loginContainerAnimation;

  _setUpAnimation() async {
    _splashAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _splashAnimationDuration),
    );

    _shadeAnimation = CurvedAnimation(
        parent: _splashAnimationController, curve: const Interval(0, .30));
  }

  _setUpTextAnimation() async {
    _textAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _textAnimationDuration),
    );

    _splashTitleAnimation = CurvedAnimation(
        parent: _textAnimationController, curve: const Interval(0, .7));

    _splashTitleShowAnimation = CurvedAnimation(
        parent: _textAnimationController, curve: const Interval(.5, .7));

    _loginContainerAnimation = CurvedAnimation(
        parent: _textAnimationController, curve: const Interval(.7, 1));
  }

  _setUpLoginAnimation() async {
    _loginAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _loginAnimationDuration),
    );

    _loginContainerAnimation = CurvedAnimation(
        parent: _loginAnimationController, curve: const Interval(0, 1));
  }

  _setUpDoughnutAnimation() async {
    _doughnutAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _doughnutAnimationDuration),
    );

    _doughnut1Animation = CurvedAnimation(
        parent: _doughnutAnimationController, curve: const Interval(.25, .55));
    _doughnut2Animation = CurvedAnimation(
        parent: _doughnutAnimationController, curve: const Interval(.35, .8));
    _doughnut3Animation = CurvedAnimation(
        parent: _doughnutAnimationController, curve: const Interval(.35, .8));
  }

  @override
  void initState() {
    super.initState();
    _setUpAnimation();
    _setUpDoughnutAnimation();
    _setUpTextAnimation();
    _setUpLoginAnimation();

    _splashAnimationController.forward();
    _doughnutAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 600), () {
      _textAnimationController.forward();
    });

    _textAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _doughnutAnimationController.reverse();
        });
        Future.delayed(const Duration(milliseconds: 1500), () {
          _loginAnimationController.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    _splashAnimationController.dispose();
    _doughnutAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge(
          [
            _splashAnimationController,
            _doughnutAnimationController,
            _textAnimationController,
            _loginAnimationController,
          ],
        ),
        builder: (context, child) {
          return Stack(
            children: [
              Container(
                color: Colors.white,
              ),
              Positioned(
                top: (-size.height * 1.1 * (1 - _shadeAnimation.value))
                    .clamp(-size.height * 1.1, -size.height * .9),
                left: -size.height * 1 / 2,
                child: CircularGradientWidget(shadeAnimation: _shadeAnimation),
              ),

              Positioned(
                right: -size.width,
                bottom: (-size.height * 1.1 * (1 - _shadeAnimation.value))
                    .clamp(-size.height * 1.1, -size.height * 0.3),
                child: CircularGradientWidget(shadeAnimation: _shadeAnimation),
              ),
              // CustomPaint(
              //   size: Size(size.width, size.height),
              //   painter: TopRectangularShapePainter(
              //     // .22 is maximum
              //     heightScaleValue: .22 * _shadeAnimation.value,
              //     colorOpacity: _shadeAnimation.value,
              //   ),
              // ),
              // CustomPaint(
              //   size: Size(size.width, size.height),
              //   painter: BottomRectangularShapePainter(
              //     // -.30 is maximum
              //     // heightScaleValue: -.301 * _shadeAnimation.value,
              //     heightScaleValue: -.30 * _shadeAnimation.value,
              //     colorOpacity: _shadeAnimation.value,
              //   ),
              // ),

              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _shadeAnimation.value == 1 ? 0 : 8.0,
                  sigmaY: _shadeAnimation.value == 1 ? 0 : 8.0,
                ),
                child: const SizedBox(),
              ),
              Positioned(
                bottom: 250 * _doughnut1Animation.value,
                top: -10,
                right: 180 * (1 - _doughnut1Animation.value),
                left: -(size.width + 60),
                child: Opacity(
                  opacity: _doughnut1Animation.value,
                  child: const CircularDoughnutWidget(),
                ),
              ),
              Positioned(
                left: (370 * (1 - _doughnut2Animation.value)).clamp(210, 370),
                top: -size.height *
                    (1.35 * (1 - _doughnut2Animation.value)).clamp(.72, 1.35),
                bottom: 0,
                child: Opacity(
                  opacity: _doughnut2Animation.value,
                  child: const CircularDoughnutWidget(
                    outerRadius: 180,
                    innerRadius: 75,
                  ),
                ),
              ),
              Positioned(
                bottom: -1 *
                    ((250 * (1 - _doughnut3Animation.value)).clamp(145, 250)),
                left: -1 *
                    ((160 * (1 - _doughnut3Animation.value)).clamp(110, 160)),
                child: Opacity(
                  opacity: _doughnut3Animation.value,
                  child: Column(
                    children: [
                      Transform.rotate(
                        alignment: Alignment.center,
                        angle: pi * .13,
                        child: Padding(
                          padding: EdgeInsets.only(left: size.width * .5),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    Colors.red.shade700.withOpacity(0.4),
                                radius: 42,
                              ),
                              const SizedBox(width: 20),
                              CircleAvatar(
                                backgroundColor:
                                    Colors.red.shade700.withOpacity(0.4),
                                radius: 42,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),
                      const CircularDoughnutWidget(
                        outerRadius: 170,
                        innerRadius: 70,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: _loginContainerAnimation.value > 0
                    ? size.height *
                        (.7 * (_loginContainerAnimation.value)).clamp(.52, .7)
                    : size.height *
                        (.52 * (_splashTitleAnimation.value)).clamp(.43, .52),
                child: AnimatedOpacity(
                  opacity: _splashTitleShowAnimation.value,
                  duration: const Duration(milliseconds: 1800),
                  child: const Text(
                    "evenkoo",
                    textScaleFactor: 1.55,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      letterSpacing: .6,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 50,
                right: 10,
                child: AnimatedOpacity(
                  opacity: _loginContainerAnimation.value,
                  duration: const Duration(milliseconds: 800),
                  child: const Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Skip",
                            textScaleFactor: 1.2,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10.0,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 10.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                bottom:
                    (-size.height * .5 * (1 - _loginContainerAnimation.value))
                        .clamp(-size.height * .5, 0),
                child: AnimatedOpacity(
                  opacity: _loginContainerAnimation.value,
                  duration: const Duration(milliseconds: 800),
                  child: const LoginContainerWidget(),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class LoginContainerWidget extends StatelessWidget {
  const LoginContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 2,
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 25),
            const Text(
              "Welcome to Demo App, \n Sign in to continue",
              textScaleFactor: 1.1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                letterSpacing: .2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            const SignInIconButtonWidget(
              label: "Continue with Facebook",
            ),
            const SizedBox(height: 15),
            const SignInIconButtonWidget(
              label: "Continue with Apple",
              iconData: Icons.apple,
              color: Colors.black,
            ),
            const SizedBox(height: 15),
            SignInIconButtonWidget(
              label: "Sign In",
              color: Colors.red.shade400,
              showIcon: false,
            ),
            const SizedBox(height: 30),
            RichText(
              text: TextSpan(
                text: "Don't have an account, ",
                style: const TextStyle(
                  fontSize: 14.0,
                  letterSpacing: .4,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(
                    text: "Connect with us",
                    style: TextStyle(
                      color: Colors.red.shade600,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SignInIconButtonWidget extends StatelessWidget {
  const SignInIconButtonWidget({
    super.key,
    this.iconData,
    required this.label,
    this.color,
    this.showIcon = true,
  });

  final IconData? iconData;
  final String label;
  final Color? color;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color ?? Colors.grey.shade100,
        ),
        child: Row(
          children: [
            if (showIcon == true)
              Icon(
                iconData ?? Icons.facebook,
                color: color != null ? Colors.white : Colors.black,
                size: 26.0,
              ),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  color: color != null ? Colors.white : Colors.black,
                  letterSpacing: .5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularGradientWidget extends StatelessWidget {
  const CircularGradientWidget({
    super.key,
    required Animation<double> shadeAnimation,
  }) : _shadeAnimation = shadeAnimation;

  final Animation<double> _shadeAnimation;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      child: Container(
        width: size.height * 1.5,
        height: size.height * 1.5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            radius: _shadeAnimation.value,
            center: Alignment.center, // near the top right
            colors: [
              const Color(0xFFff0000).withOpacity(1),
              const Color(0xFFff1a1a)
                  .withOpacity(animateOpacity(.6, _shadeAnimation.value)),
              const Color(0xFFff6666)
                  .withOpacity(animateOpacity(.4, _shadeAnimation.value)),
              const Color(0xFFffe6e6)
                  .withOpacity(animateOpacity(.4, _shadeAnimation.value)),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularDoughnutWidget extends StatelessWidget {
  const CircularDoughnutWidget({
    super.key,
    this.outerRadius = 130,
    this.innerRadius = 55,
    this.gradient,
  });

  final double outerRadius;
  final double innerRadius;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: outerRadius,
      ),
      decoration: BoxDecoration(
        gradient: gradient,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.red.shade700.withOpacity(0.5),
            radius: outerRadius,
          ),
          CircleAvatar(
            backgroundColor: const Color(0xFFff0000),
            radius: innerRadius,
          ),
        ],
      ),
    );
  }
}

class BottomRectangularShapePainter extends CustomPainter {
  BottomRectangularShapePainter({
    this.color = Colors.grey,
    this.strokeWidth = 0,

    /// set left align height
    /// decrease value to increase height and vice versa
    this.leftAlignHeight = .85,

    /// set right align height
    /// decrease value to increase height and vice versa
    this.rightAlignHeight = .59,
    this.heightScaleValue = 0.2,
    this.colorOpacity = 0,
  });

  final Color color;
  final double strokeWidth;
  final double leftAlignHeight;
  final double rightAlignHeight;
  final double heightScaleValue;
  final double colorOpacity;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = colorOpacity == 1
          ? null
          : LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                const Color(0xFFff0000)
                    .withOpacity(animateOpacity(0.6, colorOpacity)),
                const Color(0xFFff1a1a)
                    .withOpacity(animateOpacity(0.5, colorOpacity)),
                const Color(0xFFff3333)
                    .withOpacity(animateOpacity(0.3, colorOpacity)),
                const Color(0xFFff4d4d)
                    .withOpacity(animateOpacity(0.1, colorOpacity)),
                const Color(0xFFff6666)
                    .withOpacity(animateOpacity(0.1, colorOpacity)),
                const Color(0xFFff8080)
                    .withOpacity(animateOpacity(0.1, colorOpacity)),
                const Color(0xFFff9999)
                    .withOpacity(animateOpacity(0.1, colorOpacity)),
                const Color(0xFFffb3b3)
                    .withOpacity(animateOpacity(0.1, colorOpacity)),
                const Color(0xFFffcccc)
                    .withOpacity(animateOpacity(0.1, colorOpacity)),
                const Color(0xFFffe6e6)
                    .withOpacity(animateOpacity(0.1, colorOpacity)),
                const Color(0xFFffffff)
                    .withOpacity(animateOpacity(0.1, colorOpacity)),
              ],
            ).createShader(rect)
      ..color = Colors.red
      ..strokeWidth = 2
      // Use [PaintingStyle.fill] if you want the circle to be filled.
      ..style = PaintingStyle.fill;

    Path path2 = Path();

    /// initial height
    path2.moveTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.lineTo(0, size.height * (leftAlignHeight + heightScaleValue));
    // decrease y axis to increase height
    path2.lineTo(
        size.width, size.height * (rightAlignHeight + heightScaleValue));
    path2.close();
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

double animateOpacity(double prevValue, double value) {
  double val = 0.0;
  if (value > prevValue) {
    val = value;
  } else {
    val = prevValue;
  }
  return val;
}

class TopRectangularShapePainter extends CustomPainter {
  TopRectangularShapePainter({
    this.color = Colors.grey,
    this.strokeWidth = 0,

    /// set left align height
    /// decrease value to increase height and vice versa
    this.leftAlignHeight = .33,

    /// set right align height
    /// decrease value to increase height and vice versa
    this.rightAlignHeight = .07,
    this.heightScaleValue = 0,
    this.colorOpacity = 0,
  });

  final Color color;
  final double strokeWidth;
  final double leftAlignHeight;
  final double rightAlignHeight;
  final double heightScaleValue;
  final double colorOpacity;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final paint = Paint()
      ..shader = colorOpacity == 1
          ? null
          : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFff0000)
                    .withOpacity(animateOpacity(0.6, colorOpacity)),
                const Color(0xFFff1a1a)
                    .withOpacity(animateOpacity(0.5, colorOpacity)),
                const Color(0xFFff3333)
                    .withOpacity(animateOpacity(0.3, colorOpacity)),
                const Color(0xFFff4d4d)
                    .withOpacity(animateOpacity(0.1, colorOpacity)),
                const Color(0xFFff6666)
                    .withOpacity(animateOpacity(0.1, colorOpacity)),
                const Color(0xFFff8080)
                    .withOpacity(animateOpacity(0.1, colorOpacity)),
                const Color(0xFFff9999)
                    .withOpacity(animateOpacity(0.1, colorOpacity)),
                const Color(0xFFffb3b3)
                    .withOpacity(animateOpacity(0.1, colorOpacity)),
                const Color(0xFFffcccc)
                    .withOpacity(animateOpacity(0.1, colorOpacity)),
                const Color(0xFFffe6e6)
                    .withOpacity(animateOpacity(0.1, colorOpacity)),
                const Color(0xFFffffff)
                    .withOpacity(animateOpacity(0.1, colorOpacity)),
              ],
            ).createShader(rect)
      ..color = Colors.red
      ..strokeWidth = 2
      // Use [PaintingStyle.fill] if you want the circle to be filled.
      ..style = PaintingStyle.fill;

    Path path2 = Path();

    /// initial height
    path2.moveTo(size.width, 0);
    path2.lineTo(0, 0);
    path2.lineTo(0, size.height * (leftAlignHeight + heightScaleValue));
    path2.lineTo(
        size.width, size.height * (rightAlignHeight + heightScaleValue));
    // path2.lineTo(0, size.height * (leftAlignHeight + heightScaleValue));
    path2.close();
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
