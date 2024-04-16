import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/cached_image.dart';
import 'package:training_partner/core/resources/widgets/colored_safe_area_body.dart';
import 'package:training_partner/core/resources/widgets/custom_back_button.dart';
import 'package:training_partner/core/resources/widgets/custom_divider.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ColoredSafeAreaBody(
        safeAreaColor: Theme.of(context).cardColor,
        isLightTheme: Theme.of(context).brightness == Brightness.light,
        child: Column(
          children: [
            _getHeaderWidget(context),
            _getBodyContent(),
          ],
        ),
      ),
    );
  }

  Widget _getBodyContent() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              _getTitleCard(),
              const SizedBox(height: 15),
              _getInstructionsCard(),
              const SizedBox(height: 15),
              _getSecondayMusclesCard(),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getHeaderWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomBackButton(context: context),
                Text('Exercise Details', style: CustomTextStyle.titlePrimary(context)),
                const Icon(FontAwesomeIcons.bullseye, color: Colors.transparent, size: 43),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTitleCard() {
    return Card(
      elevation: 0,
      shape: defaultCornerShape,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          CachedImage(
            imageUrl: widget.movement.gifUrl,
            height: MediaQuery.of(context).size.width * 0.6,
            width: MediaQuery.of(context).size.width * 0.6,
          ),
          const SizedBox(height: 10),
          Container(
            decoration: const BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.only(
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
                  Text(widget.movement.name, style: CustomTextStyle.titleTetriary(context)),
                  const SizedBox(height: 15),
                  const CustomDivider(color: Colors.white, thickness: 1.7),
                  const SizedBox(height: 15),
                  // todo icons
                  Row(
                    children: [
                      const Icon(PhosphorIconsFill.personArmsSpread, size: 28, color: Colors.white),
                      const SizedBox(width: 10),
                      Text('Body Part:', style: CustomTextStyle.bodyTetriary(context)),
                      const Spacer(),
                      Text(TextUtil.firstLetterToUpperCase(widget.movement.bodyPart), style: CustomTextStyle.bodyTetriary(context)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(PhosphorIconsFill.barbell, size: 28, color: Colors.white),
                      const SizedBox(width: 10),
                      Text('Equipment:', style: CustomTextStyle.bodyTetriary(context)),
                      const Spacer(),
                      Text(TextUtil.firstLetterToUpperCase(widget.movement.equipment), style: CustomTextStyle.bodyTetriary(context)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(PhosphorIconsBold.target, size: 28, color: Colors.white),
                      const SizedBox(width: 10),
                      Text('Target:', style: CustomTextStyle.bodyTetriary(context)),
                      const Spacer(),
                      Text(TextUtil.firstLetterToUpperCase(widget.movement.target), style: CustomTextStyle.bodyTetriary(context)),
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

  Widget _getInstructionsCard() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: defaultCornerShape,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Iconsax.flash5, size: 25),
                const SizedBox(width: 10),
                Text(
                  'Instructions:',
                  style: CustomTextStyle.subtitlePrimary(context),
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
                    style: CustomTextStyle.bodySmallPrimary(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSecondayMusclesCard() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: defaultCornerShape,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(PhosphorIconsBold.target, size: 25),
                const SizedBox(width: 10),
                Text(
                  'Secondary Muscles:',
                  style: CustomTextStyle.subtitlePrimary(context),
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
                    style: CustomTextStyle.bodySmallTetriary(context),
                  ),
                  shape: defaultCornerShape,
                  side: const BorderSide(color: accentColor),
                  backgroundColor: accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
