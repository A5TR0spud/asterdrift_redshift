extends Node2D

@onready var Cooldown := $MassDriverCooldown
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

func _physics_process(_delta):
	if !Cooldown.is_stopped():
		return
	if RunHandler.QueuedMassDriverPackages.Metals > 0:
		RunHandler.QueuedMassDriverPackages.Metals = 0
		Cooldown.start()
		var t: DriverCanister = PackagePrefab.instantiate()
		t.Type = Materials.Mats.Metals
		List.add_child(t)
		t.Dispatch(PlayerClass.Instance.global_position, self)
		return
	if RunHandler.QueuedMassDriverPackages.Ceramics > 0:
		RunHandler.QueuedMassDriverPackages.Ceramics = 0
		Cooldown.start()
		var t: DriverCanister = PackagePrefab.instantiate()
		t.Type = Materials.Mats.Ceramics
		List.add_child(t)
		t.Dispatch(PlayerClass.Instance.global_position, self)
		return
	if RunHandler.QueuedMassDriverPackages.Organics > 0:
		RunHandler.QueuedMassDriverPackages.Organics = 0
		Cooldown.start()
		var t: DriverCanister = PackagePrefab.instantiate()
		t.Type = Materials.Mats.Organics
		List.add_child(t)
		t.Dispatch(PlayerClass.Instance.global_position, self)
		return
	if RunHandler.QueuedMassDriverPackages.Synthetics > 0:
		RunHandler.QueuedMassDriverPackages.Synthetics = 0
		Cooldown.start()
		var t: DriverCanister = PackagePrefab.instantiate()
		t.Type = Materials.Mats.Synthetics
		List.add_child(t)
		t.Dispatch(PlayerClass.Instance.global_position, self)
		return

func _on_world_player_warp(amount: Vector2) -> void:
	for child: DriverCanister in List.get_children():
		child.OffsetBeginning(amount)
