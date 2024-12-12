extends Node2D

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
	if !UpgradesManager.LoadIsEnabled("MovementMode"):
		UpgradesManager.Save("CameraMode", 1, true)
	emit_signal("reload_display")
	_onAllUpgradeChildren(self, _relVis)
