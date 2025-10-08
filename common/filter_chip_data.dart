import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

FilterChipData? getSeletedchip(List<FilterChipData> chips) {
  return chips.firstWhereOrNull((element) => element.isSelected);
}

class FilterChipData {
  final String label;
  final String? description;
  final Color? color;
  final int? days;
  final Widget? icon;
  bool isSelected;

  FilterChipData({
    required this.label,
    this.description,
    this.color,
    this.days,
    this.icon,
    required this.isSelected,
  });

  FilterChipData copy({
    String? label,
    String? description,
    Color? color,
    int? days,
    Widget? icon,
    bool? isSelected,
  }) =>
      FilterChipData(
        label: label ?? this.label,
        description: description ?? this.description,
        color: color ?? this.color,
        days: days ?? this.days,
        icon: icon ?? this.icon,
        isSelected: isSelected ?? this.isSelected,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterChipData &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          color == other.color &&
          days == other.days &&
          icon == other.icon &&
          isSelected == other.isSelected;

  @override
  int get hashCode =>
      label.hashCode ^ color.hashCode ^ isSelected.hashCode ^ days.hashCode;
}
