extends Node
class_name PlayerStatBlock

## RCS improves controls by preventing overshooting when rotating, improving rotation speed, and applying a braking force when idle.
@export var Has_RCS : bool = false
@export var Has_Better_RCS : bool = false

func _ready():
	if UpgradesManager.Load("RCSThrust") > 0:
		Has_RCS = true
	if UpgradesManager.Load("AdvancedRCS") > 0:
		Has_Better_RCS = true
