import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_action_chip.dart';
import 'package:training_partner/core/resources/widgets/custom_back_button.dart';
import 'package:training_partner/core/resources/widgets/divider_with_text.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/components/widgets/equipment_dropdown.dart';
import 'package:training_partner/features/exercises/logic/cubits/movement_cubit.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/workout_editor/components/widgets/body_part_action_chip.dart';
import 'package:training_partner/features/workout_editor/models/movement_filter.dart';
import 'package:training_partner/generated/assets.dart';

class MovementFilterBottomSheet extends StatefulWidget {
  final List<Movement> allMovements;
  final MovementFilter? previousFilter;

  const MovementFilterBottomSheet({super.key, required this.allMovements, this.previousFilter});

  @override
  State<MovementFilterBottomSheet> createState() => _MovementFilterBottomSheetState();
}

class _MovementFilterBottomSheetState extends State<MovementFilterBottomSheet> {
  late MovementFilter _movementFilter;
  late MovementCubit _exerciseCubit;

  @override
  void initState() {
    super.initState();

    _movementFilter = widget.previousFilter ?? const MovementFilter();

    _exerciseCubit = context.read<MovementCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setBottomSheetState) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 0,
                      color: Colors.black26,
                      child: SizedBox(height: 5, width: 80),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomBackButton(color: Colors.black38),
                    const Text('Filters', style: boldLargeBlack),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.refresh_rounded,
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
                const DividerWithText(text: 'Equipment', textStyle: smallGrey),
                const SizedBox(height: 10),
                // todo mintha ez is néha beakadna?
                EquipmentDropdown(
                  equipments: _getEquipments(),
                  initialItem: _movementFilter.equipment == null ? 'All' : TextUtil.firstLetterToUpperCase(_movementFilter.equipment!),
                  backgroundColor: Colors.white,
                  iconColor: Colors.black,
                  onSelect: (value) {
                    _exerciseCubit.filterMovements(
                      widget.allMovements,
                      _movementFilter.copyWith(equipment: value.toLowerCase()),
                    );
                  },
                ),
                _buildBodyPartsRow(setBottomSheetState),
                const SizedBox(height: 10),
                _buildTargetRow(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBodyPartsRow(StateSetter setBottomSheetState) {
    List<Widget> bodyPartWidgets = [];
    List<String> bodyParts = _movementFilter.bodyParts ?? [];

    bodyPartWidgets.addAll([
      BodyPartActionChip(
        label: 'chest',
        isSelected: bodyParts.contains('chest'),
        assetLocation: Assets.assetsImagesChestIcon,
        onTap: (isActive, label) {
          setBottomSheetState(() {
            if (!isActive) {
              bodyParts.remove(label);
            } else {
              bodyParts.add(label);
            }
          });

          _exerciseCubit.filterMovements(
            widget.allMovements,
            _movementFilter.copyWith(bodyParts: bodyParts),
          );
        },
      ),
      BodyPartActionChip(
        label: 'arms',
        isSelected: bodyParts.contains('arms'),
        assetLocation: Assets.assetsImagesArmsIcon,
        onTap: (isActive, label) {
          setBottomSheetState(() {
            if (!isActive) {
              bodyParts.remove(label);
            } else {
              bodyParts.add(label);
            }
          });

          _exerciseCubit.filterMovements(
            widget.allMovements,
            _movementFilter.copyWith(bodyParts: bodyParts),
          );
        },
      ),
      BodyPartActionChip(
        label: 'shoulders',
        isSelected: bodyParts.contains('shoulders'),
        assetLocation: Assets.assetsImagesShoulderIcon,
        onTap: (isActive, label) {
          setBottomSheetState(() {
            if (!isActive) {
              bodyParts.remove(label);
            } else {
              bodyParts.add(label);
            }
          });

          _exerciseCubit.filterMovements(
            widget.allMovements,
            _movementFilter.copyWith(bodyParts: bodyParts),
          );
        },
      ),
      BodyPartActionChip(
        label: 'waist',
        isSelected: bodyParts.contains('waist'),
        assetLocation: Assets.assetsImagesCoreIcon,
        onTap: (isActive, label) {
          setBottomSheetState(() {
            if (!isActive) {
              bodyParts.remove(label);
            } else {
              bodyParts.add(label);
            }
          });

          _exerciseCubit.filterMovements(
            widget.allMovements,
            _movementFilter.copyWith(bodyParts: bodyParts),
          );
        },
      ),
      BodyPartActionChip(
        label: 'back',
        isSelected: bodyParts.contains('back'),
        assetLocation: Assets.assetsImagesBackIcon,
        onTap: (isActive, label) {
          setBottomSheetState(() {
            if (!isActive) {
              bodyParts.remove(label);
            } else {
              bodyParts.add(label);
            }
          });

          _exerciseCubit.filterMovements(
            widget.allMovements,
            _movementFilter.copyWith(bodyParts: bodyParts),
          );
        },
      ),
      BodyPartActionChip(
        label: 'legs',
        isSelected: bodyParts.contains('legs'),
        assetLocation: Assets.assetsImagesLegsIcon,
        onTap: (isActive, label) {
          setBottomSheetState(() {
            if (!isActive) {
              bodyParts.remove(label);
            } else {
              bodyParts.add(label);
            }
          });

          _exerciseCubit.filterMovements(
            widget.allMovements,
            _movementFilter.copyWith(bodyParts: bodyParts),
          );
        },
      ),
      BodyPartActionChip(
        label: 'cardio',
        isSelected: bodyParts.contains('cardio'),
        assetLocation: Assets.assetsImagesCardioIcon,
        onTap: (isActive, label) {
          setBottomSheetState(() {
            if (!isActive) {
              bodyParts.remove(label);
            } else {
              bodyParts.add(label);
            }
          });

          _exerciseCubit.filterMovements(
            widget.allMovements,
            _movementFilter.copyWith(bodyParts: bodyParts),
          );
        },
      ),
    ]);

    return Column(
      children: [
        const SizedBox(height: 10),
        const DividerWithText(text: 'Body part', textStyle: smallGrey),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: bodyPartWidgets,
          ),
        ),
      ],
    );
  }

  // todo ha bodypartot deselectelem, akkor a target is ürüljön!!
  // todo első megnyitásra nem nyílik meg a targetok listája csak újramegynitásra
  Widget _buildTargetRow() {
    List<Widget> result = [];
    List<String> targets = _movementFilter.targets ?? [];

    var selectedBodyParts = _movementFilter.bodyParts ?? [];
    var filteredTargets = widget.allMovements
        .where((movement) => selectedBodyParts.any((bodyPart) => movement.bodyPart.contains(bodyPart)))
        .map((movement) => movement.target)
        .toSet()
        .toList();

    for (var target in filteredTargets) {
      result.add(
        CustomActionChip(
          label: target,
          isSelected: targets.contains(target),
          onTap: (isActive, label) {
            setState(() {
              if (!isActive) {
                targets.remove(label);
              } else {
                targets.add(label);
              }
            });

            _exerciseCubit.filterMovements(
              widget.allMovements,
              _movementFilter.copyWith(targets: targets),
            );
          },
        ),
      );
    }

    if (filteredTargets.isEmpty) {
      return Container();
    } else {
      return Column(
        children: [
          const DividerWithText(text: 'Target', textStyle: smallGrey),
          const SizedBox(height: 10),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: result)),
        ],
      );
    }
  }

  List<String> _getEquipments() {
    var equipments = widget.allMovements.map((movement) => TextUtil.firstLetterToUpperCase(movement.equipment)).toSet().toList();

    equipments.add('All');
    equipments.sort((a, b) => a.compareTo(b));
    return equipments;
  }
}
