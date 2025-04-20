import 'package:flutter/material.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/to_sort/pages/widgets/multi_selector.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedApparatus = List.from(widget.initialApparatus);
    _selectedLevels = List.from(widget.initialLevels);
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Filters",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                        "Apparatus:   ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      MultiSelect(
                        options: Constants.apparatusOptions,
                        initialValues: _selectedApparatus,
                        getLabel: (String apparatus) {
                          if (apparatus.isEmpty) {
                            return apparatus;
                          }
                          return apparatus[0].toUpperCase() +
                              apparatus.substring(1);
                        },
                        onSelectionChanged: (List<String> selected) {
                          setState(() {
                            _selectedApparatus = selected;
                          });
                          widget.onApparatusChanged(selected); // Notify parent
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            const SnackBar(
                                content: Text(
                                    'Please select at least one apparatus'));
                            return 'Please select at least one apparatus';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Level Filter
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      const Text(
                        "Level:   ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      MultiSelect<int>(
                        options: Constants.levelOptions,
                        initialValues: _selectedLevels,
                        getLabel: (int level) => 'Level $level',
                        onSelectionChanged: (List<int> selected) {
                          setState(() {
                            _selectedLevels = selected;
                          });
                          widget.onLevelsChanged(selected); // Notify parent
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            const SnackBar(
                                content:
                                Text('Please select at least one level'));
                            return 'Please select at least one level';
                          }
                          return null;
                        },
                      )
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