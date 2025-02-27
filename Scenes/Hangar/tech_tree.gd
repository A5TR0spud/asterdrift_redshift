@tool
extends Node2D
@warning_ignore("unused_signal")
signal reload_display

const UPGRADES_PER_THREAD: int = 5
var _Threads: Array[Thread]

func _ready():
	if Engine.is_editor_hint():
		return
	_Threads = []
	_reloadChildren(0)
	_onAllUpgradeChildren(self, _connect)
	_onAllUpgradeChildren(self, _propo)

var t: float = 0.0
func _physics_process(delta):
	if !Engine.is_editor_hint():
		return
	t += delta
	if t > 0.2:
		_onAllUpgradeChildren(self, _relVis)
		t = 0.0

func _connect(child: Upgrade) -> void:
	child.upgrade_successfully_bought.connect(_reloadChildren)

func _onAllUpgradeChildren(parent: Node, toRun: Callable) -> void:
	var i: int = 0
	for child : Node2D in parent.get_children():
		i += 1
		if _Threads.size() < i:
			_Threads.append(Thread.new())
		if child is Upgrade:
			if _Threads[i - 1].is_started():
				_threadFunction(child, toRun)
			else:
				_Threads[i - 1].start(_threadFunction.bind(child, toRun))
		elif child is Node:
			_onAllUpgradeChildren(child, toRun)

	for _thread: Thread in _Threads:
		if _thread.is_started():
			_thread.wait_to_finish()

func _threadFunction(child: Node, toRun: Callable) -> void:
	call_thread_safe(toRun.get_method(), child)

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
	DataManager.Save("UpcyclerCount", 0)

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
