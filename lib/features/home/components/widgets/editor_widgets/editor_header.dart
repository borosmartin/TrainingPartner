import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/features/home/models/workout_session.dart';

class EditorHeader extends StatelessWidget {
  final List<WorkoutSession> workoutSessions;
  final PageController pageController;
  final TextEditingController workoutPlaneNameController;

  const EditorHeader({
    super.key,
    required this.workoutSessions,
    required this.pageController,
    required this.workoutPlaneNameController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel', style: boldNormalGrey),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    controller: workoutPlaneNameController,
                    style: boldLargeBlack,
                    textAlign: TextAlign.center,
                    cursorColor: Theme.of(context).colorScheme.tertiary,
                    decoration: InputDecoration(
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                      fillColor: Theme.of(context).colorScheme.primary,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // TODO hibakezelés pl nincsenek gyakorlatok egyikbe --> toast
                GestureDetector(
                  onTap: () => {},
                  child: Text(
                    'Save',
                    style: workoutSessions.isNotEmpty ? boldNormalAccent : boldNormalGrey,
                  ),
                ),
              ],
            ),
            if (workoutSessions.isNotEmpty) const SizedBox(height: 10),
            if (workoutSessions.isNotEmpty)
              SmoothPageIndicator(
                controller: pageController,
                count: workoutSessions.length,
                effect: WormEffect(
                  type: WormType.thin,
                  activeDotColor: Theme.of(context).colorScheme.tertiary,
                  dotColor: Colors.grey.shade400,
                ),
                onDotClicked: (int index) => pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
