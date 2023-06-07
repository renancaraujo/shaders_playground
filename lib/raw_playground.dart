import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:photo_view/photo_view.dart';

class ShadersRawPlayground extends StatelessWidget {
  const ShadersRawPlayground({super.key});

  @override
  Widget build(BuildContext context) {
    return const InnerPlayground(size: Size(400, 400));
  }
}

class InnerPlayground extends StatefulWidget {
  const InnerPlayground({super.key, required this.size});

  final Size size;

  @override
  State<InnerPlayground> createState() => _InnerPlaygroundState();
}

class _InnerPlaygroundState extends State<InnerPlayground> {
  var dotPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              dotPosition = details.localPosition;
            });
          },
          child: AspectRatio(
            aspectRatio: widget.size.aspectRatio,
            child: ShaderBuilder(
              assetKey: 'shaders/quad_gradient.glsl',
              (BuildContext context, ui.FragmentShader shader, Widget? child) {
                return CustomPaint(
                  painter: MyPainter(shader, dotPosition),
                  child: SizedBox.fromSize(size: widget.size),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: dotPosition.dy,
          left: dotPosition.dx,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

extension on ui.FragmentShader {
  void setStuff(
    ValueSetter<SetStuffOnFragmentShader> callback,
  ) => callback(SetStuffOnFragmentShader(this));
}

class SetStuffOnFragmentShader {
  SetStuffOnFragmentShader(this.shader);

  int _index = 0;
  final ui.FragmentShader shader;

  void setSize(Size size) {
    shader
      ..setFloat(_index++, size.width)
      ..setFloat(_index++, size.height);
  }

  void setColor(Color color) {
    shader
      ..setFloat(_index++, color.red.toDouble() / 255)
      ..setFloat(_index++, color.green.toDouble() / 255)
      ..setFloat(_index++, color.blue.toDouble() / 255)
      ..setFloat(_index++, color.alpha.toDouble() / 255);
  }

  void setImageSampler(ui.Image image) {
    shader.setImageSampler(_index++, image);
  }
}

class MyPainter extends CustomPainter {
  MyPainter(this.shader, this.center);

  late final paintWhite = Paint()..color = Colors.white;
  late final paintGreen = Paint()..color = Colors.green;

  late final paintStroke = Paint()
    ..color = Colors.white
    ..strokeWidth = 0.2
    ..style = PaintingStyle.stroke;


  final ui.FragmentShader shader;
  final Offset center;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {

    shader.setStuff((s) {
      s..setSize(size)
        ..setColor(Color(0xFFFEF8C4))
        ..setColor(Color(0xFF372CE6))
        ..setColor(Color(0xFFDC4C87))
        ..setColor(Color(0xFFD56450));
    });

    final paintShader = Paint()
      ..shader = shader;

    canvas.drawRect(Offset.zero & size, paintWhite);


    final tlv = Offset(0, 0);
    final tcv = Offset(size.width/2, 0);
    final trv = Offset(size.width, 0);

    final clv = Offset(0, size.height/2);
    final ccv = Offset(size.width/2, size.height/2);
    final ccwarped = center;

    final crv = Offset(size.width, size.height/2);

    final blv = Offset(0, size.height);
    final bcv = Offset(size.width/2, size.height);
    final brv = Offset(size.width, size.height);

    final tlccv = Offset((tlv.dx + ccv.dx)/2, (tlv.dy + ccv.dy)/2);
    final trccv = Offset((trv.dx + ccv.dx)/2, (trv.dy + ccv.dy)/2);
    final blccv = Offset((blv.dx + ccv.dx)/2, (blv.dy + ccv.dy)/2);
    final brccv = Offset((brv.dx + ccv.dx)/2, (brv.dy + ccv.dy)/2);

    final tlcwarped = Offset((tlv.dx + ccwarped.dx)/2, (tlv.dy + ccwarped.dy)/2);
    final trcwarped = Offset((trv.dx + ccwarped.dx)/2, (trv.dy + ccwarped.dy)/2);
    final blcwarped = Offset((blv.dx + ccwarped.dx)/2, (blv.dy + ccwarped.dy)/2);
    final brcwarped = Offset((brv.dx + ccwarped.dx)/2, (brv.dy + ccwarped.dy)/2);


    final triangles = [
      // t1
      tlv, tcv, tlccv,
      // t2
      tcv, ccv, tlccv,
      // t3
      tlccv, ccv, clv,
      // t4
      tlv, tlccv, clv,
      // t5
      tcv, trv, trccv,
      // t6
      trv, crv, trccv,
      // t7
      trccv, crv, ccv,
      // t8
      tcv, trccv, ccv,
      // t9
      clv, ccv, blccv,
      // t10
      ccv, bcv, blccv,
      // t11
      blccv, bcv, blv,
      // t12
      clv, blccv, blv,
      // t13
      ccv, crv, brccv,
      // t14
      crv, brv, brccv,
      // t15
      brccv, brv, bcv,
      // t16
      ccv, brccv, bcv,
    ];


    final warped = [
      // t1
      tlv, tcv, tlcwarped,
      // t2
      tcv, ccwarped, tlcwarped,
      // t3
      tlcwarped, ccwarped, clv,
      // t4
      tlv, tlcwarped, clv,
      // t5
      tcv, trv, trcwarped,
      // t6
      trv, crv, trcwarped,
      // t7
      trcwarped, crv, ccwarped,
      // t8
      tcv, trcwarped, ccwarped,
      // t9
      clv, ccwarped, blcwarped,
      // t10
      ccwarped, bcv, blcwarped,
      // t11
      blcwarped, bcv, blv,
      // t12
      clv, blcwarped, blv,
      // t13
      ccwarped, crv, brcwarped,
      // t14
      crv, brv, brcwarped,
      // t15
      brcwarped, brv, bcv,
      // t16
      ccwarped, brcwarped, bcv,

    ];

    final vertices = ui.Vertices(
      ui.VertexMode.triangles,
      warped,
      textureCoordinates: triangles,
    );

    canvas.drawVertices(vertices, BlendMode.dst, paintShader);

    canvas.drawPoints(ui.PointMode.polygon, [...warped], paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
