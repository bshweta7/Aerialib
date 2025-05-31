import 'package:flutter/material.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/shared/helpers/formatters.dart';
import 'package:frontend/shared/widgets/filter_multi_select.dart';

class MediaFiltersSheet extends StatefulWidget {
  final List<String> initialMediaTypes;
  final ValueChanged<List<String>> onMediaTypesChanged;

  const MediaFiltersSheet({
    super.key,
    required this.initialMediaTypes,
    required this.onMediaTypesChanged,
  });

  @override
  State<MediaFiltersSheet> createState() => _MediaFiltersSheetState();

  static Future<void> showFilterSheet({
    required BuildContext context,
    required List<String> selectedMediaTypes,
    required ValueChanged<List<String>> onMediaTypesChanged,
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
                    MediaFiltersSheet(
                      initialMediaTypes: selectedMediaTypes,
                      onMediaTypesChanged: onMediaTypesChanged,
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

class _MediaFiltersSheetState extends State<MediaFiltersSheet> {
  late List<String> _selectedMediaTypes;
  bool _mediaTypeError = false;

  @override
  void initState() {
    super.initState();
    _selectedMediaTypes = List.from(widget.initialMediaTypes);
  }

  void _resetFilters() {
    setState(() {
      _selectedMediaTypes = Constants.mediaTypeOptions;
      _mediaTypeError = false;
    });
    widget.onMediaTypesChanged(Constants.mediaTypeOptions);
  }

  void _onMediaTypesSelectionChanged(List<String> selected) {
    setState(() {
      _selectedMediaTypes = selected;
      _mediaTypeError = selected.isEmpty;
    });
    widget.onMediaTypesChanged(selected);
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

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Media Type",
                style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              FilterMultiSelect<String>(
                options: Constants.mediaTypeOptions,
                initialValues: widget.initialMediaTypes,
                getLabel: (String type) => capitalizeFirstLetter(type),
                onSelectionChanged: _onMediaTypesSelectionChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select at least one media type';
                  }
                  return null;
                },
              ),
              if (_mediaTypeError)
                const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Please select at least one media type',
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
