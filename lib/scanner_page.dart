import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vems/features/auth/presentation/pages/login_page.dart';
import 'package:vems/scanner.dart';

class ScannerPage extends StatefulWidget {
  final String number;
  const ScannerPage({super.key, required this.number});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  static const Color _ground = Color(0xFFF4F7FC);
  static const Color _ink = Color(0xFF0C1A2E);
  static const Color _muted = Color(0xFF5A6B85);
  static const Color _hint = Color(0xFF9AA8BF);
  static const Color _field = Color(0xFFF7F9FD);
  static const Color _hairline = Color(0xFFE4E9F2);
  static const Color _accent = Color(0xFF1E50E5);
  static const Color _green = Color(0xFF34D399);
  static const Color _red = Color(0xFFDC2626);
  static const String _mono = 'monospace';

  final TextEditingController _textControl = TextEditingController();
  final baseUrl = dotenv.env['BASE_URL'];
  final Dio _dio = Dio();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _textControl.text = widget.number;
  }

  @override
  void dispose() {
    _textControl.dispose();
    super.dispose();
  }

  Future<void> _searchVehicle(String number) async {
    final query = number.trim();
    if (query.isEmpty) return;
    setState(() => _loading = true);
    try {
      final response = await _dio.get(
        '$baseUrl/api/search/vehicle/?vehicle_number=$query',
      );
      if (!mounted) return;
      _showResultDialog(response.data);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text(
            'Error: ${e.toString()}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showResultDialog(Map<String, dynamic> data) {
    final verified = data['verified'] == true;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: verified
                      ? _green.withValues(alpha: 0.10)
                      : _red.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  verified ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  size: 38,
                  color: verified ? _green : _red,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                verified ? 'Verified' : 'Not Verified',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                verified
                    ? 'This vehicle is registered and approved.'
                    : 'This vehicle could not be verified.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: _muted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // Plate
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _field,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _hairline, width: 1.5),
                ),
                child: Text(
                  data['vehicle_number'] ?? _textControl.text.trim(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: _mono,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3,
                    color: verified ? _accent : _red,
                  ),
                ),
              ),

              // Owner
              if (data['owner_name'] != null) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person_outline_rounded,
                      size: 15,
                      color: _muted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      data['owner_name'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: _ink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    _textControl.clear();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'refresh_token');
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginPage(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: _ground,
        appBar: AppBar(
          backgroundColor: _ground,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'VERIFICATION',
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'GATE CHECK',
                        style: TextStyle(
                          fontFamily: _mono,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.8,
                          color: _accent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Verify a vehicle',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.7,
                          color: _ink,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: 38,
                        height: 3,
                        decoration: BoxDecoration(
                          color: _accent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Enter a plate number or scan a QR code.',
                        style: TextStyle(
                          fontSize: 14.5,
                          color: _muted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                const Text(
                  'VEHICLE NUMBER',
                  style: TextStyle(
                    fontFamily: _mono,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                    color: _muted,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _textControl,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 15,
                    fontFamily: _mono,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: _inputDecoration(
                    hint: 'e.g. UP14 AB 2847',
                    icon: Icons.pin_outlined,
                  ),
                ),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: _loading
                      ? const Center(
                          child: CupertinoActivityIndicator(
                            radius: 13,
                            color: _accent,
                          ),
                        )
                      : DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: _accent.withValues(alpha: 0.40),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () => _searchVehicle(_textControl.text),
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
                                Icon(Icons.search_rounded, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Check Vehicle',
                                  style: TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    const Expanded(child: Divider(color: _hairline)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          fontFamily: _mono,
                          color: _hint,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: _hairline)),
                  ],
                ),
                const SizedBox(height: 28),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VehicleScannerScreen(),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                            color: _accent,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: _accent.withValues(alpha: 0.38),
                                blurRadius: 18,
                                offset: const Offset(0, 7),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.qr_code_scanner_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Scan QR',
                          style: TextStyle(
                            fontFamily: _mono,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            color: _muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _logout,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: _red.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                      backgroundColor: _red.withValues(alpha: 0.04),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded, size: 16, color: _red),
                        SizedBox(width: 8),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: _red,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.lock_outline_rounded, size: 11, color: _hint),
                      SizedBox(width: 6),
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    OutlineInputBorder b(Color c, double w) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: c, width: w),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: _hint,
        fontSize: 14,
        fontFamily: _mono,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      prefixIcon: Icon(icon, color: _accent, size: 20),
      filled: true,
      fillColor: _field,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: b(Colors.transparent, 0),
      enabledBorder: b(_hairline, 1.5),
      focusedBorder: b(_accent, 1.6),
    );
  }
}
