import 'package:flutter/material.dart';

/// Kính ngắm kiểu iCheck:
/// - Bo góc, viền trắng dày
/// - Nền tối xung quanh
/// - Dấu + ở tâm
/// - Thanh hành động phía dưới: Ảnh có sẵn / Pause-Resume / Torch / Switch cam
class ScanOverlay extends StatelessWidget {
  const ScanOverlay({
    super.key,
    required this.onPickImage,
    required this.onToggleTorch,
    required this.onSwitchCamera,
    this.isTorchOn = false,
    this.isTorchAvailable = true,
    this.hintText = 'Đưa mã QR/Barcode vào khung hình',
  });

  final VoidCallback onPickImage;
  final VoidCallback onToggleTorch;
  final VoidCallback onSwitchCamera;

  final bool isTorchOn;
  final bool isTorchAvailable;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final shortest = c.biggest.shortestSide;
        final boxSize = shortest * 0.68; // ~70% khung nhìn
        final borderRadius = 16.0;

        return Stack(
          children: [
            // Lớp tối + lỗ rỗng (khung quét)
            CustomPaint(
              size: c.biggest,
              painter: _ScannerOverlayPainter(
                boxSize: boxSize,
                borderRadius: borderRadius,
              ),
            ),

            // Dấu cộng ở giữa
            Center(
              child: IgnorePointer(
                ignoring: true,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: CustomPaint(painter: _CrosshairPainter()),
                ),
              ),
            ),

            // Gợi ý
            Positioned(
              bottom: 120,
              left: 20,
              right: 20,
              child: Center(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    hintText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Thanh hành động đáy (giống iCheck)
            Positioned(
              left: 12,
              right: 12,
              bottom: 20,
              child: _BottomActions(
                onPickImage: onPickImage,
                onToggleTorch: onToggleTorch,
                onSwitchCamera: onSwitchCamera,
                isTorchOn: isTorchOn,
                isTorchAvailable: isTorchAvailable,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Vẽ nền tối + khung rỗng bo góc + viền trắng đậm
class _ScannerOverlayPainter extends CustomPainter {
  _ScannerOverlayPainter({
    required this.boxSize,
    required this.borderRadius,
  });

  final double boxSize;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: boxSize, height: boxSize),
      Radius.circular(borderRadius),
    );

    // Nền tối
    final overlayPath = Path()..addRect(Offset.zero & size);
    final holePath = Path()..addRRect(rect);
    final diff = Path.combine(PathOperation.difference, overlayPath, holePath);
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.55);
    canvas.drawPath(diff, overlayPaint);

    // Viền trắng
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawRRect(rect, borderPaint);

    // “Notch” ở 4 góc (nhìn giống app iCheck)
    final notchPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;
    const notchLen = 24.0;
    final r = rect.outerRect;
    final tl = r.topLeft;
    final tr = r.topRight;
    final bl = r.bottomLeft;
    final br = r.bottomRight;

    // Top-left
    canvas.drawLine(tl, tl + const Offset(notchLen, 0), notchPaint);
    canvas.drawLine(tl, tl + const Offset(0, notchLen), notchPaint);
    // Top-right
    canvas.drawLine(tr, tr + const Offset(-notchLen, 0), notchPaint);
    canvas.drawLine(tr, tr + const Offset(0, notchLen), notchPaint);
    // Bottom-left
    canvas.drawLine(bl, bl + const Offset(notchLen, 0), notchPaint);
    canvas.drawLine(bl, bl + const Offset(0, -notchLen), notchPaint);
    // Bottom-right
    canvas.drawLine(br, br + const Offset(-notchLen, 0), notchPaint);
    canvas.drawLine(br, br + const Offset(0, -notchLen), notchPaint);
  }

  @override
  bool shouldRepaint(covariant _ScannerOverlayPainter oldDelegate) =>
      oldDelegate.boxSize != boxSize ||
          oldDelegate.borderRadius != borderRadius;
}

/// Dấu cộng ở tâm
class _CrosshairPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    final c = Offset(size.width / 2, size.height / 2);
    const len = 8.0;
    canvas.drawLine(Offset(c.dx - len, c.dy), Offset(c.dx + len, c.dy), p);
    canvas.drawLine(Offset(c.dx, c.dy - len), Offset(c.dx, c.dy + len), p);
  }

  @override
  bool shouldRepaint(covariant _CrosshairPainter oldDelegate) => false;
}

/// Thanh hành động dưới cùng
class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.onPickImage,
    required this.onToggleTorch,
    required this.onSwitchCamera,
    required this.isTorchOn,
    required this.isTorchAvailable,
  });

  final VoidCallback onPickImage;
  final VoidCallback onToggleTorch;
  final VoidCallback onSwitchCamera;

  final bool isTorchOn;
  final bool isTorchAvailable;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Ảnh có sẵn
        Expanded(
          child: _pillButton(
            context,
            icon: Icons.photo_library,
            label: 'Ảnh có sẵn',
            onPressed: onPickImage,
          ),
        ),
        const SizedBox(width: 8),
        // Torch
        _circleIconButton(
          context,
          icon: isTorchOn ? Icons.flash_on : Icons.flash_off,
          tooltip: isTorchAvailable ? 'Bật/Tắt đèn' : 'Đèn không khả dụng',
          onPressed: isTorchAvailable ? onToggleTorch : null,
        ),
        const SizedBox(width: 8),
        // Switch cam
        _circleIconButton(
          context,
          icon: Icons.cameraswitch,
          tooltip: 'Đổi camera',
          onPressed: onSwitchCamera,
        ),
      ],
    );
  }

  Widget _pillButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onPressed,
      }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }

  Widget _circleIconButton(
      BuildContext context, {
        required IconData icon,
        required String tooltip,
        required VoidCallback? onPressed,
      }) {
    return Tooltip(
      message: tooltip,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(12),
        ),
        onPressed: onPressed,
        child: Icon(icon),
      ),
    );
  }
}
