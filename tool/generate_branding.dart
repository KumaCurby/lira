// Génère les visuels de marque de « Lira » dans assets/branding/ :
//   - icon.png       : carré arrondi violet + éclair blanc (icône pleine)
//   - foreground.png : éclair blanc sur fond transparent (avant-plan / splash)
//
// Lancer avec :  flutter test tool/generate_branding.dart
// Puis :         dart run flutter_launcher_icons
//                dart run flutter_native_splash:create

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

// Éclair « zap » (Feather), coordonnées en espace 24, centrées sur (12,12).
const List<Offset> _boltPoints = [
  Offset(13, 2),
  Offset(3, 14),
  Offset(12, 14),
  Offset(11, 22),
  Offset(21, 10),
  Offset(12, 10),
];

Path _boltPath({required double scale, required Offset center}) {
  final path = Path();
  for (var i = 0; i < _boltPoints.length; i++) {
    final p = Offset(
      center.dx + (_boltPoints[i].dx - 12) * scale,
      center.dy + (_boltPoints[i].dy - 12) * scale,
    );
    if (i == 0) {
      path.moveTo(p.dx, p.dy);
    } else {
      path.lineTo(p.dx, p.dy);
    }
  }
  path.close();
  return path;
}

Future<Uint8List> _renderPng(void Function(Canvas canvas) draw) async {
  final recorder = PictureRecorder();
  draw(Canvas(recorder));
  final image = await recorder.endRecording().toImage(1024, 1024);
  final data = await image.toByteData(format: ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

void main() {
  test('génère les visuels de marque (icône + avant-plan)', () async {
    final dir = Directory('assets/branding')..createSync(recursive: true);
    const violet = Color(0xFF6C4DF6);
    final white = Paint()..color = const Color(0xFFFFFFFF);

    final icon = await _renderPng((canvas) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(0, 0, 1024, 1024),
          const Radius.circular(220),
        ),
        Paint()..color = violet,
      );
      canvas.drawPath(
        _boltPath(scale: 30, center: const Offset(512, 512)),
        white,
      );
    });
    File('${dir.path}/icon.png').writeAsBytesSync(icon);

    final foreground = await _renderPng((canvas) {
      canvas.drawPath(
        _boltPath(scale: 24, center: const Offset(512, 512)),
        white,
      );
    });
    File('${dir.path}/foreground.png').writeAsBytesSync(foreground);

    expect(File('${dir.path}/icon.png').existsSync(), isTrue);
    expect(File('${dir.path}/foreground.png').existsSync(), isTrue);
    // ignore: avoid_print
    print('Visuels de marque générés dans ${dir.path}/');
  });
}
