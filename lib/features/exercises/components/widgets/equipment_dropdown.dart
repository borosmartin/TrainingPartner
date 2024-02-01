import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class EquipmentDropdown extends StatelessWidget {
  final List<String> equipments;
  final Function(String) onSelect;
  final String initialItem;

  const EquipmentDropdown({
    super.key,
    required this.equipments,
    required this.onSelect,
    required this.initialItem,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      items: equipments,
      initialItem: initialItem,
      closedHeaderPadding: const EdgeInsets.only(top: 12, bottom: 12, right: 15, left: 15),
      expandedHeaderPadding: const EdgeInsets.only(top: 12, bottom: 12, right: 15, left: 15),
      itemsListPadding: const EdgeInsets.only(top: 12, bottom: 12, right: 15, left: 10),
      overlayHeight: 500,
      headerBuilder: (BuildContext context, String label) => Row(
        children: [
          const Icon(Icons.fitness_center, color: Colors.black45),
          const SizedBox(width: 10),
          Text(label, style: smallGrey),
        ],
      ),
      decoration: CustomDropdownDecoration(
        listItemStyle: smallGrey,
        headerStyle: smallGrey,
        closedBorderRadius: defaultBorderRadius,
        expandedBorderRadius: defaultBorderRadius,
        expandedFillColor: Colors.grey.shade200,
        closedFillColor: Colors.grey.shade200,
      ),
      onChanged: (selectedName) {
        onSelect(selectedName);
      },
    );
  }
}
