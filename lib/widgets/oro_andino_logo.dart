import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Logo "ORO ANDINO": montaña dorada/gris/negra + texto en negrita.
/// Dibujado con vectores para que se vea nítido en cualquier densidad.
class OroAndinoLogo extends StatelessWidget {
  const OroAndinoLogo({super.key, this.height = 30});

  /// Alto de la montaña; el texto se escala proporcionalmente.
  final double height;

  @override
  Widget build(BuildContext context) {
    final double fontSize = height * 0.40;
    final TextStyle style = TextStyle(
      color: const Color(0xFF050500),
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.3,
      height: 1.1,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        CustomPaint(
          size: Size(height * 3.2, height),
          painter: const _MountainPainter(),
        ),
        Transform.translate(
          offset: Offset(-height * 0.25, 0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('ORO', style: style),
                    SizedBox(width: height * 0.18),
                    Text(
                      '°',
                      style: style.copyWith(fontSize: fontSize * 0.7),
                    ),
                  ],
                ),
                Text('ANDINO', style: style),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MountainPainter extends CustomPainter {
  const _MountainPainter();

  static const double _w = 320;
  static const double _h = 100;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / _w, size.height / _h);

    Path poly(List<Offset> pts) {
      final Path p = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final Offset o in pts.skip(1)) {
        p.lineTo(o.dx, o.dy);
      }
      return p..close();
    }

    final Paint fill = Paint()..style = PaintingStyle.fill;

    // Montaña dorada (izquierda)
    fill.color = AppColors.goldLight;
    canvas.drawPath(
      poly(const <Offset>[Offset(0, 95), Offset(105, 25), Offset(232, 95)]),
      fill,
    );

    // Sombra naranja sobre la ladera
    fill.color = const Color(0xFFFAB96E);
    canvas.drawPath(
      poly(const <Offset>[
        Offset(104, 30),
        Offset(128, 42),
        Offset(232, 95),
        Offset(140, 95),
      ]),
      fill,
    );

    // Montaña gris
    fill.color = const Color(0xFF606060);
    canvas.drawPath(
      poly(const <Offset>[
        Offset(126, 24),
        Offset(150, 12),
        Offset(215, 50),
        Offset(320, 95),
        Offset(190, 95),
      ]),
      fill,
    );

    // Pico negro
    fill.color = const Color(0xFF050500);
    canvas.drawPath(
      poly(const <Offset>[
        Offset(168, 22),
        Offset(190, 4),
        Offset(222, 34),
        Offset(320, 95),
        Offset(262, 95),
        Offset(215, 55),
      ]),
      fill,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
