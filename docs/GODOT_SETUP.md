# Godot Setup

Use Godot 4.x with GDScript. Open this folder as a Godot project and run `res://scenes/main/Main.tscn`.

The project is configured for a 480x270 internal resolution, canvas item stretch, nearest texture filtering, and 2D pixel snapping.

## Run The Prototype

```bash
godot --path /Users/wangzhuo/Documents/MyGodotExperiment
```

## Run Logic Tests

```bash
godot --headless --path /Users/wangzhuo/Documents/MyGodotExperiment --script res://scripts/tests/RunTests.gd
```

The tests are intentionally plugin-free and cover placement validation plus save/load serialization.
