import 'package:flutter/material.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/utils/formatters.dart';
import 'package:frontend/presentation/widgets/functional_buttons/filters/filter_multi_select.dart';

class PoseFilters extends StatefulWidget {
  final List<String> initialApparatus;
  final List<int> initialLevels;
  final ValueChanged<List<String>> onApparatusChanged;
  final ValueChanged<List<int>> onLevelsChanged;

  const PoseFilters({
    super.key,
    required this.initialApparatus,
    required this.initialLevels,
    required this.onApparatusChanged,
    required this.onLevelsChanged,
  });

  @override
  State<PoseFilters> createState() => _PoseFiltersState();
}

class _PoseFiltersState extends State<PoseFilters> {
  bool _isContainerVisible = false;
  late List<String> _selectedApparatus;
  late List<int> _selectedLevels;
  bool _apparatusError = false;
  bool _levelsError = false;

  @override
  void initState() {
    super.initState();
    _selectedApparatus = List.from(widget.initialApparatus);
    _selectedLevels = List.from(widget.initialLevels);
  }

  void _resetFilters() {
    setState(() {
      _selectedApparatus = Constants.apparatusOptions;
      _selectedLevels = Constants.levelOptions;
      _apparatusError = false;
      _levelsError = false;
    });
    widget.onApparatusChanged(Constants.apparatusOptions);
    widget.onLevelsChanged(Constants.levelOptions);

  }

  void _onApparatusSelectionChanged(List<String> selected) {
    setState(() {
      _selectedApparatus = selected;
      _apparatusError = selected.isEmpty && _isContainerVisible;
    });
    widget.onApparatusChanged(selected);
  }

  void _onLevelsSelectionChanged(List<int> selected) {
    setState(() {
      _selectedLevels = selected;
      _levelsError = selected.isEmpty && _isContainerVisible;
    });
    widget.onLevelsChanged(selected);
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Expand horizontally
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 10.0,
      ),
      decoration: BoxDecoration(
        color: Colors.purple.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // TODO adjust this
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  // Drop down full view button
                  IconButton(
                    icon: Icon(_isContainerVisible
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down), // Change icon based on visibility
                    onPressed: () {
                      setState(() {
                        _isContainerVisible = !_isContainerVisible; // Toggle visibility
                      });
                    },
                    tooltip: 'Show or hide filter options',
                  ),

                  // Title
                  const Text(
                    "Filters",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Reset filters button
              if (_isContainerVisible)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextButton(
                    onPressed: _resetFilters,
                    child: const Text(
                      "Reset",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
            ],
          ),
          if (_isContainerVisible) // Conditional rendering
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Apparatus Filter
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      const Text(
                        "Apparatus:  ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FilterMultiSelect<String>(
                        options: Constants.apparatusOptions,
                        initialValues: widget.initialApparatus,
                        getLabel: (String apparatus) => capitalizeFirstLetter(apparatus),
                        onSelectionChanged: _onApparatusSelectionChanged,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select at least one apparatus';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  if (_apparatusError)
                    const Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Please select at least one apparatus',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),

                  const SizedBox(height: 10),

                  // Level Filter
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      const Text(
                        "Level:  ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FilterMultiSelect<int>(
                        options: Constants.levelOptions,
                        initialValues: widget.initialLevels,
                        getLabel: (int level) => 'Level $level',
                        onSelectionChanged: _onLevelsSelectionChanged,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select at least one level';
                          }
                          return null;
                        },
                      ),
                      if (_levelsError)
                        const Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Please select at least one level',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
        ],
      ),
    );
  }
}