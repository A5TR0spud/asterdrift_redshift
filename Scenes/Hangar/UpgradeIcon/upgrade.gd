@tool
extends Node2D
class_name Upgrade

signal upgrade_successfully_bought(level : int)

@onready var MainIcon = $MainIcon
@onready var AvailableIcon = $MainIcon/IsAvailableIcon
@onready var MaxedIcon = $MainIcon/IsMaxedIcon
@onready var Tooltip = $Tooltip
@onready var NameT = $Tooltip/Top/Nameplate
@onready var LeveT = $Tooltip/Top/Levels
@onready var DescT = $Tooltip/Description
@onready var CostT = $Tooltip/Bottom/Costs

@export_group("Main")
@export var NAME : String = "NAME":
	get:
		return NAME
	set(value):
		NAME = value
		if is_node_ready():
			_updateTooltip()
@export_multiline var DESCRIPTION : String = "DESC":
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
			ReloadVisible()
			_updateTooltip()

var is_readied : bool = false
func _ready():
	Tooltip.hide()
	is_readied = true
	MainIcon.texture = SPRITE
	ReloadVisible()
	_updateTooltip()
	CurrentLevel = UpgradesManager.Load(INTERNAL_NAME)

func _updateTooltip():
	NameT.text = NAME
	DescT.text = DESCRIPTION
	LeveT.text = String.num(CurrentLevel) + "/" + String.num(MAX_LEVEL)
	CostT.METAL = METAL_COST
	CostT.CERAMIC = CERAMIC_COST
	CostT.SYNTHETIC = SYNTHETIC_COST
	CostT.ORGANIC = ORGANIC_COST

func ReloadVisible():
	if !is_readied:
		return
	MainIcon.modulate = Color(1, 1, 1, 1)
	MaxedIcon.hide()
	AvailableIcon.hide()
	if _can_buy():
		AvailableIcon.show()
	elif CurrentLevel != MAX_LEVEL:
		MainIcon.modulate = Color(0.5, 0.5, 0.5, 1)
	else:
		MaxedIcon.show()

func _try_buy() -> void:
	if !_can_buy():
		return
	MaterialsManager.Metals -= METAL_COST
	MaterialsManager.Ceramics -= CERAMIC_COST
	MaterialsManager.Synthetics -= SYNTHETIC_COST
	MaterialsManager.Organics -= ORGANIC_COST
	CurrentLevel += 1
	emit_signal("upgrade_successfully_bought", CurrentLevel)
	MaterialsManager.Save()
	UpgradesManager.Save(INTERNAL_NAME, CurrentLevel)
	ReloadVisible()

func _can_buy() -> bool:
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

func _on_button_mouse_entered():
	Tooltip.show()

func _on_button_mouse_exited():
	Tooltip.hide()

func _on_button_pressed():
	_try_buy()

func _on_upgrade_successfully_bought(level):
	UpgradesManager.Save(INTERNAL_NAME, level)
