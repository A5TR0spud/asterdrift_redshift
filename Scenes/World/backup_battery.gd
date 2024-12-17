extends ProgressBar

func _ready():
	if UpgradesManager.Load("BackupShield") < 1:
		hide()
		queue_free()
	else:
		show()

func _process(delta):
	value = RunHandler.BackupBattery
	if RunHandler.BackupBattery <= 0:
		hide()
