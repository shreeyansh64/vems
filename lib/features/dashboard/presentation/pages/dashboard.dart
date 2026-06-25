import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vems/features/dashboard/domain/model/dashboard_registration_model.dart';
import 'package:vems/features/dashboard/presentation/bloc/dashboard_bloc.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static const Color _ground = Color(0xFFF4F7FC);
  static const Color _panel = Color(0xFF0C1A2E);
  static const Color _ink = Color(0xFF0C1A2E);
  static const Color _muted = Color(0xFF5A6B85);
  static const Color _hint = Color(0xFF9AA8BF);
  static const Color _hairline = Color(0xFFE4E9F2);
  static const Color _accent = Color(0xFF1E50E5);
  static const Color _green = Color(0xFF34D399);
  static const Color _onPanelMuted = Color(0xFF8497B5);
  static const String _mono = 'monospace';

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(GetRegistrationStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.status == DashboardStatus.loading) {
          return const Scaffold(
            backgroundColor: _ground,
            body: Center(
              child: CupertinoActivityIndicator(
                radius: 14,
                color: _accent,
              ),
            ),
          );
        }

        final registrations = state.registration ?? [];

        return Scaffold(
          backgroundColor: _ground,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    center: Alignment(0.7, -1.2),
                    radius: 1.4,
                    colors: [Color(0xFF163056), _panel],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _panel.withValues(alpha: 0.30),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF2A5BFF), Color(0xFF1230A8)],
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
                            Icons.directions_car_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'VEMS',
                              style: TextStyle(
                                fontFamily: _mono,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 3.0,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'VEHICLE ENTRY MANAGEMENT',
                              style: TextStyle(
                                fontFamily: _mono,
                                fontSize: 9,
                                color: _onPanelMuted,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.6,
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
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: _green.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              _Dot(color: _green, size: 6),
                              SizedBox(width: 6),
                              Text(
                                'LIVE',
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
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'REGISTRATION STATUS',
                            style: TextStyle(
                              fontFamily: _mono,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _muted,
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(height: 1, color: _hairline),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (state.status == DashboardStatus.error)
                        Text(
                          state.errorMessage ?? 'Something went wrong',
                          style: const TextStyle(color: Color(0xFFDC2626)),
                        )
                      else if (registrations.isEmpty)
                        Text(
                          'No registrations found',
                          style: const TextStyle(color: _hint),
                        )
                      else
                        ...registrations.map(
                          (r) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _statusCard(r),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statusCard(DashboardRegistrationModel registration) {
    final status = registration.status;
    final color = _statusColor(status);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _hairline, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: _panel.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _statusIcon(status),
                            color: color,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _statusLabel(status),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _statusDescription(status),
                      style: const TextStyle(
                        fontSize: 13,
                        color: _muted,
                        height: 1.5,
                      ),
                    ),
                    if (status == 'REJECTED' &&
                        registration.rejectionReason != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626).withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFDC2626).withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          registration.rejectionReason!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFFDC2626),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'APPROVED':
        return const Color(0xFF34D399);
      case 'REJECTED':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF1E50E5);
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'APPROVED':
        return Icons.check_circle_outline_rounded;
      case 'REJECTED':
        return Icons.cancel_outlined;
      default:
        return Icons.hourglass_empty_rounded;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'APPROVED':
        return 'Approved';
      case 'REJECTED':
        return 'Rejected';
      default:
        return 'Under Review';
    }
  }

  String _statusDescription(String status) {
    switch (status) {
      case 'APPROVED':
        return 'Your vehicle has been approved. You may enter the campus.';
      case 'REJECTED':
        return 'Your registration was rejected. See the reason below.';
      default:
        return "Your application is being reviewed by the admin. You'll receive an email once it's processed.";
    }
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