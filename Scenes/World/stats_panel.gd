extends PanelContainer

@onready var x = $StatsContainer/ResourceCounter

func run():
	x.Display = RunHandler.Mats
