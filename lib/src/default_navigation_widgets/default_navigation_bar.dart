part of '../adaptive_navigation.dart';

Widget _defaultNavigationBarBuilder(
  BuildContext context,
  List<AdaptiveDestination> destinations,
  int currentIndex,
  IndexResolver onDestinationSelected,
) {
  return _DefaultNavigationBar(
    destinations: destinations,
    currentIndex: currentIndex,
    onDestinationSelected: onDestinationSelected,
  );
}

/// A simple [NavigationBar] used if no corresponding builder function is
/// specified.
class _DefaultNavigationBar extends StatelessWidget {
  const _DefaultNavigationBar({
    required this.destinations,
    required this.currentIndex,
    required this.onDestinationSelected,
    Key? key,
  }) : super(key: key);

  final List<AdaptiveDestination> destinations;
  final int currentIndex;
  final IndexResolver onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        for (final destination in destinations)
          NavigationDestination(
            icon: destination.icon,
            selectedIcon: destination.selectedIcon,
            label: destination.getLabel(context),
            tooltip: destination.getTooltip(context),
          ),
      ],
    );
  }
}
