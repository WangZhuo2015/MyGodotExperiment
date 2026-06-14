extends SceneTree

const TestPlacementValidatorScript := preload("res://scripts/tests/TestPlacementValidator.gd")
const TestSaveLoadScript := preload("res://scripts/tests/TestSaveLoad.gd")

func _initialize() -> void:
	var failures: Array[String] = []
	failures.append_array(TestPlacementValidatorScript.new().run())
	failures.append_array(TestSaveLoadScript.new().run())
	if failures.is_empty():
		print("All tests passed.")
		quit(0)
	else:
		push_error("%d test(s) failed:" % failures.size())
		for failure in failures:
			push_error("- " + failure)
		quit(1)
