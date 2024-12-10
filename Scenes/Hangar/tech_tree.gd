extends Node2D

signal reload_display

func _ready():
	_reloadChildren(0)
	_onAllUpgradeChildren(self, _connect)

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

func _reloadChildren(_ignored):
	emit_signal("reload_display")
	_onAllUpgradeChildren(self, _relVis)
