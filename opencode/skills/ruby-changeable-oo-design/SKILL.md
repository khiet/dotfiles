---
name: ruby-changeable-oo-design
description: Apply practical OO design in Ruby to reduce change cost using SRP, dependency management, message-focused interfaces, and composition.
---

# Ruby Changeable OO Design

Design Ruby/Rails code so the next change is cheap. The target is **TRUE** code (Sandi Metz): **T**ransparent (consequences are visible), **R**easonable (cost is proportional to the change), **U**sable in new contexts, **E**xemplary as a pattern for the next edit. Every rule below is a lever on change cost. Use when implementing or refactoring where maintainability and long-term change cost matter.

## Principles

- Small, single-purpose objects (SRP) with clear public responsibilities.
- Depend on abstractions and behavior, not concrete classes or internal data shape.
- Low coupling via DI, narrow interfaces, stable message contracts.
- **Law of Demeter**: don't reach through object chains.
- Prefer composition and role-based collaboration over deep inheritance; use inheritance only for stable abstractions with true substitutability.
- DRY for *knowledge*, not by forcing brittle abstractions.

## Message-First Design

- Start from messages and responsibilities, then choose object boundaries.
- **Tell, don't ask**: send objects commands, don't interrogate their state and decide for them.
- Intention-revealing public methods; hide implementation details.
- Replace class-switching (`is_a?`, `kind_of?`, case-on-class) with role interfaces.

## Dependency Management

- Isolate complex construction behind factories/builders.
- Keyword args or options hashes to reduce positional coupling.
- Centralize external calls behind adapters or private helpers.
- Depend in the direction of stability: volatile -> stable.

## Testing

> For test strategy, see the **testing-best-practices** skill. OO-specific points:

- Test public behavior, not private implementation.
- Shared examples for role contracts and substitutable implementations.
- Verifying doubles when mocking collaborator commands.

## Quality Bar

Before finishing, confirm:
- Each object has one main reason to change.
- Collaborations are message-based and context-light.
- Coupling and knowledge of external internals are minimized.
- Tests describe interfaces and survive reasonable refactors.
