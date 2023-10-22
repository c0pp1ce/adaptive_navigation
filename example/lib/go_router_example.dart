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

class NestedTabNavigationExampleApp extends StatelessWidget {
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
            ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _sectionANavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: '/a',
                builder:
                    (final BuildContext context, final GoRouterState state) =>
                        const RootScreen(label: 'A', detailsPath: '/a/details'),
                routes: <RouteBase>[
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
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
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
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
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
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        routerConfig: _router,
      );
}

class ScaffoldWithNavBar extends StatelessWidget {
  ScaffoldWithNavBar({required this.navigationShell, super.key});

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
        navigationRailLabelType: NavigationRailLabelType.all,
        onDestinationChanged: (
          final BuildContext context,
          final String initialPath,
          final int index,
        ) =>
            navigationShell.goBranch(index),
        initialIndex: navigationShell.currentIndex,
        onCurrentDestinationSelected: (
          final BuildContext context,
          final String initialPath,
          final int index,
        ) =>
            navigationShell.goBranch(index, initialLocation: true),
        child: navigationShell,
      );
}

class RootScreen extends StatelessWidget {
  const RootScreen({
    required this.label,
    required this.detailsPath,
    this.secondDetailsPath,
    super.key,
  });

  final String label;

  final String detailsPath;

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

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    required this.label,
    this.param,
    this.extra,
    this.withScaffold = true,
    super.key,
  });

  final String label;

  final String? param;

  final Object? extra;

  final bool withScaffold;

  @override
  State<StatefulWidget> createState() => DetailsScreenState();
}

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
