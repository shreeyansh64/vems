import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:vems/features/auth/presentation/bloc/register_bloc.dart';
import 'package:vems/features/auth/presentation/pages/register_set_password_page.dart';

class RegisterVerifyOtpPage extends StatefulWidget {
  const RegisterVerifyOtpPage({super.key});

  @override
  State<RegisterVerifyOtpPage> createState() => _RegisterVerifyOtpPageState();
}

class _RegisterVerifyOtpPageState extends State<RegisterVerifyOtpPage> {
  final otpController = TextEditingController();

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
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.verifyOtp) {
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (_, _, _) => const RegisterSetPasswordPage(),
              transitionsBuilder: (_, animation, _, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
            (route) => false,
          );
        } else if (state.status == RegisterStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFFDC2626),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              content: Text(
                state.errorMessage ?? 'Something went wrong',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final defaultPinTheme = PinTheme(
          width: 52,
          height: 56,
          textStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: _ink,
            fontFamily: _mono,
          ),
          decoration: BoxDecoration(
            color: _field,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _hairline, width: 1.5),
          ),
        );

        final focusedPinTheme = defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(color: _accent, width: 1.8),
            boxShadow: [
              BoxShadow(
                color: _accent.withValues(alpha: 0.18),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        );

        final submittedPinTheme = defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            color: _accent.withValues(alpha: 0.07),
            border: Border.all(color: _accent, width: 1.5),
          ),
        );

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: _ground,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: _ground,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'VERIFY OTP',
                style: TextStyle(
                  fontFamily: _mono,
                  color: _ink,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            body: SafeArea(
              child: state.status == RegisterStatus.loading
                  ? const Center(
                      child: CupertinoActivityIndicator(
                        radius: 14,
                        color: _accent,
                      ),
                    )
                  : SingleChildScrollView(
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
                            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(11),
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF2A5BFF),
                                            Color(0xFF1230A8),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF2A5BFF,
                                            ).withValues(alpha: 0.6),
                                            blurRadius: 14,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.mark_email_read_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 11),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'VEMS',
                                          style: TextStyle(
                                            fontFamily: _mono,
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 3.0,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'OTP VERIFICATION',
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 9,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _green.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        border: Border.all(
                                          color: _green.withValues(alpha: 0.35),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _Dot(color: _green, size: 6),
                                          SizedBox(width: 6),
                                          Text(
                                            'STEP 2/3',
                                            style: TextStyle(
                                              fontFamily: _mono,
                                              color: Color(0xFFBFF3D6),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                Row(
                                  children: [
                                    _stepDot(
                                      active: false,
                                      done: true,
                                      label: '01',
                                    ),
                                    _stepLine(active: true),
                                    _stepDot(
                                      active: true,
                                      done: false,
                                      label: '02',
                                    ),
                                    _stepLine(active: false),
                                    _stepDot(
                                      active: false,
                                      done: false,
                                      label: '03',
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    2,
                                    11,
                                    2,
                                    4,
                                  ),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: Color(0x14FFFFFF)),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const _Dot(color: _green, size: 6),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'OTP SENT',
                                        style: TextStyle(
                                          fontFamily: _mono,
                                          color: _onPanelMuted,
                                          fontSize: 10.5,
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        context
                                                .read<RegisterBloc>()
                                                .state
                                                .email ??
                                            '',
                                        style: const TextStyle(
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
                                  'CHECK YOUR INBOX',
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
                                  'Enter the code',
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
                                    'We sent a 6-digit code to your college email. It expires in 10 minutes.',
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

                          const SizedBox(height: 30),

                          const Text(
                            'ENTER 6-DIGIT CODE',
                            style: TextStyle(
                              fontFamily: _mono,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                              color: _muted,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Center(
                            child: Pinput(
                              length: 6,
                              controller: otpController,
                              defaultPinTheme: defaultPinTheme,
                              focusedPinTheme: focusedPinTheme,
                              submittedPinTheme: submittedPinTheme,
                              onCompleted: (otp) {
                                context.read<RegisterBloc>().add(
                                  VerifyOtpEvent(
                                    email: context
                                        .read<RegisterBloc>()
                                        .state
                                        .email!,
                                    otp: otp,
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.timer_outlined,
                                  size: 13,
                                  color: _hint,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'CODE EXPIRES IN 10 MINUTES',
                                  style: TextStyle(
                                    fontFamily: _mono,
                                    fontSize: 10.5,
                                    color: _hint,
                                    letterSpacing: 0.5,
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

  Widget _stepDot({
    required bool active,
    required bool done,
    required String label,
  }) {
    final bg = done
        ? _green
        : active
        ? _accent
        : const Color(0xFF1E2D45);
    final textColor = (done || active) ? Colors.white : _onPanelMuted;
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        boxShadow: active
            ? [
                BoxShadow(
                  color: _accent.withValues(alpha: 0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          done ? '✓' : label,
          style: TextStyle(
            fontFamily: _mono,
            color: textColor,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _stepLine({required bool active}) {
    return Expanded(
      child: Container(
        height: 2,
        color: active ? _accent : const Color(0xFF1E2D45),
      ),
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
