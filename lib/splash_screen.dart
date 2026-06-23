import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vems/app_root.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late final AnimationController _scanController;
  late final AnimationController _logoController;
  late final AnimationController _pulseController;
  late final AnimationController _exitController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  late final Animation<double> _scanLine;

  late final Animation<double> _ringScale;
  late final Animation<double> _ringOpacity;

  late final Animation<double> _exitOpacity;

  late final Animation<double> _bracketOpacity;
  late final Animation<double> _bracketScale;

  late final Animation<double> _textOpacity;

  bool _verified = false;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scanLine = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );

    _bracketOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController,
          curve: const Interval(0.0, 0.3, curve: Curves.easeOut)),
    );
    _bracketScale = Tween<double>(begin: 1.1, end: 1.0).animate(
      CurvedAnimation(parent: _scanController,
          curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController,
          curve: const Interval(0.7, 1.0, curve: Curves.easeOut)),
    );

    _ringScale = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
    _ringOpacity = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );

    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeIn),
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 700));

    _scanController.forward();
    await Future.delayed(const Duration(milliseconds: 1300));

    if (mounted) setState(() => _verified = true);
    _pulseController.forward();
    await Future.delayed(const Duration(milliseconds: 800));

    await Future.delayed(const Duration(milliseconds: 600));

    _exitController.forward();
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => AppRoot(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _scanController.dispose();
    _pulseController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const amber = Color(0xFFFFAB00);
    const bg = Color(0xFF0D0D0D);
    const logoSize = 200.0;

    return Scaffold(
      backgroundColor: bg,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _logoController,
          _scanController,
          _pulseController,
          _exitController,
        ]),
        builder: (context, _) {
          return FadeTransition(
            opacity: _exitOpacity,
            child: Stack(
              children: [

                CustomPaint(
                  size: size,
                  painter: _GridPainter(opacity: _logoOpacity.value * 0.06),
                ),

                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      SizedBox(
                        width: logoSize + 80,
                        height: logoSize + 80,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [

                            if (_verified)
                              ScaleTransition(
                                scale: _ringScale,
                                child: FadeTransition(
                                  opacity: _ringOpacity,
                                  child: Container(
                                    width: logoSize + 60,
                                    height: logoSize + 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: amber,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            Opacity(
                              opacity: _bracketOpacity.value,
                              child: Transform.scale(
                                scale: _bracketScale.value,
                                child: SizedBox(
                                  width: logoSize + 40,
                                  height: logoSize + 40,
                                  child: CustomPaint(
                                    painter: _BracketPainter(
                                      color: _verified
                                          ? amber
                                          : amber.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            ScaleTransition(
                              scale: _logoScale,
                              child: FadeTransition(
                                opacity: _logoOpacity,
                                child: SizedBox(
                                  width: logoSize,
                                  height: logoSize,
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),

                            if (_scanController.value > 0 &&
                                _scanController.value < 0.95)
                              Positioned(
                                top: 20 + (_scanLine.value * (logoSize + 40)),
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        amber.withOpacity(0.9),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      FadeTransition(
                        opacity: _textOpacity,
                        child: Column(
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _verified
                                  ? Row(
                                      key: const ValueKey('verified'),
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.verified_rounded,
                                          color: amber,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'SYSTEM READY',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: amber,
                                            letterSpacing: 3.0,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      key: const ValueKey('scanning'),
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                          height: 10,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1.5,
                                            color: amber.withOpacity(0.6),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'INITIALIZING',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                amber.withOpacity(0.5),
                                            letterSpacing: 3.0,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              'AKGEC · Vehicle Entry Management',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.2),
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: 2,
                    width: size.width * _scanController.value,
                    color: amber,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  final Color color;
  _BracketPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    const len = 20.0;

    canvas.drawLine(Offset(0, len), Offset.zero, paint);
    canvas.drawLine(Offset.zero, Offset(len, 0), paint);

    canvas.drawLine(Offset(size.width - len, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, len), paint);

    canvas.drawLine(Offset(0, size.height - len), Offset(0, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(len, size.height), paint);

    canvas.drawLine(Offset(size.width - len, size.height),
        Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height - len),
        Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(_BracketPainter old) => old.color != color;
}

class _GridPainter extends CustomPainter {
  final double opacity;
  _GridPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0) return;
    final paint = Paint()
      ..color = const Color(0xFFFFAB00).withOpacity(opacity)
      ..strokeWidth = 0.5;

    const spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.opacity != opacity;
}