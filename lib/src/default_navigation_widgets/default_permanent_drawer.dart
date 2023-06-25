part of '../adaptive_navigation.dart';

Widget _defaultPermanentDrawerBuilder(
  BuildContext context,
  List<AdaptiveDestination> destinations,
  int currentIndex,
  IndexResolver onDestinationSelected,
  Widget? child,
) {
  return _DefaultPermanentDrawer(
    currentIndex: currentIndex,
    destinations: destinations,
    onDestinationSelected: onDestinationSelected,
    child: child,
  );
}

class _DefaultPermanentDrawer extends StatelessWidget {
  const _DefaultPermanentDrawer({
    required this.currentIndex,
    required this.destinations,
    required this.onDestinationSelected,
    this.child,
    Key? key,
  }) : super(key: key);

  final int currentIndex;
  final List<AdaptiveDestination> destinations;
  final IndexResolver onDestinationSelected;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            drawerTheme: Theme.of(context).drawerTheme.copyWith(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  elevation: 0,
                ),
          ),
          child: _DefaultDrawer(
            currentIndex: currentIndex,
            destinations: destinations,
            onDestinationSelected: onDestinationSelected,
          ),
        ),
        Expanded(
          child: child ?? const SizedBox(),
        ),
      ],
    );
  }
}
