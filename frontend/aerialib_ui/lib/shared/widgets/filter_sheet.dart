// WIP: Reusable Filter Sheet with Category-specific Logic
import 'package:flutter/material.dart';
import 'package:frontend/shared/helpers/formatters.dart';
import 'package:frontend/shared/widgets/filter_multi_select.dart';

class FiltersSheet<T> extends StatefulWidget {
  final Map<String, List<T>> filterOptions; // category -> all options
  final Map<String, List<T>> selectedFilters; // category -> selected options
  final void Function(String category, List<T>) onFilterChanged;
  final String Function(String category, T value)? labelBuilder;
  final String Function(String category)? validationMessageBuilder;

  const FiltersSheet({
    super.key,
    required this.filterOptions,
    required this.selectedFilters,
    required this.onFilterChanged,
    this.labelBuilder,
    this.validationMessageBuilder,
  });

  static Future<void> show<T>({
    required BuildContext context,
    required Map<String, List<T>> filterOptions,
    required Map<String, List<T>> selectedFilters,
    required void Function(String category, List<T>) onFilterChanged,
    String Function(String category, T value)? labelBuilder,
    String Function(String category)? validationMessageBuilder,
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
                child: FiltersSheet(
                  filterOptions: filterOptions,
                  selectedFilters: selectedFilters,
                  onFilterChanged: onFilterChanged,
                  labelBuilder: labelBuilder,
                  validationMessageBuilder: validationMessageBuilder,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  State<FiltersSheet<T>> createState() => _FiltersSheetState<T>();
}

class _FiltersSheetState<T> extends State<FiltersSheet<T>> {
  late Map<String, List<T>> _selected;
  final Map<String, bool> _errors = {};

  @override
  void initState() {
    super.initState();
    _selected = Map.from(widget.selectedFilters);
  }

  void _resetFilters() {
    setState(() {
      for (final category in widget.filterOptions.keys) {
        _selected[category] = List.from(widget.filterOptions[category]!);
        _errors[category] = false;
      }
    });
    _selected.forEach(widget.onFilterChanged);
  }

  String _defaultLabel(String category, T value) {
    if (category.toLowerCase() == 'apparatus') {
      return capitalizeFirstLetter(value as String);
    }
    if (category.toLowerCase() == 'level') {
      final intVal = int.tryParse(value as String) ?? -1;
      if (intVal == 0) return 'Intro';
      if (intVal == -1) return 'Other';
      return 'Level $intVal';
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Filters", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              IconButton(icon: const Icon(Icons.refresh), onPressed: _resetFilters),
            ],
          ),
          const SizedBox(height: 12),

          // Build filter categories
          ...widget.filterOptions.entries.map((entry) {
            final category = entry.key;
            final options = entry.value;
            final selected = _selected[category] ?? [];
            final error = _errors[category] ?? false;
            final labelBuilder = widget.labelBuilder ?? _defaultLabel;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                FilterMultiSelect<T>(
                  options: options,
                  initialValues: selected,
                  getLabel: (item) => labelBuilder(category, item),
                  onSelectionChanged: (newValues) {
                    setState(() {
                      _selected[category] = newValues;
                      _errors[category] = newValues.isEmpty;
                    });
                    widget.onFilterChanged(category, newValues);
                  },
                  validator: (values) {
                    if (values == null || values.isEmpty) {
                      return widget.validationMessageBuilder?.call(category) ?? 'Please select at least one';
                    }
                    return null;
                  },
                ),
                if (error)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      widget.validationMessageBuilder?.call(category) ?? 'Please select at least one',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
