extends Node
class_name UpgradesManager

const RESOURCE_PATH : String = "user://upgrades.json"

static var _isLoaded : bool = false
static var _data : Dictionary

static func Save(internalName : String, level : int, enabled: bool = true) -> void:
	_data.get_or_add(internalName, level)
	_data[internalName] = level
	
	_data.get_or_add(internalName + "_enabled", enabled)
	_data[internalName + "_enabled"] = enabled

	var json_string := JSON.stringify(_data, "\t")

	# We will need to open/create a new file for this data string
	var file_access := FileAccess.open(RESOURCE_PATH, FileAccess.WRITE)
	if not file_access:
		print("An error happened while saving data: ", FileAccess.get_open_error())
		return

	file_access.store_string(json_string)
	file_access.close()

static func Load(internalName : String, careForEnabled: bool = true) -> int:
	if !_isLoaded:
		if not FileAccess.file_exists(RESOURCE_PATH):
			return 0
		var file_access := FileAccess.open(RESOURCE_PATH, FileAccess.READ)
		var json_string := FileAccess.get_file_as_string(RESOURCE_PATH)
		file_access.close()

		var json := JSON.new()
		var error := json.parse(json_string)
		if error:
			print("JSON Parse Error: ", error)
			return 0
		_data = json.data
	_isLoaded = true
	if careForEnabled && !LoadIsEnabled(internalName):
		return 0
	return _data.get(internalName, 0)
	
static func LoadIsEnabled(internalName : String) -> bool:
	Load(internalName, false)
	return _data.get(internalName + "_enabled", false) && Load(internalName, false) > 0
