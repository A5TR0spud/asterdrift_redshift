extends Node
class_name MaterialsManager

static var Metals : int = 0
static var Ceramics : int = 0
static var Synthetics : int = 0
static var Organics : int = 0

const RESOURCE_PATH : String = "user://resources.tres"

static var _isLoaded : bool = false

static func Save() -> void:
	var data := {
		"metal": Metals,
		"glass": Ceramics,
		"plastic": Synthetics,
		"bio": Organics,
	}

	var json_string := JSON.stringify(data, "/t")

	# We will need to open/create a new file for this data string
	var file_access := FileAccess.open(RESOURCE_PATH, FileAccess.WRITE)
	if not file_access:
		print("An error happened while saving data: ", FileAccess.get_open_error())
		return

	file_access.store_string(json_string)
	file_access.close()

static func Load():
	if _isLoaded:
		return
	_isLoaded = true
	
	if not FileAccess.file_exists(RESOURCE_PATH):
		return
	var file_access := FileAccess.open(RESOURCE_PATH, FileAccess.READ)
	var json_string := file_access.get_line()
	file_access.close()

	var json := JSON.new()
	var error := json.parse(json_string)
	if error:
		print("JSON Parse Error: ", error)
		return
	# We saved a dictionary, lets assume is a dictionary
	var data:Dictionary = json.data
	Metals = data.get("metal", 0)
	Ceramics = data.get("glass", 0)
	Synthetics = data.get("plastic", 0)
	Organics = data.get("bio", 0)
