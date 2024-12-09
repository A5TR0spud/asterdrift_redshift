extends Node
class_name RunHandler

static var Mats: Materials
static var _is_running : bool = false

static func IsInRun() -> bool:
	return _is_running

static func StartRun() -> void:
	if _is_running:
		return
	_is_running = true
	if Mats == null:
		Mats = Materials.new()
	Mats.Metals = 0
	Mats.Ceramics = 0
	Mats.Synthetics = 0
	Mats.Organics = 0
	Mats.Components = 0

static func EndRun() -> void:
	if !_is_running:
		return
	_is_running = false
	MaterialsManager.Mats.Metals += Mats.Metals
	MaterialsManager.Mats.Ceramics += Mats.Ceramics
	MaterialsManager.Mats.Synthetics += Mats.Synthetics
	MaterialsManager.Mats.Organics += Mats.Organics
	MaterialsManager.Mats.Components += Mats.Components
	MaterialsManager.Save()
