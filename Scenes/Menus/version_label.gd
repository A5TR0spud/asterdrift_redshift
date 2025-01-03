@tool
extends Label

func _ready():
	text = ProjectSettings.get_setting("application/config/version", "something went wrong when determining version")
