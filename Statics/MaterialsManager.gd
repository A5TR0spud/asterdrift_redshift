extends Node
class_name MaterialsManager

static var Mats: Materials = Materials.new()
#static var Metals : int = 0
#static var Ceramics : int = 0
#static var Synthetics : int = 0
#static var Organics : int = 0
#static var Components : int = 0

const RESOURCE_PATH : String = "user://resources.json"

static var _isLoaded : bool = false

static func Save() -> void:
	if Mats == null:
		Mats = Materials.new()
	var data := {
		"metal": Mats.Metals,
		"glass": Mats.Ceramics,
		"plastic": Mats.Synthetics,
		"bio": Mats.Organics,
		"components": Mats.Components,
	}

	var json_string := JSON.stringify(data, "\t")

	# We will need to open/create a new file for this data string
	var file_access := FileAccess.open(RESOURCE_PATH, FileAccess.WRITE)
	if not file_access:
		print("An error happened while saving data: ", FileAccess.get_open_error())
		return

	file_access.store_string(json_string)
	file_access.close()

static func Load():
	if Mats == null:
		Mats = Materials.new()
	if _isLoaded:
		return
	_isLoaded = true
	
	if not FileAccess.file_exists(RESOURCE_PATH):
		return
	var file_access := FileAccess.open(RESOURCE_PATH, FileAccess.READ)
	var json_string := FileAccess.get_file_as_string(RESOURCE_PATH)
	file_access.close()

	var json := JSON.new()
	var error := json.parse(json_string)
	if error:
		print("JSON Parse Error: ", error)
		return
	# We saved a dictionary, lets assume is a dictionary
	var data:Dictionary = json.data
	Mats.Metals = data.get("metal", 0)
	Mats.Ceramics = data.get("glass", 0)
	Mats.Synthetics = data.get("plastic", 0)
	Mats.Organics = data.get("bio", 0)
	Mats.Components = data.get("components", 0)
