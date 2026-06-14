# Room Organization Vertical Slice Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a clean Godot 4 vertical-slice framework for a 2D pixel-art room organization prototype.

**Architecture:** Data resources define items, surfaces, and levels. Runtime nodes handle dragging and display. Placement validation, snapping, z sorting, and save/load remain small focused scripts that can be tested without playing the whole scene.

**Tech Stack:** Godot 4.x, GDScript, 2D CanvasItem drawing, JSON save data.

---

### Task 1: Project Scaffold

**Files:** `project.godot`, `scenes/**`, `scripts/**`, `docs/**`

- [x] Create the requested Godot folder structure.
- [x] Configure 480x270 viewport, nearest filtering, and pixel snapping.
- [x] Add `Main.tscn` as the main scene.

### Task 2: Data And Placement Logic

**Files:** `scripts/item/ItemDef.gd`, `scripts/item/ItemState.gd`, `scripts/placement/*.gd`, `scripts/data/LevelDef.gd`

- [x] Add item, item state, surface, level, placement result, occupancy, snap, z-sort, and validator scripts.
- [x] Keep validation deterministic and independent of real physics.
- [x] Cover allowed surface, forbidden surface, bounds, overlap, wall/floor tags, and rotation footprint rules.

### Task 3: Tests

**Files:** `scripts/tests/RunTests.gd`, `scripts/tests/TestPlacementValidator.gd`, `scripts/tests/TestSaveLoad.gd`

- [x] Add a plugin-free headless test runner.
- [x] Cover the placement and save/load cases listed in the brief.

### Task 4: Playable Scene

**Files:** `scripts/core/LevelManager.gd`, `scripts/item/Item.gd`, `scripts/item/Box.gd`, `scripts/data/DemoDataFactory.gd`, scene files

- [x] Spawn one demo bedroom, five explicit placement surfaces, a cardboard box, and twenty placeholder items.
- [x] Support drag/drop, snap preview, valid/invalid feedback, rotation, overlap rejection, z sorting, save/load, reset, and completion detection.

### Task 5: UI And Docs

**Files:** `scripts/ui/*.gd`, `scenes/ui/*.tscn`, `docs/*.md`

- [x] Add debug and completion panels.
- [x] Document architecture, data model, setup, and future agent tasks.

### Task 6: Verification

**Files:** all project files

- [x] Run the headless test command with Godot 4.6.3 after installing the CLI.
- [x] Run repository-level static checks with `git diff --check`.
- [x] Scan for placeholders, merge conflicts, and stale input-action references.
- [x] Fix obvious static issues and record known limitations.
