import 'package:flutter/material.dart';

/// A segmented selector for the optional certification fields.
///
/// Unlike the spot type selector this is deliberately *nullable*: tapping the selected option
/// again clears it. A null certification class means "not recorded", which is a different fact
/// from the NONE option ("genuinely uncertified"), so the UI has to be able to express both.
class SegmentedOptionSelector<T> extends StatelessWidget {
  final String label;
  final List<T> options;
  final String Function(T) labelBuilder;
  final T? selected;
  final ValueChanged<T?> onChanged;
  final bool enabled;
  final String? helperText;

  const SegmentedOptionSelector({
    super.key,
    required this.label,
    required this.options,
    required this.labelBuilder,
    required this.selected,
    required this.onChanged,
    this.enabled = true,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: enabled ? Colors.black87 : Colors.grey,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selected == option;
            return GestureDetector(
              // Tapping the selected option clears it, so "not recorded" stays reachable.
              onTap: enabled
                  ? () => onChanged(isSelected ? null : option)
                  : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: !enabled
                      ? Colors.grey.shade100
                      : isSelected
                          ? Color(0xFF2B7DE9)
                          : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  labelBuilder(option),
                  style: TextStyle(
                    color: !enabled
                        ? Colors.grey
                        : isSelected
                            ? Colors.white
                            : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (helperText != null) ...[
          SizedBox(height: 6),
          Text(
            helperText!,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ],
    );
  }
}
