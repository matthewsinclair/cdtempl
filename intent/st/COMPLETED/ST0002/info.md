---
verblock: "30 Jul 2026:v0.1: matts - Initial version"
intent_version: 2.17.4
status: Completed
slug: port-four-established-projects-to-the-cdsync
created: 20260730
completed: 2026-08-02T09:54:45Z
---

# ST0002: Port four established projects to the Cdsync protocol

## Objective

Give four established projects -- Lamplight, Baize, gyreandgymble and snorkeltoast
-- a design-system record under the Cdsync protocol at `design/system/`, delivered by
Claude Design as one zip per project and installed with `cdsync import`. Each ends up
with a browsable design system, interlinked and with tables of contents, servable
locally from its own repository.

**Nothing that already exists may be lost.** Two of the four carry a complete,
agreed, delivered design programme. That constraint outranks everything else in this
thread.

## Context

These projects massively pre-date Cdsync, and two of them already have a design
convention more mature than anything Cdsync models -- three representations from one
canonical source, with a reading room and a confidentiality split. The job is to
express that under the Cdsync protocol without re-authoring any of it.

The four are not one job but two. Lamplight and Baize have been extracted already
and their drops sit in `intent/_inbox/`; they need **porting**. gyreandgymble and
snorkeltoast were designed inside Claude Design and have never been extracted; they
need **extracting straight into Cdsync's shape** -- which only works if the brief is
written first, because an extract run today would emit the old shape and turn two
ports into four.

Survey completed 30 Jul 2026. Five blockers found and verified, plus one measured.
**Three decisions gate all further work** and are stated at the top of `tasks.md`.
Read that before touching anything: the expensive part of this thread is already
done and written down.

## Acceptance

Acceptance Criteria and Acceptance Tests for this steel thread live in `acceptance.md` (the single source of truth). Do not restate ACs here -- see that file for the ratified completeness boundary and live status.

## Related Steel Threads

- [List any related steel threads here]

## Context for LLM

This document represents a single steel thread - a self-contained unit of work focused on implementing a specific piece of functionality. When working with an LLM on this steel thread, start by sharing this document to provide context about what needs to be done.

### How to update this document

1. Update the status as work progresses
2. Update related documents (design.md, impl.md, etc.) as needed
3. Mark the completion date when finished

The LLM should assist with implementation details and help maintain this document as work progresses.
