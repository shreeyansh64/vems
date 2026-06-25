import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
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
  final baseUrl = dotenv.env['BASE_URL'];

  CameraController? camera;

  final recognizer = TextRecognizer(script: TextRecognitionScript.latin);

  final dio = Dio();

  bool processing = false;

  final regex = RegExp(r'[A-Z]{2}[0-9]{1,2}[A-Z]{1,3}[0-9]{1,4}');

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    camera = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21,
    );

    await camera!.initialize();

    await camera!.startImageStream(scan);

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> scan(CameraImage image) async {
    if (processing) return;

    processing = true;

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

      if (match != null) {
        final number = match.group(0)!;

        await camera?.stopImageStream();

        if (mounted) {
          await showDialog(
            context: context,

            barrierDismissible: false,

            builder: (_) => AlertDialog(
              backgroundColor: const Color(0xFF1A1A1A),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),

                side: const BorderSide(color: Color(0xFF2A2A2A)),
              ),

              title: const Text(
                "Vehicle Found",

                style: TextStyle(
                  color: Color(0xFFE0E0E0),

                  fontSize: 18,

                  fontWeight: FontWeight.w700,
                ),
              ),

              content: Column(
                mainAxisSize: MainAxisSize.min,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "NUMBER PLATE",

                    style: TextStyle(
                      color: Color(0xFF6B6B6B),

                      fontSize: 11,

                      fontWeight: FontWeight.w600,

                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),

                      borderRadius: BorderRadius.circular(12),

                      border: Border.all(color: const Color(0xFF2A2A2A)),
                    ),

                    child: Text(
                      number,

                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        color: Color(0xFFFFAB00),

                        fontSize: 24,

                        fontWeight: FontWeight.w700,

                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),

              actions: [
                Padding(
                  padding: const EdgeInsets.all(12),

                  child: SizedBox(
                    width: double.infinity,

                    height: 52,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFAB00),

                        foregroundColor: const Color(0xFF0D0D0D),

                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),

                      onPressed: () {
                        Navigator.pop(context);

                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) => ScannerPage(number: number),
                          ),
                        );
                      },

                      child: const Text(
                        "VERIFY",

                        style: TextStyle(
                          fontWeight: FontWeight.w700,

                          fontSize: 15,

                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    processing = false;
  }

  @override
  void dispose() {
    camera?.stopImageStream();
    camera?.dispose();
    recognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (camera == null || !camera!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D0D0D),

        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFFAB00)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [
          Positioned.fill(child: CameraPreview(camera!)),

          Center(
            child: Container(
              width: 320,

              height: 160,

              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFFFAB00), width: 3),

                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
