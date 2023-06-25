part of 'adaptive_navigation.dart';

/// Provides the key of the scaffold used by [AdaptiveNavigation].
///
/// This eases the access to the drawer from within the child.
class NavigationScaffoldKeyProvider extends InheritedWidget {
  const NavigationScaffoldKeyProvider({
    required this.scaffoldKey,
    required super.child,
    super.key,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;

  static NavigationScaffoldKeyProvider? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<NavigationScaffoldKeyProvider>();
  }

  static NavigationScaffoldKeyProvider of(BuildContext context) {
    final NavigationScaffoldKeyProvider? result = maybeOf(context);
    assert(result != null, "No AdaptiveNavigationScaffold found in context.");
    return result!;
  }

  @override
  bool updateShouldNotify(NavigationScaffoldKeyProvider oldWidget) {
    return scaffoldKey != oldWidget.scaffoldKey;
  }
}
