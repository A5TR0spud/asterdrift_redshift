extends GridContainer

var _timeLeft: float = 180.0

func _ready():
	_reload()

func _reload():
	visible = UpgradesManager.Load("CoreAssembler") > 0
	_timeLeft = DataManager.Load("coreAssemblyTimeLeft", 180.0)
	MaterialsManager.Load()
	while _timeLeft <= 0.0:
		_timeLeft += 180.0
		MaterialsManager.Mats.Components += 1
	DataManager.Save("coreAssemblyTimeLeft", _timeLeft)
	MaterialsManager.Save()
	var minutes: int = floori(_timeLeft / 60.0)
	var seconds: int = int(_timeLeft) % 60
	$Label.text = String.num(minutes, 0) + ":" + ("0" if seconds < 10 else "") + String.num(seconds, 0) 
