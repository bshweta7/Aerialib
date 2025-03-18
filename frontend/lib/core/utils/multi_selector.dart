import 'package:flutter/material.dart';

class MultiSelect<T> extends StatefulWidget {
  final List<T> options;
  final List<T> initialValues;
  // final String label;
  final String Function(T) getLabel;
  final Function(List<T>) onSelectionChanged;
  final String? Function(List<T>?)? validator;

  const MultiSelect({
    Key? key,
    required this.options,
    required this.initialValues,
    // required this.label,
    required this.getLabel,
    required this.onSelectionChanged,
    this.validator,
  }) : super(key: key);

  @override
  State<MultiSelect<T>> createState() => _MultiSelectState<T>();
}

class _MultiSelectState<T> extends State<MultiSelect<T>> {
  late List<T> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItems = List<T>.from(widget.initialValues);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<T>>(
      initialValue: selectedItems,
      validator: widget.validator,
      builder: (FormFieldState<List<T>> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: widget.options.map((T item) {
                return ChoiceChip(
                  label: Text(widget.getLabel(item)),
                  selected: selectedItems.contains(item),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedItems.add(item);
                      } else {
                        selectedItems.remove(item);
                      }
                      widget.onSelectionChanged(selectedItems);
                      state.didChange(selectedItems);
                    });
                  },
                );
              }).toList(),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  state.errorText!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 8.0),
            //   child: Text(
            //     widget.label, // Use the provided label
            //     style: TextStyle(fontSize: 12, color: Colors.grey),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}