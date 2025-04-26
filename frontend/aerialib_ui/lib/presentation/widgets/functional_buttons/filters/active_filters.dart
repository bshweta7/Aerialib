import 'package:flutter/material.dart';
import 'package:frontend/core/constants/constants.dart';
import 'custom_filter_chip.dart'; // Import the custom chip

class ActiveFiltersSummary extends StatelessWidget {
  final List<String> activeApparatusFilters;
  final List<int> activeLevelFilters;

  const ActiveFiltersSummary({
    super.key,
    required this.activeApparatusFilters,
    required this.activeLevelFilters,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> activeFilterWidgets = [];

    // Apparatus
    if (activeApparatusFilters.length == Constants.apparatusOptions.length) {
      activeFilterWidgets.add(
        const CustomFilterChip(
          label: "All Apparatus Selected",
          backgroundColor: Color(0xFFFFEFD9), // TODO move this to colors.dart constants file
        )
      );
    } else if (activeApparatusFilters.isEmpty) {
      activeFilterWidgets.add(
          const CustomFilterChip(
            label: "No Apparatus Selected",
            foregroundColor: Color(0xFF9D0000),
            backgroundColor: Color(0xFFFFEFD9), // TODO move this to colors.dart constants file
          )
      );
    } else {
      activeFilterWidgets.addAll(activeApparatusFilters.map((filter) => CustomFilterChip(
        label: filter,
        backgroundColor: const Color(0xFFFFEFD9), // TODO move this to colors.dart constants file
      )).toList());
    }

    // Transition
    activeFilterWidgets.add(
        const Text(
          // "\n",
            " | ",
            style: TextStyle(
                fontSize: 10,
                color: Color(0xFF5A5A5A))
        )
    );

    // Levels
    if (activeLevelFilters.length == Constants.levelOptions.length) {
      activeFilterWidgets.add(
          const CustomFilterChip(
            label: "All Levels Selected",
            backgroundColor: Color(0xFFD9FCFF), // TODO move this to colors.dart constants file
          )
      );
    } else if (activeLevelFilters.isEmpty) {
      activeFilterWidgets.add(
          const CustomFilterChip(
            label: "No Levels Selected",
            foregroundColor: Color(0xFF9D0000),
            backgroundColor: Color(0xFFD9FCFF), // TODO move this to colors.dart constants file
          )
      );
    } else {
      activeFilterWidgets.addAll(activeLevelFilters.map((level) => CustomFilterChip(
        label: 'Level $level',
        backgroundColor: const Color(0xFFD9FCFF), // TODO move this to colors.dart constants file
      )).toList());
    }

    // if (activeLevelFilters.isNotEmpty) {
    //   if (activeFilterWidgets.isNotEmpty) {
    //     // activeFilterWidgets.add(
    //     //   const Text(
    //     //     // "\n",
    //     //     " | ",
    //     //     style: TextStyle(
    //     //       fontSize: 10,
    //     //       color: Color(0xFF5A5A5A))
    //     //   )
    //     // );
    //   }
    //   activeFilterWidgets.addAll(activeLevelFilters.map((level) => CustomFilterChip(
    //     label: 'Level $level',
    //     backgroundColor: const Color(0xFFD9FCFF), // TODO move this to colors.dart constants file
    //   )).toList());
    // }

    return Wrap(
      alignment: WrapAlignment.start,
      direction: Axis.horizontal,
      spacing: 4.0,
      runSpacing: 2.0,
      children: activeFilterWidgets,
    );

    // return Padding(
    //   padding: const EdgeInsets.only(left: 8.0),
    //   child: Wrap(
    //     spacing: 4.0,
    //     runSpacing: 2.0,
    //     children: activeFilterWidgets,
    //   ),
    // );
  }
}