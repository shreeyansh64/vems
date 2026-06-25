import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vems/app_root.dart';
import 'package:vems/features/auth/presentation/bloc/login_bloc.dart';
import 'package:vems/features/auth/presentation/pages/register_email.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;

  late final AnimationController _scanCtrl;
  static const Color _ground = Color(0xFFF4F7FC);
  static const Color _panel = Color(0xFF0C1A2E);
  static const Color _ink = Color(0xFF0C1A2E);
  static const Color _muted = Color(0xFF5A6B85);
  static const Color _hint = Color(0xFF9AA8BF);
  static const Color _field = Color(0xFFF7F9FD);
  static const Color _hairline = Color(0xFFE4E9F2);
  static const Color _accent = Color(0xFF1E50E5);
  static const Color _green = Color(0xFF34D399);
  static const Color _onPanelMuted = Color(0xFF8497B5);
  static const String _mono = 'monospace';

  @override
  void initState() {
    super.initState();
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (_, _, _) => const AppRoot(),
              transitionsBuilder: (_, animation, _, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
            (route) => false,
          );
        } else if (state.status == LoginStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFFDC2626),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              content: Text(
                state.error ?? 'Something went wrong',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: _ground,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const RadialGradient(
                          center: Alignment(0.7, -1.2),
                          radius: 1.4,
                          colors: [Color(0xFF163056), _panel],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _panel.withValues(alpha: 0.35),
                            blurRadius: 30,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'VEMS',
                                    style: TextStyle(
                                      fontFamily: _mono,
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 3.0,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'VEHICLE ENTRY',
                                    style: TextStyle(
                                      fontFamily: _mono,
                                      color: _onPanelMuted,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.8,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: SvgPicture.asset(
                                  'assets/si-logo.svg',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: AnimatedBuilder(
                              animation: _scanCtrl,
                              builder: (context, _) {
                                return CustomPaint(
                                  painter: _PlatePainter(_scanCtrl.value),
                                );
                              },
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.fromLTRB(2, 11, 2, 4),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color(0x14FFFFFF)),
                              ),
                            ),
                            child: Row(
                              children: const [
                                _Dot(color: _green, size: 6),
                                SizedBox(width: 8),
                                Text(
                                  'VERIFY AT ENTRY',
                                  style: TextStyle(
                                    fontFamily: _mono,
                                    color: _onPanelMuted,
                                    fontSize: 10.5,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  'Records synced · AKGEC',
                                  style: TextStyle(
                                    fontFamily: _mono,
                                    color: Color(0xFFBFE9CF),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'CAMPUS VEHICLE ENTRY',
                            style: TextStyle(
                              fontFamily: _mono,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.8,
                              color: _accent,
                            ),
                          ),
                          const SizedBox(height: 11),
                          const Text(
                            'Welcome back',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.7,
                              color: _ink,
                              height: 1.05,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: 38,
                            height: 3,
                            decoration: BoxDecoration(
                              color: _accent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const SizedBox(
                            width: 260,
                            child: Text(
                              'Sign in to register your vehicle documents and manage gate entries.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.5,
                                color: _muted,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 26),

                    _label('EMAIL ADDRESS'),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: const TextStyle(color: _ink, fontSize: 15),
                      decoration: _decoration(
                        hint: 'yourname@akgec.ac.in',
                        icon: Icons.mail_outline_rounded,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email required';
                        }
                        if (!value.endsWith('@akgec.ac.in')) {
                          return 'Only @akgec.ac.in allowed';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    _label('PASSWORD'),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: const TextStyle(color: _ink, fontSize: 15),
                      decoration: _decoration(
                        hint: 'Enter your password',
                        icon: Icons.lock_outline_rounded,
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: _muted,
                            size: 20,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: state.status == LoginStatus.loading
                          ? const Center(
                              child: CupertinoActivityIndicator(
                                radius: 14,
                                color: _accent,
                              ),
                            )
                          : DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: _accent.withValues(alpha: 0.45),
                                    blurRadius: 22,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (emailController.text.isEmpty ||
                                      passwordController.text.isEmpty) {
                                    return;
                                  }
                                  context.read<LoginBloc>().add(
                                    RequestLoginEvent(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _accent,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Sign in',
                                      style: TextStyle(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 9),
                                    Icon(Icons.arrow_forward_rounded, size: 18),
                                  ],
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        const Expanded(child: Divider(color: _hairline)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              fontFamily: _mono,
                              color: _hint,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: _hairline)),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(color: _muted, fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, _, _) =>
                                      const RegisterEmail(),
                                  transitionsBuilder:
                                      (_, animation, _, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                ),
                              );
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: _accent,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.lock_outline_rounded,
                            size: 12,
                            color: _hint,
                          ),
                          SizedBox(width: 7),
                          Text(
                            'VEMS · By SHREEYANSH & AGRIM',
                            style: TextStyle(
                              fontFamily: _mono,
                              color: _hint,
                              fontSize: 10,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontFamily: _mono,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.0,
      color: _muted,
    ),
  );

  InputDecoration _decoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    OutlineInputBorder b(Color c, double w) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: c, width: w),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _hint, fontSize: 14),
      prefixIcon: Icon(icon, color: _accent, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: _field,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: b(Colors.transparent, 0),
      enabledBorder: b(_hairline, 1.5),
      focusedBorder: b(_accent, 1.6),
      errorBorder: b(const Color(0xFFDC2626), 1.3),
      focusedErrorBorder: b(const Color(0xFFDC2626), 1.6),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final double size;
  const _Dot({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _PlatePainter extends CustomPainter {
  final double sweep;
  _PlatePainter(this.sweep);

  void _text(
    Canvas c,
    String s,
    Offset center,
    double size,
    Color color,
    FontWeight weight,
  ) {
    final tp = TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: size,
          fontWeight: weight,
          color: color,
          letterSpacing: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    final grid = Paint()
      ..color = const Color(0x0BFFFFFF)
      ..strokeWidth = 1;
    for (double x = 0; x <= w; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), grid);
    }
    for (double y = 0; y <= h; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(w, y), grid);
    }

    final pw = math.min(w * 0.62, 210.0);
    const ph = 56.0;
    final px = (w - pw) / 2;
    final py = (h - ph) / 2 - 4;

    final fx = px - 16, fy = py - 18, fw = pw + 32, fh = ph + 36;
    const cc = 16.0;
    final br = Paint()
      ..color = const Color(0xFF5FA0FF)
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    void corner(Offset a, Offset b, Offset c) {
      canvas.drawPath(
        Path()
          ..moveTo(a.dx, a.dy)
          ..lineTo(b.dx, b.dy)
          ..lineTo(c.dx, c.dy),
        br,
      );
    }

    corner(Offset(fx, fy + cc), Offset(fx, fy), Offset(fx + cc, fy));
    corner(
      Offset(fx + fw - cc, fy),
      Offset(fx + fw, fy),
      Offset(fx + fw, fy + cc),
    );
    corner(
      Offset(fx, fy + fh - cc),
      Offset(fx, fy + fh),
      Offset(fx + cc, fy + fh),
    );
    corner(
      Offset(fx + fw - cc, fy + fh),
      Offset(fx + fw, fy + fh),
      Offset(fx + fw, fy + fh - cc),
    );

    final plate = RRect.fromRectAndRadius(
      Rect.fromLTWH(px, py, pw, ph),
      const Radius.circular(9),
    );
    canvas.drawShadow(
      Path()..addRRect(plate),
      Colors.black.withValues(alpha: 0.4),
      4,
      true,
    );
    canvas.drawRRect(plate, Paint()..color = const Color(0xFFF5F7FB));
    canvas.drawRRect(
      plate,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = const Color(0xFFC7D2E2),
    );

    canvas.save();
    canvas.clipRRect(plate);
    canvas.drawRect(
      Rect.fromLTWH(px, py, 22, ph),
      Paint()..color = const Color(0xFF1230A8),
    );
    canvas.restore();
    canvas.save();
    canvas.translate(px + 11, py + ph / 2);
    canvas.rotate(-math.pi / 2);
    _text(canvas, 'IND', Offset.zero, 8, Colors.white, FontWeight.w700);
    canvas.restore();

    _text(
      canvas,
      'A K G E C',
      Offset(px + 22 + (pw - 22) / 2, py + ph / 2),
      20,
      const Color(0xFF0C1A2E),
      FontWeight.w700,
    );

    final frame = RRect.fromRectAndRadius(
      Rect.fromLTWH(fx, fy, fw, fh),
      const Radius.circular(8),
    );
    final sy = fy + 10 + sweep * (fh - 20);
    canvas.save();
    canvas.clipRRect(frame);
    canvas.drawRect(
      Rect.fromLTWH(fx, sy - 18, fw, 36),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x005FA0FF), Color(0x2E5FA0FF), Color(0x005FA0FF)],
        ).createShader(Rect.fromLTWH(fx, sy - 18, fw, 36)),
    );
    canvas.drawLine(
      Offset(fx + 4, sy),
      Offset(fx + fw - 4, sy),
      Paint()
        ..color = const Color(0xE696C3FF)
        ..strokeWidth = 1.6,
    );
    canvas.restore();

    final bx = fx + fw, by = fy;
    canvas.drawCircle(
      Offset(bx, by),
      12,
      Paint()..color = _PlatePainter._green,
    );
    canvas.drawPath(
      Path()
        ..moveTo(bx - 4.5, by)
        ..lineTo(bx - 1, by + 3.5)
        ..lineTo(bx + 5, by - 4),
      Paint()
        ..color = const Color(0xFF06321F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  static const Color _green = Color(0xFF34D399);

  @override
  bool shouldRepaint(_PlatePainter old) => old.sweep != sweep;
}
