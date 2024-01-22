import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/shimmer_container.dart';
import 'package:training_partner/features/exercises/components/widgets/exercise_header.dart';
import 'package:training_partner/features/exercises/models/movement.dart';

class GroupedExercisesPage extends StatefulWidget {
  final String groupName;
  final List<Movement> movements;
  final String assetLocation;

  const GroupedExercisesPage({
    super.key,
    required this.groupName,
    required this.movements,
    required this.assetLocation,
  });

  @override
  State<GroupedExercisesPage> createState() => _GroupedExercisesPageState();
}

class _GroupedExercisesPageState extends State<GroupedExercisesPage> {
  List<Movement> movements = [];

  @override
  void initState() {
    super.initState();
    movements = widget.movements;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return PopScope(
      onPopInvoked: (value) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.background,
          statusBarIconBrightness: Brightness.dark,
        ));
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: _getBodyContent(),
          ),
        ),
      ),
    );
  }

  Widget _getBodyContent() {
    return Column(
      children: [
        ExerciseHeader(
          groupName: widget.groupName,
          assetLocation: widget.assetLocation,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: movements.length,
            itemBuilder: (context, index) {
              return _getMovementCard(movements[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _getMovementCard(Movement movement) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: ListTile(
        shape: defaultCornerShape,
        tileColor: Colors.white,
        leading: CachedNetworkImage(
          imageUrl: movement.gifUrl,
          placeholder: (context, url) => const Padding(
            padding: EdgeInsets.only(left: 5),
            child: ShimmerContainer(height: 50, width: 50),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
        ),
        title: Text(movement.name, style: boldNormalBlack),
        subtitle: Text(movement.target, style: smallGrey),
      ),
    );
  }
}
