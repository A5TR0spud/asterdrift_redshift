extends GridContainer

var _timeLeft: float = 300.0

func _ready():
	_reload()

func _reload():
	visible = UpgradesManager.Load("CoreAssembler") > 0
	_timeLeft = DataManager.Load("coreAssemblyTimeLeft", 300.0)
	MaterialsManager.Load()
	while _timeLeft <= 0.0:
		_timeLeft += 300.0
		MaterialsManager.Mats.Components += 1
	DataManager.Save("coreAssemblyTimeLeft", _timeLeft)
	MaterialsManager.Save()
	var minutes: int = floori(_timeLeft / 60.0)
	var seconds: int = floori(_timeLeft - minutes * 60)
	$Label.text = String.num(minutes, 0) + ":" + String.num(seconds, 0) + ("0" if seconds < 10 else "") 
