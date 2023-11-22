import 'package:adaptive_navigation_widget/adaptive_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionANavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

void main() {
  runApp(NestedTabNavigationExampleApp());
}

/// An example demonstrating how to use nested navigators
class NestedTabNavigationExampleApp extends StatelessWidget {
  /// Creates a NestedTabNavigationExampleApp
  NestedTabNavigationExampleApp({super.key});

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/a',
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (
          final BuildContext context,
          final GoRouterState state,
          final StatefulNavigationShell navigationShell,
        ) =>
            AdaptiveNavigationShell(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          // The route branch for the first tab of the navigation shell.
          StatefulShellBranch(
            navigatorKey: _sectionANavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                // The screen to display as the root in the first tab of the
                // navigation shell.
                path: '/a',
                builder:
                    (final BuildContext context, final GoRouterState state) =>
                        const RootScreen(label: 'A', detailsPath: '/a/details'),
                routes: <RouteBase>[
                  // The details screen to display stacked on navigator of the
                  // first tab. This will cover screen A but not the application
                  // shell (navigation shell).
                  GoRoute(
                    path: 'details',
                    builder: (
                      final BuildContext context,
                      final GoRouterState state,
                    ) =>
                        const DetailsScreen(label: 'A'),
                  ),
                ],
              ),
            ],
          ),

          // The route branch for the second tab of the navigation shell.
          StatefulShellBranch(
            // It's not necessary to provide a navigatorKey if it isn't also
            // needed elsewhere. If not provided, a default key will be used.
            routes: <RouteBase>[
              GoRoute(
                // The screen to display as the root in the second tab of the
                // navigation shell.
                path: '/b',
                builder:
                    (final BuildContext context, final GoRouterState state) =>
                        const RootScreen(
                  label: 'B',
                  detailsPath: '/b/details/1',
                  secondDetailsPath: '/b/details/2',
                ),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'details/:param',
                    builder: (
                      final BuildContext context,
                      final GoRouterState state,
                    ) =>
                        DetailsScreen(
                      label: 'B',
                      param: state.pathParameters['param'],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // The route branch for the third tab of the navigation shell.
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                // The screen to display as the root in the third tab of the
                // navigation shell.
                path: '/c',
                builder:
                    (final BuildContext context, final GoRouterState state) =>
                        const RootScreen(
                  label: 'C',
                  detailsPath: '/c/details',
                ),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'details',
                    builder: (
                      final BuildContext context,
                      final GoRouterState state,
                    ) =>
                        DetailsScreen(
                      label: 'C',
                      extra: state.extra,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(final BuildContext context) => MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorSchemeSeed: Colors.deepPurple,
          useMaterial3: true,
        ),
        routerConfig: _router,
      );
}

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class AdaptiveNavigationShell extends StatelessWidget {
  AdaptiveNavigationShell({required this.navigationShell, super.key});

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  final List<AdaptiveDestination> destinations = <AdaptiveDestination>[
    const AdaptiveDestination(
      initialPath: '/a',
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'A',
    ),
    const AdaptiveDestination(
      initialPath: '/b',
      icon: Icon(Icons.feed_outlined),
      selectedIcon: Icon(Icons.feed),
      label: 'B',
    ),
    const AdaptiveDestination(
      initialPath: '/c',
      icon: Icon(Icons.person_outlined),
      selectedIcon: Icon(Icons.person),
      label: 'C',
    ),
  ];

  @override
  Widget build(final BuildContext context) => AdaptiveNavigation(
        destinations: destinations,
        navigationTypeResolver: (final BuildContext context) {
          final double screenWidth = MediaQuery.of(context).size.width;
          if (screenWidth > 700) {
            return NavigationType.rail;
          } else {
            return NavigationType.bottom;
          }
        },
        initialIndex: navigationShell.currentIndex,
        onDestinationChanged: (
          final BuildContext context,
          final String initialPath,
          final int index,
        ) =>
            navigationShell.goBranch(index),
        onCurrentDestinationSelected: (
          final BuildContext context,
          final String initialPath,
          final int index,
        ) =>
            // Navigate to the current location of the branch at the provided index when
            // tapping an item in the navigation.
            // When navigating to a new branch, it's recommended to use the goBranch
            // method, as doing so makes sure the last navigation state of the
            // Navigator for the branch is restored.
            navigationShell.goBranch(index, initialLocation: true),
        child: navigationShell,
      );
}

/// Widget for the root/initial pages in the navigation shell.
class RootScreen extends StatelessWidget {
  /// Creates a RootScreen
  const RootScreen({
    required this.label,
    required this.detailsPath,
    this.secondDetailsPath,
    super.key,
  });

  /// The label
  final String label;

  /// The path to the detail page
  final String detailsPath;

  /// The path to another detail page
  final String? secondDetailsPath;

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Root of section $label'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Screen $label',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Padding(padding: EdgeInsets.all(4)),
              TextButton(
                onPressed: () {
                  GoRouter.of(context).go(detailsPath, extra: '$label-XYZ');
                },
                child: const Text('View details'),
              ),
              const Padding(padding: EdgeInsets.all(4)),
              if (secondDetailsPath != null)
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).go(secondDetailsPath!);
                  },
                  child: const Text('View more details'),
                ),
            ],
          ),
        ),
      );
}

/// The details screen for either the A or B screen.
class DetailsScreen extends StatefulWidget {
  /// Constructs a [DetailsScreen].
  const DetailsScreen({
    required this.label,
    this.param,
    this.extra,
    this.withScaffold = true,
    super.key,
  });

  /// The label to display in the center of the screen.
  final String label;

  /// Optional param
  final String? param;

  /// Optional extra object
  final Object? extra;

  /// Wrap in scaffold
  final bool withScaffold;

  @override
  State<StatefulWidget> createState() => DetailsScreenState();
}

/// The state for DetailsScreen
class DetailsScreenState extends State<DetailsScreen> {
  int _counter = 0;

  @override
  Widget build(final BuildContext context) {
    if (widget.withScaffold) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Details Screen - ${widget.label}'),
        ),
        body: _build(context),
      );
    } else {
      return ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: _build(context),
      );
    }
  }

  Widget _build(final BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Details for ${widget.label} - Counter: $_counter',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Padding(padding: EdgeInsets.all(4)),
            TextButton(
              onPressed: () {
                setState(() {
                  _counter++;
                });
              },
              child: const Text('Increment counter'),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            if (widget.param != null)
              Text(
                'Parameter: ${widget.param!}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            const Padding(padding: EdgeInsets.all(8)),
            if (widget.extra != null)
              Text(
                'Extra: ${widget.extra!}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            if (!widget.withScaffold) ...<Widget>[
              const Padding(padding: EdgeInsets.all(16)),
              TextButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                child: const Text(
                  '< Back',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ],
        ),
      );
}
