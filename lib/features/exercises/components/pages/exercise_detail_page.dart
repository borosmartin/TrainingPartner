import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/resources/widgets/custom_back_button.dart';
import 'package:training_partner/core/resources/widgets/custom_divider.dart';
import 'package:training_partner/core/resources/widgets/shimmer_container.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/models/movement.dart';

class ExerciseDetailPage extends StatefulWidget {
  final Movement movement;

  const ExerciseDetailPage({Key? key, required this.movement}) : super(key: key);

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  @override
  void initState() {
    super.initState();

    colorSafeArea(color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: _getBodyContent(),
      ),
    );
  }

  Widget _getBodyContent() {
    return Column(
      children: [
        _getHeaderWidget(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  _getTitleWidget(),
                  const SizedBox(height: 15),
                  _getInstructionsWidget(),
                  const SizedBox(height: 15),
                  _getSecondayMusclesWidget(),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getHeaderWidget() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomBackButton(),
                Text('Exercise Details', style: boldLargeBlack),
                Icon(FontAwesomeIcons.bullseye, color: Colors.transparent, size: 43),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTitleWidget() {
    return Card(
      elevation: 0,
      shape: defaultCornerShape,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          CachedNetworkImage(
            imageUrl: widget.movement.gifUrl,
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.width * 0.6,
            fit: BoxFit.contain,
            placeholder: (context, url) => Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ShimmerContainer(
                height: MediaQuery.of(context).size.width * 0.6,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.image_not_supported_outlined,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Text(widget.movement.name, style: boldLargeWhite),
                  const SizedBox(height: 15),
                  const CustomDivider(color: Colors.white, thickness: 1.7),
                  const SizedBox(height: 15),
                  // todo icons
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.dumbbell, size: 20),
                      const SizedBox(width: 15),
                      Text(
                        'Body Part:  ${TextUtil.firstLetterToUpperCase(widget.movement.bodyPart)}',
                        style: smallWhite,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.dumbbell, size: 20),
                      const SizedBox(width: 15),
                      Text(
                        'Equipment:  ${TextUtil.firstLetterToUpperCase(widget.movement.equipment)}',
                        style: smallWhite,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.dumbbell, size: 20),
                      const SizedBox(width: 15),
                      Text(
                        'Target:  ${TextUtil.firstLetterToUpperCase(widget.movement.target)}',
                        style: smallWhite,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getInstructionsWidget() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: defaultCornerShape,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Iconsax.flash5, size: 25),
                SizedBox(width: 10),
                Text(
                  'Instructions:',
                  style: boldNormalBlack,
                ),
              ],
            ),
            const SizedBox(height: 10),
            const CustomDivider(),
            const SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                widget.movement.instructions.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    '${index + 1} ).  ${widget.movement.instructions[index]}',
                    style: smallBlack,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSecondayMusclesWidget() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: defaultCornerShape,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Row(
              // todo icon
              children: [
                Icon(Iconsax.calendar5, size: 25),
                SizedBox(width: 10),
                Text(
                  'Secondary Muscles:',
                  style: boldNormalBlack,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              direction: Axis.horizontal,
              children: List.generate(
                widget.movement.secondaryMuscles.length,
                (index) => Chip(
                  label: Text(
                    TextUtil.firstLetterToUpperCase(widget.movement.secondaryMuscles[index]),
                    style: smallWhite,
                  ),
                  shape: defaultCornerShape,
                  side: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
