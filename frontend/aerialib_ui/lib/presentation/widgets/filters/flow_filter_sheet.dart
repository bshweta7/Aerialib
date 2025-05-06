import 'package:flutter/material.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/utils/formatters.dart';
import 'package:frontend/presentation/widgets/filters/filter_multi_select.dart';

class FlowFiltersSheet extends StatefulWidget {
  final List<String> initialApparatus;
  final List<int> initialLevels;
  final List<String> initialShareStatus;
  final ValueChanged<List<String>> onApparatusChanged;
  final ValueChanged<List<int>> onLevelsChanged;
  final ValueChanged<List<String>> onShareStatusChanged;

  const FlowFiltersSheet({
    super.key,
    required this.initialApparatus,
    required this.initialLevels,
    required this.initialShareStatus,
    required this.onApparatusChanged,
    required this.onLevelsChanged,
    required this.onShareStatusChanged,
  });

  @override
  State<FlowFiltersSheet> createState() => _FlowFiltersSheetState();

  /// Modal Bottom Sheet entry point
  static Future<void> showFilterSheet({
    required BuildContext context,
    required List<String> selectedApparatus,
    required List<int> selectedLevels,
    required List<String> selectedShareStatus,
    required ValueChanged<List<String>> onApparatusChanged,
    required ValueChanged<List<int>> onLevelsChanged,
    required ValueChanged<List<String>> onShareStatusChanged,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    FlowFiltersSheet(
                      initialApparatus: selectedApparatus,
                      initialLevels: selectedLevels,
                      initialShareStatus: selectedShareStatus,
                      onApparatusChanged: onApparatusChanged,
                      onLevelsChanged: onLevelsChanged,
                      onShareStatusChanged: onShareStatusChanged,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _FlowFiltersSheetState extends State<FlowFiltersSheet> {
  late List<String> _selectedApparatus;
  late List<int> _selectedLevels;
  // TODO add share status here...
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
      _apparatusError = selected.isEmpty;
    });
    widget.onApparatusChanged(selected);
  }

  void _onLevelsSelectionChanged(List<int> selected) {
    setState(() {
      _selectedLevels = selected;
      _levelsError = selected.isEmpty;
    });
    widget.onLevelsChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filters",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _resetFilters,
                tooltip: 'Reset filters',
              )
            ],
          ),

          const SizedBox(height: 12),

          // Apparatus Filter
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Apparatus",
                style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
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
              if (_apparatusError)
                const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Please select at least one apparatus',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Level Filter
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Level",
                style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
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
        ],
      ),
    );
  }
}
