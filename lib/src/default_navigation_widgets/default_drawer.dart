part of '../adaptive_navigation.dart';

Widget _defaultDrawerBuilder(
  BuildContext context,
  List<AdaptiveDestination> destinations,
  int currentIndex,
  IndexResolver onDestinationSelected,
) {
  return _DefaultDrawer(
    currentIndex: currentIndex,
    destinations: destinations,
    onDestinationSelected: onDestinationSelected,
  );
}

/// A simple [Drawer] used if no corresponding builder function is
/// specified.
class _DefaultDrawer extends StatelessWidget {
  const _DefaultDrawer({
    required this.currentIndex,
    required this.destinations,
    required this.onDestinationSelected,
    Key? key,
  }) : super(key: key);

  final int currentIndex;
  final List<AdaptiveDestination> destinations;
  final IndexResolver onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ...destinations.asMap().keys.map((index) {
            bool selected = index == currentIndex;
            final destination = destinations[index];
            return ListTile(
              selected: selected,
              leading: selected ? destination.selectedIcon : destination.icon,
              title: Text(destination.getLabel(context)),
              onTap: () => onDestinationSelected(index),
            );
          }),
        ],
      ),
    );
  }
}
