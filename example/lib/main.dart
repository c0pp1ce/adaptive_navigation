
import 'package:adaptive_navigation_widget/adaptive_navigation_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Example());
}

/// A very basic example to showcase the usage of [AdaptiveNavigation].
///
/// It uses an [IndexedStack] to display the different screens.
class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  int _index = 0;

  final List<AdaptiveDestination> destinations = [
    const AdaptiveDestination(
      initialLocation: "/home",
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: "Home",
    ),
    const AdaptiveDestination(
      initialLocation: "/feed",
      icon: Icon(Icons.feed_outlined),
      selectedIcon: Icon(Icons.feed),
      label: "Feed",
    ),
    const AdaptiveDestination(
      initialLocation: "/profile",
      icon: Icon(Icons.person_outlined),
      selectedIcon: Icon(Icons.person),
      label: "Profile",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          surfaceTint: Colors.transparent,
        ),
      ),
      home: Builder(builder: (context) {
        return AdaptiveNavigation(
          destinations: destinations,

          /// Low values to show the auto-added drawer.
          bottomNavigationOverflow: 2,
          railNavigationOverflow: 2,

          /// Makes the scaffold used by this widget the primary scaffold.
          /// Should be 'false' if no appBar is set.
          //primary: true, <-- default value.
          appBar: AppBar(
            title: Text(destinations[_index].label),

            /// Matches the width of the rail.
            /// This way the button to open the drawer is aligned with the rail
            /// items.
            leadingWidth: 80,
          ),
          navigationTypeResolver: (context) {
            final screenWidth = MediaQuery.of(context).size.width;
            if (screenWidth > 1280) {
              return NavigationType.permanentDrawer;
            } else if (screenWidth > 800) {
              return NavigationType.extendedRail;
            } else if (screenWidth > 600) {
              return NavigationType.rail;
            } else {
              return NavigationType.bottom;
            }
          },

          /// Updates the index in order to switch what the [IndexedStack] is
          /// displaying.
          onLocationChanged: (context, location, index) {
            if (index != _index) {
              setState(() {
                _index = index;
              });
            }
          },
          child: IndexedStack(
            index: _index,
            children: const [
              Tab(
                title: "Home",
                content: "I am the home tab!",
              ),
              Tab(
                title: "Feed",
                content: "Here could be some feed!",
              ),
              Tab(
                title: "Profile",
                content: "This is me!",
              ),
            ],
          ),
        );
      }),
    );
  }
}

/// Simple placeholder screen.
class Tab extends StatelessWidget {
  const Tab({
    required this.title,
    required this.content,
    Key? key,
  }) : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 'false' since the outer [Scaffold] is used to display the primary appBar.
      primary: false,
      backgroundColor: Colors.blueAccent.withOpacity(0.3),
      body: Center(
        child: Text(content),
      ),
    );
  }
}

/// Showcases how to access the key of the scaffold used by the [AdaptiveNavigation]
/// in order to control the drawer.
class OpenDrawerButton extends StatelessWidget {
  const OpenDrawerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationScaffoldKeyProvider =
        NavigationScaffoldKeyProvider.maybeOf(context);

    if (navigationScaffoldKeyProvider?.scaffoldKey.currentState?.hasDrawer ??
        false) {
      return IconButton(
        padding: EdgeInsets.zero,
        onPressed: () => navigationScaffoldKeyProvider?.scaffoldKey.currentState
            ?.openDrawer(),
        icon: const Icon(Icons.menu),
      );
    } else {
      return const SizedBox(
        width: 0,
        height: 0,
      );
    }
  }
}
