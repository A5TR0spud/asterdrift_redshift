extends Node
class_name RunHandler

static var METAL : int = 0
static var CERAMIC : int = 0
static var SYNTHETIC : int = 0
static var ORGANIC : int = 0
static var _is_running : bool = false

static func IsInRun() -> bool:
	return _is_running

static func StartRun() -> void:
	if _is_running:
		return
	_is_running = true
	METAL = 0
	CERAMIC = 0
	SYNTHETIC = 0
	ORGANIC = 0

static func EndRun() -> void:
	if !_is_running:
		return
	_is_running = false
	MaterialsManager.Metals += METAL
	MaterialsManager.Ceramics += CERAMIC
	MaterialsManager.Synthetics += SYNTHETIC
	MaterialsManager.Organics += ORGANIC
	MaterialsManager.Save()
