import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/repositories/scan_repository.dart';
import '../../models/scan_result.dart';
import 'result_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  final ScanRepository _repository = ScanRepository();
  bool _isScanning = false; //in case it double scan
  bool _torchOn = false; //flashlight on/off

  // called automatically when QR code is detected
  void _onDetect(BarcodeCapture capture) async {
    if (_isScanning) return;

    final String? url = capture.barcodes.first.rawValue;

    // check if it's a valid URL
    if (url == null ||
        (!url.startsWith('http://') && !url.startsWith('https://'))) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text(
            "This QR code doesn't contain a link — nothing to check.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _isScanning = true;
    });

    // run the scan
    final ScanResult result = await _repository.scan(url, 'qr');

    // navigate to result screen
    //use mounted in case user go BACK to another screen, so the current screen has been removed by that
    if (mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultScreen(scan: result)),
      );

      // reset flag when coming back from result screen, User comes back
      setState(() => _isScanning = false);
    }
  }

  // toggle flashlight on/off
  void _toggleTorch() {
    _controller.toggleTorch();
    setState(() => _torchOn = !_torchOn);
  }

  // scan from gallery image
  void _scanFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await _controller.analyzeImage(image.path);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        title: const Text('Scan QR Code'),
      ),
      body: Column(
        children: [
          //camera view
          Expanded(
            child: MobileScanner(controller: _controller, onDetect: _onDetect),
          ),

          //bottom sheet controls
          Container(
            decoration: const BoxDecoration(color: Color(0xFF1E293B)),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 16),

                const Text(
                  'Camera controls',
                  style: TextStyle(
                    color: Color(0xFFE2E8F0),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                // flashlight + gallery buttons
                Row(
                  children: [
                    // flashlight
                    Expanded(
                      child: GestureDetector(
                        onTap: _toggleTorch,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                _torchOn
                                    ? Icons.flashlight_off
                                    : Icons.flashlight_on,
                                color: _torchOn
                                    ? const Color(0xFF6366F1)
                                    : const Color(0xFF94A3B8),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _torchOn ? 'Turn off' : 'Flashlight',
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // from gallery
                    Expanded(
                      child: GestureDetector(
                        onTap: _scanFromGallery,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.photo, color: Color(0xFF94A3B8)),
                              SizedBox(height: 4),
                              Text(
                                'From gallery',
                                style: TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // info tip
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color(0xFF6366F1),
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'The link inside the QR code will be checked automatically. No need to tap anything.',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
