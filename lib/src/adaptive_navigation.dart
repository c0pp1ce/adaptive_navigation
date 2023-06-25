import 'dart:math' as math;

import 'package:flutter/material.dart';

part 'navigation_type.dart';
part 'adaptive_destination.dart';
part 'default_navigation_widgets/default_navigation_bar.dart';
part 'default_navigation_widgets/default_rail.dart';
part 'default_navigation_widgets/default_drawer.dart';
part 'default_navigation_widgets/default_permanent_drawer.dart';

typedef IndexResolver = void Function(int index);

typedef NavigationBarBuilder = Widget Function(
  BuildContext context,
  List<AdaptiveDestination> destinations,
  int currentIndex,
  IndexResolver,
);

typedef DrawerBuilder = Widget Function(
  BuildContext context,
  List<AdaptiveDestination> destinations,
  int currentIndex,
  IndexResolver onDestinationSelected,
);

typedef RailBuilder = Widget Function(
  BuildContext context,
  List<AdaptiveDestination> destinations,
  int currentIndex,
  IndexResolver onDestinationSelected,
  bool isExtended,
  Widget? child,
);

typedef PermanentDrawerBuilder = Widget Function(
  BuildContext context,
  List<AdaptiveDestination> destinations,
  int currentIndex,
  IndexResolver onDestinationSelected,
  Widget? child,
);

/// A widget which wraps a [Scaffold] and displays different forms of navigation
/// based on the screen size.
class AdaptiveNavigation extends StatefulWidget {
  const AdaptiveNavigation({
    super.key,
    // raw functionality.
    this.scaffoldKey,
    required this.navigationTypeResolver,
    this.initialIndex = 0,
    required this.destinations,
    required this.onLocationChanged,
    this.getCurrentLocation,
    this.bottomNavigationOverflow = 5,
    this.railNavigationOverflow = 7,
    this.extendedRailNavigationOverflow = 7,
    this.includeBaseDestinationsInMenu = true,

    // Appearance etc.
    this.closeDrawerAfterNavigation = true,
    this.navigationBarBuilder = _defaultNavigationBarBuilder,
    this.railBuilder = _defaultRailBuilder,
    this.drawerBuilder = _defaultDrawerBuilder,
    this.permanentDrawerBuilder = _defaultPermanentDrawerBuilder,

    // scaffold configuration

    // page content
    this.child,
  });

  /// The key of the [Scaffold] which holds the navigation elements.
  final GlobalKey<ScaffoldState>? scaffoldKey;

  /// Determines the [NavigationType] that the [Scaffold] will be configured
  /// with.
  ///
  /// This method is called within the [State.didChangeDependencies] method.
  /// It should therefore make use of [InheritedWidget] in order to correctly
  /// switch the navigation type whenever the screen size changes.
  ///
  /// ### Example
  /// ```dart
  /// navigationTypeResolver: (context) {
  ///   final screenWidth = MediaQuery.of(context).size.width;
  ///   if(screenWidth >= 1280) {
  ///     return NavigationType.permanentDrawer;
  ///   } else {
  ///     return NavigationType.rail;
  ///   }
  /// }
  /// ```
  final NavigationType Function(BuildContext) navigationTypeResolver;

  /// The initial index that the widget should be configured with.
  final int initialIndex;

  /// Defines the appearance of the buttons of the different button items for
  /// each [NavigationType].
  final List<AdaptiveDestination> destinations;

  /// A callback which should execute the routing logic based on the tapped
  /// destination.
  ///
  /// ### Example for GoRouter
  /// ```dart
  /// onLocationChanged: (context, location) => context.go(location)
  /// ```
  final void Function(BuildContext context, String location) onLocationChanged;

  /// A method invoked by this widget in order to determine, if a sub-route of
  /// a destination is open.
  ///
  /// Used to go back to the initial location of a destination if it is tapped.
  final String Function(BuildContext)? getCurrentLocation;

  /// Maximum number of items to display in the [NavigationBar]
  final int bottomNavigationOverflow;

  /// Maximum number of items to display in the [NavigationRail].
  final int railNavigationOverflow;

  /// Maximum number of items to display in the extended [NavigationRail].
  final int extendedRailNavigationOverflow;

  /// If **true** and there is a destination overflow,<br /> the destinations which
  /// are included in the primary [NavigationType] will also be part of the
  /// overflow navigation.
  ///
  /// This does not affect [NavigationType.drawer]
  /// and [NavigationType.permanentDrawer],
  /// since the overflow navigation uses a [Drawer].
  ///
  /// Its appearance can be adjusted using the [drawerBuilder].
  final bool includeBaseDestinationsInMenu;

