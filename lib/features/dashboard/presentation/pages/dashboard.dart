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
            backgroundColor: Color(0xFF0D0D0D),
            body: Center(
              child: CupertinoActivityIndicator(
                radius: 14,
                color: Color(0xFFFFAB00),
              ),
            ),
          );
        }

        final registrations = state.registration ?? [];

        return Scaffold(
          backgroundColor: const Color(0xFF0D0D0D),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header with gradient ──────────────────────────────────
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1C1A14), Color(0xFF0D0D0D)],
                  ),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF222222), width: 1),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Amber accent stripe
                        Container(
                          width: 4,
                          height: 36,
                          margin: const EdgeInsets.only(right: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFAB00),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'VEMS',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFE0E0E0),
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Vehicle Entry Management System',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF5A5A5A),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Body ──────────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section label + divider
                      Row(
                        children: [
                          const Text(
                            'REGISTRATION STATUS',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4A4A4A),
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: const Color(0xFF1E1E1E),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Content
                      if (state.status == DashboardStatus.error)
                        Text(
                          state.errorMessage ?? 'Something went wrong',
                          style: const TextStyle(color: Color(0xFFCF6679)),
                        )
                      else if (registrations.isEmpty)
                        const Text(
                          'No registrations found',
                          style: TextStyle(color: Color(0xFF6B6B6B)),
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
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E1E1E)),
      ),
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left accent bar
            Container(width: 4, color: color),

            // Card content
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
                            color: color.withOpacity(0.1),
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
                        color: Color(0xFF6B6B6B),
                        height: 1.5,
                      ),
                    ),
                    if (status == 'REJECTED' &&
                        registration.rejectionReason != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCF6679).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFCF6679).withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          registration.rejectionReason!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFFCF6679),
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
        return const Color(0xFF4CAF50);
      case 'REJECTED':
        return const Color(0xFFCF6679);
      default:
        return const Color(0xFFFFAB00);
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'APPROVED':
        return Icons.check_circle_outline;
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
