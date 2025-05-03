import 'package:flutter/material.dart';

class FilterMultiSelect<T> extends StatefulWidget {
  final List<T> options;
  final List<T> initialValues;
  final String Function(T) getLabel;
  final ValueChanged<List<T>> onSelectionChanged;
  final String? Function(List<T>?)? validator;

  const FilterMultiSelect({
    super.key,
    required this.options,
    required this.initialValues,
    required this.getLabel,
    required this.onSelectionChanged,
    this.validator,
  });

  @override
  State<FilterMultiSelect<T>> createState() => _FilterMultiSelectState<T>();
}

class _FilterMultiSelectState<T> extends State<FilterMultiSelect<T>> {
  late List<T> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.initialValues);
  }

  @override
  void didUpdateWidget(covariant FilterMultiSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValues != oldWidget.initialValues) {
      _selectedValues = List.from(widget.initialValues);
    }
  }

  void _toggleValue(T value) {
    setState(() {
      if (_selectedValues.contains(value)) {
        _selectedValues.remove(value);
      } else {
        _selectedValues.add(value);
      }
      widget.onSelectionChanged(_selectedValues);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<T>>(
      initialValue: widget.initialValues,
      validator: widget.validator,
      builder: (FormFieldState<List<T>> state) {
        return Wrap(
          alignment: WrapAlignment.start,
          spacing: 8.0,
          runSpacing: 4.0,
          children: widget.options.map((option) {
            final isSelected = _selectedValues.contains(option);
            return FilterChip(
              label: Text(
                widget.getLabel(option),
                style: const TextStyle(fontSize: 12),
              ),
              selected: isSelected,
              onSelected: (bool selected) {
                _toggleValue(option);
                state.didChange(_selectedValues);
              },
            );
          }).toList(),
        );
      },
    );
  }
}