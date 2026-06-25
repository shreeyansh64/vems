import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:vems/scanner_page.dart';

class VehicleScannerScreen extends StatefulWidget {
  const VehicleScannerScreen({super.key});

  @override
  State<VehicleScannerScreen> createState() => _VehicleScannerScreenState();
}

class _VehicleScannerScreenState extends State<VehicleScannerScreen> {
  static const Color _accent = Color(0xFF1E50E5);
  static const Color _green = Color(0xFF34D399);
  static const Color _ink = Color(0xFF0C1A2E);
  static const Color _muted = Color(0xFF5A6B85);
  static const Color _hint = Color(0xFF9AA8BF);
  static const Color _field = Color(0xFFF7F9FD);
  static const Color _hairline = Color(0xFFE4E9F2);
  static const String _mono = 'monospace';

  final baseUrl = dotenv.env['BASE_URL'];
  final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final regex = RegExp(r'[A-Z]{2}[0-9]{1,2}[A-Z]{1,3}[0-9]{1,4}');

  CameraController? _camera;
  bool _processing = false;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    _camera = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21,
    );
    await _camera!.initialize();
    await _camera!.startImageStream(_scan);
    if (mounted) setState(() {});
  }

  Future<void> _scan(CameraImage image) async {
    if (_processing || _dialogShown) return;
    _processing = true;

    try {
      final input = InputImage.fromBytes(
        bytes: image.planes.first.bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );

      final result = await recognizer.processImage(input);
      final clean = result.text.toUpperCase().replaceAll(
        RegExp(r'[^A-Z0-9]'),
        '',
      );
      final match = regex.firstMatch(clean);

      if (match != null && mounted && !_dialogShown) {
        final number = match.group(0)!;
        _dialogShown = true;
        await _camera?.stopImageStream();
        await _showFoundDialog(number);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    _processing = false;
  }

  Future<void> _showFoundDialog(String number) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
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
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: _green.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.document_scanner_rounded,
                  color: _green,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Plate Detected',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Confirm and verify this number plate.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: _muted, height: 1.4),
              ),
              const SizedBox(height: 20),
              const Text(
                'NUMBER PLATE',
                style: TextStyle(
                  fontFamily: _mono,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                  color: _hint,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _field,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _hairline, width: 1.5),
                ),
                child: Text(
                  number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: _mono,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3,
                    color: _accent,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: _accent.withValues(alpha: 0.38),
                        blurRadius: 18,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
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
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ScannerPage(number: number),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_rounded, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Verify Vehicle',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Rescan
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  _dialogShown = false;
                  await _camera?.startImageStream(_scan);
                },
                child: const Text(
                  'Rescan',
                  style: TextStyle(
                    color: _muted,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _camera?.stopImageStream();
    _camera?.dispose();
    recognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_camera == null || !_camera!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF1E50E5),
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: CameraPreview(_camera!)),

          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.35)),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'SCAN PLATE',
                      style: TextStyle(
                        fontFamily: _mono,
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 38),
                  ],
                ),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 300,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _accent, width: 2.5),
                    color: Colors.transparent,
                  ),
                  child: Stack(
                    children: [
                      ..._corners(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Align the number plate within the frame',
                    style: TextStyle(
                      fontFamily: _mono,
                      color: Colors.white70,
                      fontSize: 11,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _corners() {
    const size = 20.0;
    const w = 3.0;
    const c = Colors.white;
    const r = 4.0;

    return [
      // Top-left
      Positioned(
        top: 0,
        left: 0,
        child: _CornerBracket(size: size, w: w, color: c, topLeft: true),
      ),
      // Top-right
      Positioned(
        top: 0,
        right: 0,
        child: _CornerBracket(size: size, w: w, color: c, topRight: true),
      ),
      // Bottom-left
      Positioned(
        bottom: 0,
        left: 0,
        child: _CornerBracket(size: size, w: w, color: c, bottomLeft: true),
      ),
      // Bottom-right
      Positioned(
        bottom: 0,
        right: 0,
        child: _CornerBracket(size: size, w: w, color: c, bottomRight: true),
      ),
    ];
  }
}

class _CornerBracket extends StatelessWidget {
  final double size, w;
  final Color color;
  final bool topLeft, topRight, bottomLeft, bottomRight;

  const _CornerBracket({
    required this.size,
    required this.w,
    required this.color,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _BracketPainter(
          w: w,
          color: color,
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
        ),
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  final double w;
  final Color color;
  final bool topLeft, topRight, bottomLeft, bottomRight;

  _BracketPainter({
    required this.w,
    required this.color,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final s = size.width;

    if (topLeft) {
      canvas.drawLine(Offset(0, s), Offset(0, 0), paint);
      canvas.drawLine(Offset(0, 0), Offset(s, 0), paint);
    }
    if (topRight) {
      canvas.drawLine(Offset(s, s), Offset(s, 0), paint);
      canvas.drawLine(Offset(s, 0), Offset(0, 0), paint);
    }
    if (bottomLeft) {
      canvas.drawLine(Offset(0, 0), Offset(0, s), paint);
      canvas.drawLine(Offset(0, s), Offset(s, s), paint);
    }
    if (bottomRight) {
      canvas.drawLine(Offset(s, 0), Offset(s, s), paint);
      canvas.drawLine(Offset(s, s), Offset(0, s), paint);
    }
  }

  @override
  bool shouldRepaint(_BracketPainter old) => false;
}
