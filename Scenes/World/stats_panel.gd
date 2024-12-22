extends PanelContainer

@onready var x = $StatsContainer/ResourceCounter
@onready var y = $StatsContainer/Time
@onready var z = $StatsContainer/Distance

func run():
	x.Display = RunHandler.Mats
	y.text = "Time Spent: " + String.num(RunHandler.TimeSpent, 1) + " seconds"
	z.text = "Distance Covered: " + String.num(RunHandler.DistanceTravelled / 16.0, 1) + "u"
