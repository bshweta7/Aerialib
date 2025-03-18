import 'package:flutter/material.dart';

class MultiSelectApparatus extends StatefulWidget {
  final TextEditingController apparatusController;

  const MultiSelectApparatus({Key? key, required this.apparatusController})
      : super(key: key);

  @override
  State<MultiSelectApparatus> createState() => _MultiSelectApparatusState();
}

class _MultiSelectApparatusState extends State<MultiSelectApparatus> {
  List<String> selectedApparatus = []; // To store selected options

  @override
  void initState() {
    super.initState();
    // Initialize selectedApparatus from the controller if it has a value
    if (widget.apparatusController.text.isNotEmpty) {
      selectedApparatus = widget.apparatusController.text.split(',').map((e) => e.trim()).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
      initialValue: selectedApparatus,
      builder: (FormFieldState<List<String>> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8.0, // Space between chips horizontally
              runSpacing: 4.0, // Space between chip rows vertically
              children: <String>['Lyra', 'Hammock'].map((String value) {
                return ChoiceChip(
                  label: Text(value),
                  selected: selectedApparatus.contains(value),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedApparatus.add(value);
                      } else {
                        selectedApparatus.remove(value);
                      }
                      // Update the controller with the selected values
                      widget.apparatusController.text =
                          selectedApparatus.join(',');
                      state.didChange(selectedApparatus); // Notify FormField of change
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
            // const Padding(
            //   padding: EdgeInsets.only(top: 8.0),
            //   child: Text(
            //     'Apparatus', // Your label
            //     style: TextStyle(fontSize: 12, color: Colors.grey),
            //   ),
            // ),
          ],
        );
      },
      validator: (value) {
        // Validation logic: optional, but returns error if empty
        if (value == null || value.isEmpty) {
          return 'Please select at least one apparatus';
        }
        return null;
      },
    );
  }
}