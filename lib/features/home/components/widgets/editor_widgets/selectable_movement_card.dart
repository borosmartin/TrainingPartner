import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/shimmer_container.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/models/movement.dart';

class SelectableMovementCard extends StatefulWidget {
  final Movement movement;
  final bool isSelected;
  final Function(bool) onSelect;

  const SelectableMovementCard({
    Key? key,
    required this.movement,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<SelectableMovementCard> createState() => _SelectableMovementCardState();
}

class _SelectableMovementCardState extends State<SelectableMovementCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: widget.isSelected ? Theme.of(context).colorScheme.tertiary : Colors.white,
      shape: defaultCornerShape,
      child: InkWell(
        onTap: () => widget.onSelect(!widget.isSelected),
        borderRadius: defaultBorderRadius,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CachedNetworkImage(
                imageUrl: widget.movement.gifUrl,
                height: 70,
                width: 70,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                    borderRadius: defaultBorderRadius,
                  ),
                ),
                placeholder: (context, url) => const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: ShimmerContainer(height: 70, width: 70),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.movement.name,
                      style: widget.isSelected ? boldNormalWhite : boldNormalBlack,
                    ),
                    Text(
                      TextUtil.firstLetterToUpperCase(widget.movement.equipment),
                      style: widget.isSelected ? smallWhite : smallGrey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
