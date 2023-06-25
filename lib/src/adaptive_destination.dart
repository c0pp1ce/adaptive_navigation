part of 'adaptive_navigation.dart';

/// Base for the destination configuration of the different [NavigationType]s.
class AdaptiveDestination {
  const AdaptiveDestination({
    required this.initialLocation,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.translatedLabel,
    this.tooltip,
    this.translatedTooltip,
  });

  /// The top-most location (url/path) of the destination.
  ///
  /// Used to calculate the current index.
  final String initialLocation;
  final Widget icon;
  final Widget selectedIcon;

  /// The label of the destination.
  final String label;

  /// Provides the translated version of the label.
  final String Function(BuildContext)? translatedLabel;

  final String? tooltip;
  final String Function(BuildContext)? translatedTooltip;

  /// Convenience method to check if a translated label is available.
  String getLabel(BuildContext context) {
    return translatedLabel != null ? translatedLabel!(context) : label;
  }

  /// Convenience method to check if a translated tooltip is available.
  String? getTooltip(BuildContext context) {
    return translatedTooltip != null ? translatedTooltip!(context) : tooltip;
  }
}
