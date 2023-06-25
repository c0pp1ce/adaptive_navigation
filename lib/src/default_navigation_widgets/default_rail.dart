part of '../adaptive_navigation.dart';

Widget _defaultRailBuilder(
  BuildContext context,
  List<AdaptiveDestination> destinations,
  int currentIndex,
  IndexResolver onDestinationSelected,
  bool isExtended,
  Widget? child,
) {
  return _DefaultRail(
    currentIndex: currentIndex,
    destinations: destinations,
    onDestinationSelected: onDestinationSelected,
    isExtended: isExtended,
    child: child,
  );
}

class _DefaultRail extends StatelessWidget {
  const _DefaultRail({
    required this.currentIndex,
    required this.destinations,
    required this.onDestinationSelected,
    required this.isExtended,
    this.child,
    Key? key,
  }) : super(key: key);

  final int currentIndex;
  final List<AdaptiveDestination> destinations;
  final IndexResolver onDestinationSelected;
  final bool isExtended;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          extended: isExtended,
          selectedIndex: currentIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: [
            for (final destination in destinations)
              NavigationRailDestination(
                icon: destination.icon,
                selectedIcon: destination.selectedIcon,
                label: Text(destination.getLabel(context)),
              ),
          ],
        ),
        Expanded(
          child: child ?? const SizedBox(),
        ),
      ],
    );
  }
}
