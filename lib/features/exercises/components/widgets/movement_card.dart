import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_divider.dart';
import 'package:training_partner/core/resources/widgets/shimmer_container.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/components/pages/exercise_detail_page.dart';
import 'package:training_partner/features/exercises/models/movement.dart';

class MovementCard extends StatelessWidget {
  final Movement movement;
  final bool isTargetVisible;
  const MovementCard({super.key, required this.movement, required this.isTargetVisible});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ExerciseDetailPage(movement: movement),
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          elevation: 0,
          shape: defaultCornerShape,
          child: SizedBox(
            height: 110,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CachedNetworkImage(
                    imageUrl: movement.gifUrl,
                    height: 90,
                    width: 90,
                    placeholder: (context, url) => const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: ShimmerContainer(height: 70, width: 70),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                  ),
                  const SizedBox(width: 10),
                  const CustomDivider(isVertical: true),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          movement.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: boldNormalBlack,
                        ),
                        Text(TextUtil.firstLetterToUpperCase(movement.equipment), style: smallGrey),
                        if (isTargetVisible)
                          Text(
                            '${TextUtil.firstLetterToUpperCase(movement.bodyPart)} - ${TextUtil.firstLetterToUpperCase(movement.target)}',
                            style: smallGrey,
                          ),
                      ],
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
