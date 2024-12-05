extends PanelContainer

@onready var x = $StatsContainer/ResourceCounter

func run():
	x.METAL = RunHandler.METAL
	x.CERAMIC = RunHandler.CERAMIC
	x.SYNTHETIC = RunHandler.SYNTHETIC
	x.ORGANIC = RunHandler.ORGANIC
