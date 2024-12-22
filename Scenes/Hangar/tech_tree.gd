extends Node2D
@warning_ignore("unused_signal")
signal reload_display

func _ready():
	_reloadChildren(0)
	_onAllUpgradeChildren(self, _connect)
	_onAllUpgradeChildren(self, _propo)

func _connect(child: Upgrade) -> void:
	child.upgrade_successfully_bought.connect(_reloadChildren)

func _onAllUpgradeChildren(parent: Node, toRun: Callable) -> void:
	for child : Node2D in parent.get_children():
		if child is Upgrade:
			toRun.call(child)
		elif child is Node:
			_onAllUpgradeChildren(child, toRun)

func _relVis(child: Upgrade):
	child.ReloadVisible()

func _propo(child: Upgrade):
	if child.PARENT_UPGRADE == null:
		child.emit_signal("notify_children", 0)

func _reloadChildren(_ignored):
	#await get_tree().process_frame
	#if !UpgradesManager.LoadIsEnabled("MovementMode"):
		#UpgradesManager.Save("CameraMode", 1, true)
	emit_signal("reload_display")
	_onAllUpgradeChildren(self, _relVis)

func _reset(child: Upgrade):
	child.CurrentLevel = 0
	UpgradesManager.Save(child.INTERNAL_NAME, 0)

func _on_reset_pressed():
	_onAllUpgradeChildren(self, _reset)
	MaterialsManager.Mats.Ceramics = 0
	MaterialsManager.Mats.Metals = 0
	MaterialsManager.Mats.Components = 0
	MaterialsManager.Mats.Synthetics = 0
	MaterialsManager.Mats.Organics = 0
	MaterialsManager.Save()
	DataManager.Save("coreAssemblyTimeLeft", CoreAssemblerClass.INITIAL_TIME_PER_CORE)
	get_tree().change_scene_to_file("res://Scenes/Hangar/hangar.tscn")
