import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/resources/widgets/custom_action_chip.dart';
import 'package:training_partner/core/resources/widgets/custom_search_bar.dart';
import 'package:training_partner/core/resources/widgets/custom_small_button.dart';
import 'package:training_partner/core/resources/widgets/divider_with_text.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/components/widgets/equipment_dropdown.dart';
import 'package:training_partner/features/exercises/components/widgets/movement_card.dart';
import 'package:training_partner/features/exercises/models/movement.dart';

class ExerciseListPage extends StatefulWidget {
  final String groupName;
  final List<Movement> movements;
  final String assetLocation;

  const ExerciseListPage({
    super.key,
    required this.groupName,
    required this.movements,
    required this.assetLocation,
  });

  @override
  State<ExerciseListPage> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  List<Movement> _movements = [];
  List<Movement> _filteredMovements = [];
  List<String> _targetNames = [];
  final List<String> _selectedTargets = [];
  String? selectedEquipment;

  bool _isTargetVisible = false;
  bool _isTop = true;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);

    _movements = widget.movements;
    _targetNames = _movements.map((movement) => movement.target).toSet().toList();
    _isTargetVisible = _targetNames.length > 2;

    colorSafeArea(color: Colors.white);

    filterMovements();
  }

  // todo ha nincs filter találat valamit azé tegyünk ki
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) => colorSafeArea(color: Theme.of(context).colorScheme.background),
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            floatingActionButton: _isTop
                ? null
                : CustomSmallButton(
                    elevation: 1,
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    icon: const Icon(Icons.arrow_upward, color: Colors.white),
                    onTap: () {
                      _scrollController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  leading: const BackButton(),
                  title: Text(widget.groupName, style: boldLargeBlack),
                  centerTitle: true,
                  expandedHeight: _isTargetVisible ? 310 : 220,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.only(top: 60, left: 15, right: 15),
                      child: Column(
                        children: [
                          CustomSearchBar(
                            hintText: 'Search...',
                            onChanged: (value) => filterMovements(),
                            textController: _searchController,
                          ),
                          const SizedBox(height: 10),
                          const DividerWithText(text: 'Equipment', textStyle: smallGrey),
                          const SizedBox(height: 10),
                          EquipmentDropdown(
                            equipments: getEquipments(),
                            initialItem: 'All',
                            onSelect: (value) {
                              setState(() {
                                selectedEquipment = value.toLowerCase();
                              });
                              filterMovements();
                            },
                          ),
                          const SizedBox(height: 10),
                          _buildTargetRow(),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: MovementCard(movement: _filteredMovements[index], isTargetVisible: _isTargetVisible),
                        );
                      }

                      return MovementCard(movement: _filteredMovements[index], isTargetVisible: _isTargetVisible);
                    },
                    childCount: _filteredMovements.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTargetRow() {
    List<Widget> targets = [];

    for (var target in _targetNames) {
      targets.add(
        CustomActionChip(
          label: target,
          onTap: (isActive, label) {
            setState(() {
              if (!isActive) {
                _selectedTargets.remove(label);
                filterMovements();
              } else {
                _selectedTargets.add(label);
                filterMovements();
              }
            });
          },
        ),
      );
    }

    return _isTargetVisible
        ? Column(
            children: [
              const DividerWithText(text: 'Targets', textStyle: smallGrey),
              const SizedBox(height: 10),
              SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: targets)),
            ],
          )
        : Container();
  }

  void filterMovements() {
    setState(() {
      _filteredMovements = _movements.where((movement) {
        final containsSearchText = _searchController.text.isEmpty || movement.name.toLowerCase().contains(_searchController.text.toLowerCase());

        final matchesEquipment = selectedEquipment == 'all' || selectedEquipment == null || movement.equipment == selectedEquipment;

        final matchesTargets = _selectedTargets.isEmpty || _selectedTargets.contains(movement.target);

        return containsSearchText && matchesEquipment && matchesTargets;
      }).toList();
    });
  }

  List<String> getEquipments() {
    var equipments = _movements.map((movement) => TextUtil.firstLetterToUpperCase(movement.equipment)).toSet().toList();

    equipments.add('All');
    equipments.sort((a, b) => a.compareTo(b));
    return equipments;
  }

  void _scrollListener() {
    setState(() {
      _isTop = _scrollController.offset <= 300;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();

    super.dispose();
  }
}
