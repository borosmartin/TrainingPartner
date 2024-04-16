import 'package:flutter/material.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/colored_safe_area_body.dart';
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

    _filterMovements();
  }

  // todo ha nincs filter találat valamit azért tegyünk ki
  // todo cubit filter, plusz merge shared widgets
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        floatingActionButton: _isTop
            ? null
            : CustomSmallButton(
                elevation: 1,
                backgroundColor: accentColor,
                icon: const Icon(Icons.arrow_upward, color: Colors.white),
                onTap: () {
                  _scrollController.animateTo(
                    0.0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              ),
        body: ColoredSafeAreaBody(
          safeAreaColor: Theme.of(context).cardColor,
          isLightTheme: Theme.of(context).brightness == Brightness.light,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              _getHeader(),
              _getBodyContent(),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar _getHeader() {
    Color backgroundColor = Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.primary : Colors.grey.shade200;

    return SliverAppBar(
      leading: const BackButton(),
      title: Text(widget.groupName, style: CustomTextStyle.titlePrimary(context)),
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
                onChanged: (value) => _filterMovements(),
                textController: _searchController,
                backgroundColor: backgroundColor,
              ),
              const SizedBox(height: 10),
              DividerWithText(text: 'Equipment', textStyle: CustomTextStyle.bodySmallSecondary(context)),
              const SizedBox(height: 10),
              EquipmentDropdown(
                equipments: _getEquipments(),
                initialItem: 'All',
                backgroundColor: backgroundColor,
                onSelect: (value) {
                  setState(() {
                    selectedEquipment = value.toLowerCase();
                  });
                  _filterMovements();
                },
              ),
              const SizedBox(height: 10),
              _buildTargetRow(),
            ],
          ),
        ),
      ),
    );
  }

  SliverList _getBodyContent() {
    return SliverList(
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
    );
  }

  Widget _buildTargetRow() {
    List<Widget> targets = [];
    Color backgroundColor = Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.primary : Colors.grey.shade200;

    for (var target in _targetNames) {
      targets.add(
        CustomActionChip(
          label: target,
          unSelectedColor: backgroundColor,
          onTap: (isActive, label) {
            setState(() {
              if (!isActive) {
                _selectedTargets.remove(label);
                _filterMovements();
              } else {
                _selectedTargets.add(label);
                _filterMovements();
              }
            });
          },
        ),
      );
    }

    return _isTargetVisible
        ? Column(
            children: [
              DividerWithText(text: 'Targets', textStyle: CustomTextStyle.bodySmallSecondary(context)),
              const SizedBox(height: 10),
              SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: targets)),
            ],
          )
        : Container();
  }

  void _filterMovements() {
    setState(() {
      _filteredMovements = _movements.where((movement) {
        final containsSearchText = _searchController.text.isEmpty || movement.name.toLowerCase().contains(_searchController.text.toLowerCase());

        final matchesEquipment = selectedEquipment == 'all' || selectedEquipment == null || movement.equipment == selectedEquipment;

        final matchesTargets = _selectedTargets.isEmpty || _selectedTargets.contains(movement.target);

        return containsSearchText && matchesEquipment && matchesTargets;
      }).toList();
    });
  }

  List<String> _getEquipments() {
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
