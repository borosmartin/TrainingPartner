import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class ShimmerContainer extends StatelessWidget {
  final double height;
  final double width;
  const ShimmerContainer({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: defaultBorderRadius,
        ),
      ),
    );
  }
}
