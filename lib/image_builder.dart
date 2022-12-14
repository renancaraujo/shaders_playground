import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ImageBuilder extends StatefulWidget {
  const ImageBuilder(
    this.builder, {
    super.key,
    required this.assetImageProvider,
  });

  final Widget Function(BuildContext context, ui.Image image) builder;
  final ImageProvider assetImageProvider;

  @override
  State<ImageBuilder> createState() => _ImageBuilderState();
}

class _ImageBuilderState extends State<ImageBuilder> {
  ui.Image? image;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getImage();
  }

  Future<void> getImage() async {
    final key =
        await widget.assetImageProvider.obtainKey(ImageConfiguration.empty);
    widget.assetImageProvider
        .loadBuffer(
      key,
      PaintingBinding.instance.instantiateImageCodecFromBuffer,
    )
        .addListener(
      ImageStreamListener((info, synchronousCall) {
        setState(() {
          image = info.image;
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final image = this.image;

    if (image == null) {
      return const SizedBox.shrink();
    }

    return widget.builder(context, image);
  }
}
