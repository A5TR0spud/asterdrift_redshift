extends ProgressBar

func _ready():
	if UpgradesManager.Load("StatusMonitor") < 1:
		hide()
	else:
		show()
