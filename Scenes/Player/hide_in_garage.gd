extends Node2D

@onready var Player: PlayerClass = $".."

func _ready():
	if Player.IS_IN_GARAGE:
		queue_free()
		hide()
	else:
		show()
		if UpgradesManager.Load("Stage0") > 0:
			$TopRight.color = Color("ffffb7")
			$BottomRight.color = Color("ffffb7")
			$TopLeft.color = Color("ffffb7")
			$BottomLeft.color = Color("ffffb7")
			$ReverseLeft.color = Color("ffffb7")
			$ReverseRight.color = Color("ffffb7")
		else:
			$TopRight.color = Color("bfdfff")
			$BottomRight.color = Color("bfdfff")
			$TopLeft.color = Color("bfdfff")
			$BottomLeft.color = Color("bfdfff")
			$ReverseLeft.color = Color("bfdfff")
			$ReverseRight.color = Color("bfdfff")
		if UpgradesManager.Load("IonDrive") > 0:
			$Main.color = Color("bfdfff")
		else:
			$Main.color = Color("ffffb7")
