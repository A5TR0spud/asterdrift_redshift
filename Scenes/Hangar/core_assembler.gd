extends GridContainer
class_name CoreAssemblerClass

const INITIAL_TIME_PER_CORE: float = 180.0

var _timeLeft: float = INITIAL_TIME_PER_CORE

func _ready():
	_reload()

func _reload():
	visible = UpgradesManager.Load("CoreAssembler") > 0
	_timeLeft = DataManager.Load("coreAssemblyTimeLeft", GetTimePerCore())
	MaterialsManager.Load()
	if _timeLeft > GetTimePerCore():
		_timeLeft = GetTimePerCore()
	while _timeLeft <= 0.0:
		_timeLeft += GetTimePerCore()
		MaterialsManager.Mats.Components += 1
	DataManager.Save("coreAssemblyTimeLeft", _timeLeft)
	MaterialsManager.Save()
	var minutes: int = floori(_timeLeft / 60.0)
	var seconds: int = int(_timeLeft) % 60
	$Label.text = String.num(minutes, 0) + ":" + ("0" if seconds < 10 else "") + String.num(seconds, 0) 

static func GetTimePerCore() -> float:
	var x: float = INITIAL_TIME_PER_CORE
	x -= 30.0 * UpgradesManager.Load("SwiftAssembly")
	return x