  /// If **true**, the [Drawer] will be closed whenever a destination is
  /// tapped.
  final bool closeDrawerAfterNavigation;

  /// Provides a widget that is used as the bottom navigation bar.
  ///
  /// ### Usage
  /// ```dart
  /// navigationBarBuilder: (context, destinations, currentIndex, onDestinationSelected) {
  ///   return NavigationBar(
  ///     selectedIndex: currentIndex,
  ///     onDestinationSelected: onDestinationSelected,
  ///     destinations: [
  ///         for (final destination in destinations)
  ///           NavigationDestination(
  ///             icon: destination.icon,
  ///             selectedIcon: destination.selectedIcon,
  ///             label: destination.getLabel(context),
  ///             tooltip: destination.getTooltip(context),
  ///           ),
  ///       ],
  ///   );
  /// }
  /// ```
  final NavigationBarBuilder navigationBarBuilder;

  /// Provides a widget that is used as rail navigation.
  ///
  /// Used for [NavigationType.rail] and [NavigationType.extendedRail].
  ///
  /// ### Usage
  /// ```dart
  /// railBuilder: (context, destinations, currentIndex, onDestinationSelected, isExtended, child) {
  ///   return Row(
  ///     children: [
  ///       NavigationRail(
  ///         extended: isExtended,
  ///         selectedIndex: currentIndex,
  ///         onDestinationSelected: onDestinationSelected,
  ///         destinations: [
  ///           for(final destination in destinations)
  ///             NavigationRailDestination(
  ///               icon: destination.icon,
  ///               selectedIcon: destination.selectedIcon,
  ///               label: Text(destination.getLabel(context)),
  ///             ),
  ///         ],
  ///       ),
  ///       Expanded(
  ///         child: child ?? const SizedBox(),
  ///       ),
  ///     ],
  ///   );
  /// }
  final RailBuilder railBuilder;

  /// Provides a widget that is used as the drawer navigation.
  ///
  /// Used for overflow drawers as well as [NavigationType.drawer].
  ///
  /// ### Usage
  /// ```dart
  /// drawerBuilder: (context, destinations, currentIndex, onDestinationSelected) {
  ///   return Drawer(
  ///     child: ListView(
  ///       padding: EdgeInsets.zero,
  ///       children: [
  ///         ...destinations.asMap().keys.map((index) {
  ///           bool selected = index == currentIndex;
  ///           final destination = destinations[index];
  ///           return ListTile(
  ///             selected: selected,
  ///             leading: selected ? destination.selectedIcon : destination.icon,
  ///             title: Text(destination.getLabel(context)),
  ///             onTap: () => onDestinationSelected(index),
  ///           );
  ///         }),
  ///       ],
  ///     ),
  ///   );
  /// }
  final DrawerBuilder drawerBuilder;

  /// Provides a widget that is used as the permanent drawer navigation.
  ///
  /// The widget will be the [Scaffold.body].
  ///
  /// Only used for [NavigationType.permanentDrawer].
  ///
  /// ### Usage
  /// ```dart
  /// permanentDrawerBuilder: (context, destinations, currentIndex, onDestinationSelected, child) {
  ///   return Row(
  ///     children: [
  ///       Drawer(
  ///         child: ListView(
  ///           padding: EdgeInsets.zero,
  ///           children: [
  ///             ...destinations.asMap().keys.map((index) {
  ///               bool selected = index == currentIndex;
  ///               final destination = destinations[index];
  ///               return ListTile(
  ///                 selected: selected,
  ///                 leading: selected ? destination.selectedIcon : destination.icon,
  ///                 title: Text(destination.getLabel(context)),
  ///                 onTap: () => onDestinationSelected(index),
  ///               );
  ///             }),
  ///           ],
  ///         ),
  ///       ),
  ///       Expanded(
  ///         child: child ?? const SizedBox(),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final PermanentDrawerBuilder permanentDrawerBuilder;

  /// The actual page content.
  final Widget? child;

  @override
  State<AdaptiveNavigation> createState() => _AdaptiveNavigationState();
}

class _AdaptiveNavigationState extends State<AdaptiveNavigation> {
  late int _currentIndex = widget.initialIndex;
  late NavigationType _currentNavType;

