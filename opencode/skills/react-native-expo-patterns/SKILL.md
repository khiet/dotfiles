---
name: react-native-expo-patterns
description: Write maintainable React Native / Expo code with disciplined component design, hook hygiene, Zustand state management, and platform-aware patterns.
compatibility: opencode
metadata:
  audience: react-native-expo-engineers
  focus: component-architecture-and-state
  additive: true
---

## Scope

React Native and Expo application code: components, hooks, state management, navigation, and platform-specific behavior. Covers architecture decisions that compound over time — not styling or pixel work (see **ui-ux-implementation** skill for that).

## Component Design

### Structure
- **One exported component per file.** Internal subcomponents are fine but should move to their own file once they take props or grow past ~30 lines.
- Components do one of two jobs: **orchestrate** (fetch data, manage state, coordinate children) or **render** (accept props, return JSX). Mixing both is the root of most component rot.
- Extract logic into custom hooks when two or more components need it, or when the logic is complex enough to test independently. Do NOT extract hooks just to make a component file shorter.

### Props Discipline
- Keep prop surfaces small. If a component takes >5-6 props, it's likely doing too much or needs composition (children, render props, compound pattern).
- **Never spread unknown props** (`{...rest}`) onto native elements without explicit intent — it's a source of silent bugs in RN where invalid props cause yellow-box warnings or crashes.
- Prefer explicit prop types over `any`. When typing is inconvenient, that's a signal the interface is unclear.

### Composition Over Configuration
- Prefer `children` and compound components over deeply nested config objects.
- A component with a growing list of boolean flags (`showHeader`, `showFooter`, `isCompact`, `hasAvatar`) should be decomposed, not extended.
- Slots and render props are preferable to adding more conditional branches inside one component.

## Hook Hygiene

### Dependency Arrays
- **Every value from the enclosing scope that the effect/callback/memo reads must be in the dependency array.** No exceptions, no `// eslint-disable-next-line`. If the deps cause too many re-runs, the solution is restructuring — not lying to React.
- `useCallback` and `useMemo`: use them to **stabilize references passed to children or effects**, not as a general performance tool. Memoizing everything is noise; memoize at the boundaries where identity matters (context values, list item renderers, effect deps).

### Custom Hook Conventions
- Name hooks `use<Thing>` — no exceptions.
- A hook should return a **stable contract**: ideally an object with named fields, not a positional tuple beyond 2-3 values.
- Hooks that call APIs should return `{ data, error, isLoading }` at minimum. Don't make callers guess loading/error states.
- Keep hooks composable: a hook should not assume it's the only hook in the component. Avoid hooks that secretly subscribe to global state the caller doesn't expect.

## State Management (Zustand)

### Store Design
- **One store per domain concern**, not one global mega-store. Examples: `useAuthStore`, `useCartStore`, `useNotificationStore`.
- Keep store state flat. Nested objects cause stale-reference bugs and make selectors harder.
- Actions live inside the store (`set` calls), not scattered across components. Components call actions; they don't call `set` directly.
- Derive computed values with selectors, not by duplicating state. If you're syncing two pieces of state, one of them shouldn't exist.

### Selector Discipline
- **Always use selectors** to subscribe to specific slices: `useCartStore(s => s.items)`, never `useCartStore()` (subscribes to everything, re-renders on every change).
- For selectors returning new objects/arrays, use `shallow` from Zustand or memoize: `useCartStore(s => s.items.filter(i => i.active), shallow)`.
- If a selector is used in 3+ places, extract it as a named function on the store file.

### Async and Side Effects
- Keep async operations (API calls) in store actions or dedicated hooks, not in components.
- Store loading/error state alongside the data it describes, not in a separate global flag.
- Optimistic updates: apply the change immediately, revert on error. Don't make the user wait for the server when you can predict the outcome.

## Navigation (Expo Router / React Navigation)

- Keep screen components thin: fetch data, wire up state, render presentational children. Screen files are orchestrators.
- Don't pass large objects through navigation params. Pass IDs and let the screen fetch/select from store.
- Deep link and universal link support: every meaningful screen should be reachable by URL. Design route structure with this in mind from the start.
- Protect authenticated routes at the layout/navigator level, not per-screen.

## Platform-Specific Code

- Use `Platform.select` or `.ios.tsx`/`.android.tsx` file extensions for divergent behavior. Avoid `Platform.OS === 'ios'` conditionals scattered through component bodies.
- Test on both platforms regularly. Shadows, fonts, keyboard behavior, and safe areas diverge in ways that aren't visible on one platform.
- Expo-managed APIs over bare RN modules when both exist. Prefer `expo-haptics` over `react-native-haptic-feedback`, etc. — they handle config and linking.

## Performance

- **FlatList/FlashList**: always provide `keyExtractor`, `getItemLayout` (when possible), and avoid inline arrow functions for `renderItem`. Extract the renderer as a memoized component.
- Avoid creating new objects/arrays/functions inside render. This is the #1 cause of unnecessary re-renders in list-heavy mobile apps.
- `React.memo` is useful for list items and expensive subtrees. Wrap the component, not the JSX.
- Images: use `expo-image` with proper caching. Never load full-resolution images into thumbnails.
- Animations: use `react-native-reanimated` worklets for gesture-driven and layout animations. Never animate on the JS thread for 60fps interactions.

## Anti-Patterns

- Putting API calls in `useEffect` without cleanup/cancellation (race conditions on fast navigation).
- Storing server state in Zustand that should live in a fetch cache (consider React Query / TanStack Query for server state if it grows complex).
- Using `useEffect` to sync props to state — this is almost always a bug. Derive instead.
- Deeply nested ternaries in JSX. Extract to early returns or subcomponents.
- `setTimeout`/`setInterval` in components without cleanup.

## Quality Bar

Before finishing, confirm:
- Components have a clear single responsibility (orchestrate or render).
- Zustand stores are sliced by domain with selector-based subscriptions.
- No dependency array lies or disabled lint rules for hooks.
- Platform differences are handled explicitly, not accidentally.
- List rendering is optimized (stable keys, memoized renderers, no inline closures).
