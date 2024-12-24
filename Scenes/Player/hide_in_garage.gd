extends Node2D

@onready var Player: PlayerClass = $"../.."

const COMBUSTION_COLOR: String = "ffffb7";
const RCS_COLOR: String = "b7ffff";
const ION_COLOR: String = "7bffff";

func _ready():
	if Player.IS_IN_GARAGE:
		queue_free()
		hide()
	else:
		show()
		if UpgradesManager.Load("Stage0") > 0:
			$TopRight.color = Color(COMBUSTION_COLOR)
			$BottomRight.color = Color(COMBUSTION_COLOR)
			$TopLeft.color = Color(COMBUSTION_COLOR)
			$BottomLeft.color = Color(COMBUSTION_COLOR)
			$ReverseLeft.color = Color(COMBUSTION_COLOR)
			$ReverseRight.color = Color(COMBUSTION_COLOR)
		else:
			$TopRight.color = Color(RCS_COLOR)
			$BottomRight.color = Color(RCS_COLOR)
			$TopLeft.color = Color(RCS_COLOR)
			$BottomLeft.color = Color(RCS_COLOR)
			$ReverseLeft.color = Color(RCS_COLOR)
			$ReverseRight.color = Color(RCS_COLOR)
		if UpgradesManager.Load("IonDrive") > 0:
			$Main.color = Color(ION_COLOR)
		else:
			$Main.color = Color(COMBUSTION_COLOR)
