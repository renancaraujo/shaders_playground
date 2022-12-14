import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Title;
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:shaders_playground/scroll_stuff.dart';

class ShaderPlaygroundScrollable extends StatelessWidget {
  const ShaderPlaygroundScrollable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ApplyShader(
      child: Center(
        child: SizedBox(
          width: 900,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              // overscroll: false,
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            child: ListView.builder(
              physics: const ClampingScrollPhysics(
                parent: RangeMaintainingScrollPhysics(),
              ),
              addRepaintBoundaries: false,
              itemCount: 10000,
              cacheExtent: 10000,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return const Title(
                    child: Text('Oslo photos'),
                  );
                }
                return SomeOsloPhoto(
                  key: ValueKey(index),
                  index: index,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ApplyShader extends StatefulWidget {
  const ApplyShader({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ApplyShader> createState() => _ApplyShaderState();
}

class _ApplyShaderState extends State<ApplyShader>
    with SingleTickerProviderStateMixin {
  var delta = 0.0;
  var viewportDimension = 0.0;

  @override
  void initState() {
    super.initState();

    createTicker((elapsed) {
      setState(() {});
    }).start();
    activate();
  }

  @override
  void dispose() {
    deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        viewportDimension = notification.metrics.viewportDimension;
        if (notification is OverscrollNotification) {
          delta += notification.overscroll;
        } else if (notification is ScrollEndNotification) {
          delta = 0.0;
        }
        return false;
      },
      child: ShaderBuilder(
        assetKey: 'shaders/brightness.glsl',
            (BuildContext context, ui.FragmentShader shader, Widget? child) {
          final overscrollAmount = delta.abs() / viewportDimension;

          return AnimatedSampler(
            enabled: overscrollAmount > 0.0,
            child: child!,
                (ui.Image image, Size size, Offset offset, ui.Canvas canvas) {
              shader
                ..setFloat(0, size.width)
                ..setFloat(1, size.height)
                ..setFloat(2, overscrollAmount)
                ..setImageSampler(0, image);

              canvas
                ..save()
                ..translate(offset.dx, offset.dy)
                ..drawRect(Offset.zero & size, Paint()..shader = shader)
                ..restore();
            },
          );
        },
        child: widget.child,
      ),
    );
  }
}
