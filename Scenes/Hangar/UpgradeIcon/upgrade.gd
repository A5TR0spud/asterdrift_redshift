@tool
extends Node2D
class_name Upgrade

signal upgrade_successfully_bought(level : int)

@onready var MainIcon = $MainIcon
@onready var AvailableIcon = $MainIcon/IsAvailableIcon
@onready var NameT = $Tooltip/Nameplate
@onready var DescT = $Tooltip/Description
@onready var CostT = $Tooltip/Costs

@export_group("Main")
@export var NAME : String = "NAME":
	get:
		return NAME
	set(value):
		NAME = value
		if is_node_ready():
			_updateTooltip()
@export var DESCRIPTION : String = "DESC":
	get:
		return DESCRIPTION
	set(value):
		DESCRIPTION = value
		if is_node_ready():
			_updateTooltip()
## Used by the save system to save and load this node's information.
@export var INTERNAL_NAME : String = "undefined"
@export var PARENT_UPGRADE : Upgrade = null
@export var SPRITE : Texture2D = null:
	get:
		return SPRITE
	set(value):
		SPRITE = value
		if is_node_ready():
			MainIcon.texture = SPRITE
@export var MAX_LEVEL : int = 1
@export_group("Cost")
@export var METAL_COST : int = 0:
	get:
		return METAL_COST
	set(value):
		METAL_COST = value
		if is_node_ready():
			_updateTooltip()
@export var CERAMIC_COST : int = 0:
	get:
		return CERAMIC_COST
	set(value):
		CERAMIC_COST = value
		if is_node_ready():
			_updateTooltip()
@export var SYNTHETIC_COST : int = 0:
	get:
		return SYNTHETIC_COST
	set(value):
		SYNTHETIC_COST = value
		if is_node_ready():
			_updateTooltip()
@export var ORGANIC_COST : int = 0:
	get:
		return ORGANIC_COST
	set(value):
		ORGANIC_COST = value
		if is_node_ready():
			_updateTooltip()

var CurrentLevel : int = 0:
	get:
		return CurrentLevel
	set(value):
		CurrentLevel = value
		if is_node_ready():
			pass

var is_readied : bool = false
func _ready():
	is_readied = true
	MainIcon.texture = SPRITE
	ReloadVisible()
	_updateTooltip()

func _updateTooltip():
	NameT.text = NAME
	DescT.text = DESCRIPTION
	CostT.METAL = METAL_COST
	CostT.CERAMIC = CERAMIC_COST
	CostT.SYNTHETIC = SYNTHETIC_COST
	CostT.ORGANIC = ORGANIC_COST

func ReloadVisible():
	if !is_readied:
		return
	modulate = Color(1, 1, 1, 1)
	AvailableIcon.hide()
	if _can_buy():
		AvailableIcon.show()
	else:
		modulate = Color(0.5, 0.5, 0.5, 1)

func _on_button_pressed():
	_try_buy()

func _try_buy():
	if !_can_buy:
		return
	MaterialsManager.Metals -= METAL_COST
	MaterialsManager.Ceramics -= CERAMIC_COST
	MaterialsManager.Synthetics -= SYNTHETIC_COST
	MaterialsManager.Organics -= ORGANIC_COST
	CurrentLevel += 1
	emit_signal("upgrade_successfully_bought", CurrentLevel)
	MaterialsManager.Save()
	ReloadVisible()

func _can_buy():
	MaterialsManager.Load()
	if MaterialsManager.Metals < METAL_COST:
		return false
	if MaterialsManager.Ceramics < CERAMIC_COST:
		return false
	if MaterialsManager.Synthetics < SYNTHETIC_COST:
		return false
	if MaterialsManager.Organics < ORGANIC_COST:
		return false
	return CurrentLevel < MAX_LEVEL
