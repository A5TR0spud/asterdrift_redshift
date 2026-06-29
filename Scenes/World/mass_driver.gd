extends Node2D

@onready var Cooldown : Timer = $MassDriverCooldown
@onready var List := $List
static var PackagePrefab := preload("res://Scenes/Utilities/Station/driver_package.tscn")


func _ready():
	if Engine.is_editor_hint():
		return
	if UpgradesManager.Load("MassDriver") < 1:
		hide()
		queue_free()
	else:
		show()

func _on_mass_driver_cooldown_timeout():
	if !RunHandler.IsInRun():
		Cooldown.stop()
		return
	if RunHandler.SendMassDriverPackage():
		var t: DriverCanister = PackagePrefab.instantiate()
		List.add_child(t)
		t.Dispatch(PlayerClass.Instance.global_position, self)

func _on_world_player_warp(amount: Vector2) -> void:
	for child: DriverCanister in List.get_children():
		child.OffsetBeginning(amount)
