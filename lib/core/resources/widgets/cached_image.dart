import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/shimmer_container.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;

  const CachedImage({super.key, required this.imageUrl, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
          borderRadius: defaultBorderRadius,
        ),
      ),
      placeholder: (context, url) => Padding(
        padding: const EdgeInsets.only(left: 5),
        child: ShimmerContainer(height: height, width: width),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
    );
  }
}