  @override
  void didChangeDependencies() {
    _currentNavType = widget.navigationTypeResolver(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    late final Widget child;
    switch (_currentNavType) {
      case NavigationType.bottom:
        child = _buildBottomNavigationScaffold(context);
        break;
      case NavigationType.rail:
        child = _buildRail(context, NavigationType.rail);
        break;
      case NavigationType.extendedRail:
        child = _buildRail(context, NavigationType.extendedRail);
        break;
      case NavigationType.drawer:
        child = _buildScaffold(
          context,
          navType: NavigationType.drawer,
          drawerDestinations: widget.destinations,
        );
        break;
      case NavigationType.permanentDrawer:
        child = _buildPermanentDrawer(context);
        break;
    }

    // TODO : Check if this interferes with iOS swipe back.
    // Mainly in sub routes, since the swipe should probably not work in tab bars
    // anyway.
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex == 0) {
          return true;
        }
        _onIndexSelected(context, 0);
        return false;
      },
      child: child,
    );
  }

  Widget _buildBottomNavigationScaffold(BuildContext context) {
    final (primaryDestinations, overflowDestinations) = _getDestinations(
      widget.bottomNavigationOverflow,
    );

    late final Widget? navBar;
    if (_currentIndex >= primaryDestinations.length) {
      navBar = null;
    } else {
      navBar = widget.navigationBarBuilder(
        context,
        primaryDestinations,
        _currentIndex,
        (i) => _onIndexSelected(context, i),
      );
    }

    return _buildScaffold(
      context,
      navWidget: navBar,
      drawerDestinations: overflowDestinations,
      navType: NavigationType.bottom,
    );
  }

  Widget _buildRail(BuildContext context, NavigationType type) {
    final (primaryDestinations, overflowDestinations) = _getDestinations(
      widget.railNavigationOverflow,
    );

    late final Widget? rail;
    if (_currentIndex >= primaryDestinations.length) {
      rail = null;
    } else {
      rail = widget.railBuilder(
        context,
        primaryDestinations,
        _currentIndex,
        (i) => _onIndexSelected(context, i),
        type == NavigationType.extendedRail,
        widget.child,
      );
    }

    return _buildScaffold(
      context,
      navType: type,
      navWidget: rail,
      drawerDestinations: overflowDestinations,
    );
  }

  Widget _buildPermanentDrawer(BuildContext context) {
    return _buildScaffold(
      context,
      navType: NavigationType.permanentDrawer,
      navWidget: widget.permanentDrawerBuilder(
        context,
        widget.destinations,
        _currentIndex,
        (i) => _onIndexSelected(context, i),
        widget.child,
      ),
    );
  }

  Widget _buildScaffold(
    BuildContext context, {
    Widget? navWidget,
    List<AdaptiveDestination>? drawerDestinations,
    required NavigationType navType,
  }) {
    return Scaffold(
      key: widget.scaffoldKey,
      // scaffold customization.

      // navigation.
      bottomNavigationBar: navType == NavigationType.bottom ? navWidget : null,
      drawer: (drawerDestinations?.isNotEmpty ?? false)
          ? widget.drawerBuilder(
              context,
              drawerDestinations!,
              _currentIndex,
              (i) => _onIndexSelected(context, i),
            )
          : null,
      body: navType == NavigationType.bottom ||
              navType == NavigationType.drawer ||
              navWidget == null
          ? widget.child
          : navWidget,
    );
  }

  /// First list = primary, second list = overflow.
  (List<AdaptiveDestination>, List<AdaptiveDestination>?) _getDestinations(
    int overflow,
  ) {
    return (
      widget.destinations.sublist(
        0,
        math.min(
          widget.destinations.length,
          overflow,
        ),
      ),
      widget.destinations.length <= overflow
          ? null
          : widget.destinations.sublist(
              widget.includeBaseDestinationsInMenu ? 0 : overflow,
            ),
    );
  }

  /// Handles the routing decisions.
  void _onIndexSelected(
    BuildContext context,
    int index,
  ) {
    final selectedDestination = widget.destinations[index];

    if (index != _currentIndex) {
      /// Simply switch the current destination.
      widget.onLocationChanged(
        context,
        selectedDestination.initialLocation,
      );
      setState(() {
        _currentIndex = index;
      });
    } else if (widget.getCurrentLocation != null) {
      /// Go back to the initial location of the destination if a sub-route is
      /// currently open.
      final String currentLocation = widget.getCurrentLocation!(context);
      if (!currentLocation.endsWith(selectedDestination.initialLocation)) {
        widget.onLocationChanged(context, selectedDestination.initialLocation);
      }
    }

    if (widget.closeDrawerAfterNavigation) {
      widget.scaffoldKey?.currentState?.closeDrawer();
    }
  }

  /// Calculates the current index based on the given [location] and the list of
  /// [destinations].
  /// TODO : Remove if not needed.
  /*int _locationToIndex(
      String location, {
        bool initialCall = false,
      }) {
    if (initialCall) {
      return widget.initialIndex;
    }

    final index = widget.destinations.indexWhere(
          (destination) => location.startsWith(
        destination.initialLocation,
      ),
    );
    assert(
    index > -1,
    "Given location $location does not match any destination.",
    );
    return index;
  }*/
}
