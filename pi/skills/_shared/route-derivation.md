# Route derivation

Shared mapping from a source file to the route that renders it, for skills that drive the web app or the iOS app. The calling skill decides which files come in and which `Not covered` label a miss gets; this file only says how to map. On iOS a route is a screen: an Expo Router file, or a screen registered with a React Navigation navigator.

## Route

Check in order and stop at the first hit:

1. The router's own listing, when the framework has one (`rails routes`, a build's route manifest, a CLI route dump). It is the source of truth and beats grepping.
2. The file that declares routes: a route config or a file-based router's directory, where the changed file or its owner (controller, page, component) appears. Index or default files map to their directory; dynamic segments are parameters.
3. Otherwise walk renderers and importers of the file up until a routed file is hit: imports, `render` calls, component and partial references, and controller-to-view naming. Three hops without a routed file is a route miss; record the chain walked.

## Parameters

A parameter takes a value the repo states: seeds, fixtures, README, stories. A value counts once the running app answers the route with it; a parameter with no stated value, or one the app rejects, is a parameter miss.

## Tap path (iOS)

The iOS app is reached the way a tester reaches it: by tapping from the app's first screen. Plan the path from the code before driving, then follow it with no exploration:

1. Find the screen's entry points: the `Link`, `router.push`, `router.navigate`, or `navigation.navigate` call sites that target it, or the tab that hosts it.
2. For each, take the label a tester sees on the triggering control: its text child, `accessibilityLabel`, or the tab's `title`/`tabBarLabel`.
3. Walk up the same way from the screen holding that control until reaching the first screen or a tab bar. Prefer the shortest path.
4. A screen or ancestor with no entry point is a route miss; record the chain walked. The calling skill's interaction cap bounds the path length.

The path is an ordered list of labels to tap. Parameters on the way are chosen by tapping, so the parameter rule above applies only when a step needs a specific record: the repo must state which one to tap.
