import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class CachedRectangularNetworkImageWidget extends StatelessWidget {
  const CachedRectangularNetworkImageWidget({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    this.fit,
  });

  final String image;
  final double width;
  final double height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
            image:
            DecorationImage(image: imageProvider, fit: fit ?? BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Center(
            child: SizedBox(
                width: 20, height: 20, child: const Icon(Icons.error))),
      ),
    );
  }
}
