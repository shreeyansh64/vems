import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vems/app_root.dart';
import 'package:vems/features/session/presentation/bloc/session_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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

  // ── VEMS console palette ─────────────────────────────────────
  static const Color _bg = Color(0xFF0C1A2E);
  static const Color _bgDeep = Color(0xFF07101F);
  static const Color _bgLift = Color(0xFF15294A);
  static const Color _cobalt = Color(0xFF2A5BFF);
  static const Color _cobaltSoft = Color(0xFF5FA0FF);
  static const Color _green = Color(0xFF34D399);
  static const String _mono = 'monospace';

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
      CurvedAnimation(
        parent: _scanController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );
    _bracketScale = Tween<double>(begin: 1.1, end: 1.0).animate(
      CurvedAnimation(
        parent: _scanController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scanController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    _ringScale = Tween<double>(
      begin: 1.0,
      end: 1.35,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
    _ringOpacity = Tween<double>(
      begin: 0.5,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));

    _exitOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeIn));

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
          pageBuilder: (_, __, ___) => BlocProvider.value(
            value: context.read<SessionBloc>(),
            child: AppRoot(),
          ),
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
    const logoSize = 200.0;

    // accent shifts cobalt → green the moment verification lands
    final Color accent = _verified ? _green : _cobalt;

    return Scaffold(
      backgroundColor: _bg,
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
                // depth gradient ground
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(0, -0.35),
                        radius: 1.1,
                        colors: [_bgLift, _bg, _bgDeep],
                        stops: [0.0, 0.55, 1.0],
                      ),
                    ),
                  ),
                ),

                CustomPaint(
                  size: size,
                  painter: _GridPainter(opacity: _logoOpacity.value * 0.05),
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
                            // soft glow behind the mark (warms on verify)
                            Container(
                              width: logoSize + 70,
                              height: logoSize + 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    accent.withOpacity(
                                        0.28 * _logoOpacity.value),
                                    accent.withOpacity(0.0),
                                  ],
                                  stops: const [0.0, 1.0],
                                ),
                              ),
                            ),

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
                                        color: _green,
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
                                          ? _green
                                          : _cobaltSoft.withOpacity(0.7),
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
                                        _cobaltSoft.withOpacity(0.95),
                                        Colors.transparent,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _cobaltSoft.withOpacity(0.5),
                                        blurRadius: 8,
                                      ),
                                    ],
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
                                      children: const [
                                        Icon(
                                          Icons.verified_rounded,
                                          color: _green,
                                          size: 16,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'SYSTEM READY',
                                          style: TextStyle(
                                            fontFamily: _mono,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: _green,
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
                                            color: _cobaltSoft.withOpacity(0.7),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'VERIFYING',
                                          style: TextStyle(
                                            fontFamily: _mono,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: _cobaltSoft.withOpacity(0.7),
                                            letterSpacing: 3.0,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              'AKGEC · VEHICLE ENTRY MANAGEMENT',
                              style: TextStyle(
                                fontFamily: _mono,
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.32),
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // bottom progress rail — cobalt while scanning, green when ready
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: 3,
                    width: size.width * _scanController.value,
                    decoration: BoxDecoration(
                      color: _verified ? _green : _cobalt,
                      boxShadow: [
                        BoxShadow(
                          color: (_verified ? _green : _cobalt)
                              .withOpacity(0.6),
                          blurRadius: 8,
                        ),
                      ],
                    ),
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
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    const len = 26.0;

    // top-left
    canvas.drawLine(Offset(0, len), Offset.zero, paint);
    canvas.drawLine(Offset.zero, Offset(len, 0), paint);
    // top-right
    canvas.drawLine(Offset(size.width - len, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, len), paint);
    // bottom-left
    canvas.drawLine(
      Offset(0, size.height - len),
      Offset(0, size.height),
      paint,
    );
    canvas.drawLine(Offset(0, size.height), Offset(len, size.height), paint);
    // bottom-right
    canvas.drawLine(
      Offset(size.width - len, size.height),
      Offset(size.width, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - len),
      Offset(size.width, size.height),
      paint,
    );
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
      ..color = const Color(0xFF5FA0FF).withOpacity(opacity)
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