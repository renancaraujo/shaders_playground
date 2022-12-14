import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:photo_view/photo_view.dart';

import 'package:shaders_playground/image_builder.dart';

class ShadersPlayground extends StatefulWidget {
  const ShadersPlayground({super.key});

  @override
  State<ShadersPlayground> createState() => _ShadersPlaygroundState();
}

class _ShadersPlaygroundState extends State<ShadersPlayground> {
  @override
  Widget build(BuildContext context) {
    return ImageBuilder(
      assetImageProvider: const AssetImage('assets/oslo6.jpg'),
      (BuildContext context, ui.Image image) {
        return InnerPlayground(image: image);
      },
    );
  }
}

class InnerPlayground extends StatefulWidget {
  const InnerPlayground({super.key, required this.image});

  final ui.Image image;

  @override
  State<InnerPlayground> createState() => _InnerPlaygroundState();
}

class _InnerPlaygroundState extends State<InnerPlayground> {
  var sliderValue = 0.0;

  final min = 0.0;
  final max = 1.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PhotoView.customChild(
          childSize: Size(
            widget.image.width.toDouble(),
            widget.image.height.toDouble(),
          ),
          child: AspectRatio(
            aspectRatio: widget.image.width / widget.image.height,
            child: ShaderBuilder(
              assetKey: 'shaders/barrel_blur.glsl',
              (BuildContext context, ui.FragmentShader shader, Widget? child) {
                shader
                  ..setFloat(0, widget.image.width.toDouble())
                  ..setFloat(1, widget.image.height.toDouble())
                  ..setFloat(2, sliderValue)
                  ..setImageSampler(0, widget.image);
                return CustomPaint(
                  painter: ImagePainter(shader),
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 50,
          right: 50,
          child: Slider(
            value: sliderValue,
            min: min,
            max: max,
            onChanged: (value) {
              setState(() {
                sliderValue = value;
              });
            },
          ),
        ),
      ],
    );
  }
}

class ImagePainter extends CustomPainter {
  ImagePainter(this.shader);

  final ui.FragmentShader shader;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
