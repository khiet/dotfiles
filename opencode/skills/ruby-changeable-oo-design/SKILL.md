---
name: ruby-changeable-oo-design
description: Apply practical OO design in Ruby to reduce change cost using SRP, dependency management, message-focused interfaces, and composition.
compatibility: opencode
metadata:
  audience: ruby-and-rails-engineers
  focus: design-for-change
  additive: "true"
---

## Scope

Implementing or refactoring Ruby/Rails code where maintainability, extensibility, and long-term change cost matter.

## Core Goal

Future changes stay low-cost: transparent, reasonable, usable, exemplary.

## Principles

- Small, single-purpose objects (SRP) with clear public responsibilities.
- Depend on abstractions and behavior, not concrete classes or internal data shape.
- Low coupling via DI, narrow interfaces, stable message contracts.
- **Law of Demeter**: don't reach through object chains.
- Prefer composition and role-based collaboration over deep inheritance.
- Use inheritance only for stable abstractions with true substitutability.
- DRY for *knowledge*, not by forcing brittle abstractions.

## Message-First Design

- Start from messages and responsibilities, then choose object boundaries.
- Tell-don't-ask collaboration.
- Intention-revealing public methods; hide implementation details.
- Replace class-switching (`is_a?`, `kind_of?`, case-on-class) with role interfaces.

## Dependency Management

- Isolate complex construction behind factories/builders.
- Keyword args or options hashes to reduce positional coupling.
- Centralize external calls behind adapters or private helpers.
- Depend in the direction of stability: volatile -> stable.

## Testing

> For detailed test strategy, see the **testing-best-practices** skill.

Key OO-specific points:
- Test public behavior, not private implementation.
- Shared examples for role contracts and substitutable implementations.
- Verifying doubles when mocking collaborator commands.

## Quality Bar

Before finishing, confirm:
- Each object has one main reason to change.
- Collaborations are message-based and context-light.
- Coupling and knowledge of external internals are minimized.
- Tests describe interfaces and survive reasonable refactors.
