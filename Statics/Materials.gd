extends Resource
class_name Materials

@export var Metals : int = 0
@export var Ceramics : int = 0
@export var Synthetics : int = 0
@export var Organics : int = 0
@export var Components : int = 0

enum Mats {
	# Materials
	Metals,
	Ceramics,
	Synthetics,
	Organics,
	Components,
	# Energy (For Notifications)
	Energy,
	BackupEnergy,
	Danger,
}
