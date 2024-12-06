@tool
extends Node2D
class_name Upgrade

## How far up the tech tree to look ahead from bought upgrades
const LOOK_AHEAD : int = 2

signal upgrade_successfully_bought(level : int)
signal notify_children(propogation : int)

@onready var LevelAccent := preload("res://Assets/Hangar/Upgrades/LevelAccentIcon.png")

@onready var MainIcon := $MainIcon
@onready var AvailableIcon := $MainIcon/IsAvailableIcon
@onready var BoolIcon := $MainIcon/BooleanIcon
@onready var Tooltip := $Tooltip
@onready var NameT := $Tooltip/Top/Nameplate
@onready var LeveT := $Tooltip/Top/Levels
@onready var DescT := $Tooltip/Description
@onready var CostT := $Tooltip/Bottom/Costs
@onready var Bottom := $Tooltip/Bottom
@onready var ParentLine := $ParentLine

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
## If true, upgrade will always be bought at 0 cost
@export var PRE_BOUGHT : bool = false
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
	CurrentLevel = UpgradesManager.Load(INTERNAL_NAME)
	ReloadVisible()
	_updateTooltip()
	if PARENT_UPGRADE != null:
		PARENT_UPGRADE.notify_children.connect(ChildIsNotified)
	if PRE_BOUGHT:
		_try_buy()

func _updateTooltip():
	NameT.text = NAME
	DescT.text = DESCRIPTION
	if PRE_BOUGHT:
		LeveT.hide()
	else:
		LeveT.show()
		LeveT.text = String.num(CurrentLevel) + "/" + String.num(MAX_LEVEL)
	CostT.METAL = METAL_COST
	CostT.CERAMIC = CERAMIC_COST
	CostT.SYNTHETIC = SYNTHETIC_COST
	CostT.ORGANIC = ORGANIC_COST

func ChildIsNotified(propogation : int):
	if CurrentLevel > 0 || PARENT_UPGRADE.CurrentLevel > 0:
		propogation = 0
	else:
		propogation += 1
	emit_signal("notify_children", propogation)
	if PRE_BOUGHT:
		_try_buy()
	ReloadVisible()
	hide()
	if propogation < LOOK_AHEAD:
		show()

func ReloadVisible():
	if !is_readied:
		return
	ParentLine.hide()
	if PARENT_UPGRADE:
		ParentLine.show()
		var dir : Vector2 = PARENT_UPGRADE.global_position - global_position
		ParentLine.points[0] = 0.33 * dir
		ParentLine.points[1] = 0.66 * dir
		if PARENT_UPGRADE.CurrentLevel > 0:
			ParentLine.default_color = Color(1,1,1,1)
		else:
			ParentLine.default_color = Color(0.5, 0.5, 0.5, 1)
	if !PARENT_UPGRADE || CurrentLevel > 0:
		emit_signal("notify_children", 0)
	MainIcon.modulate = Color(1, 1, 1, 1)
	BoolIcon.hide()
	AvailableIcon.hide()
	for child in BoolIcon.get_children():
		child.queue_free()
	if _can_buy():
		AvailableIcon.show()
	elif CurrentLevel == 0:
		MainIcon.modulate = Color(0.5, 0.5, 0.5, 1)
	if CurrentLevel != 0:
		BoolIcon.show()
		for i: int in (CurrentLevel - 1) * 2:
			var sprite2d = Sprite2D.new() # Create a new Sprite2D.
			sprite2d.texture = LevelAccent
			var x := i + 2
			if x % 2 == 1:
				x -= 1
				x *= -1
			x /= 2
			sprite2d.position.x = 3 * sign(x) + 3 * x
			BoolIcon.add_child(sprite2d)

func _try_buy() -> void:
	if !_can_buy():
		return
	if !PRE_BOUGHT:
		MaterialsManager.Metals -= METAL_COST
		MaterialsManager.Ceramics -= CERAMIC_COST
		MaterialsManager.Synthetics -= SYNTHETIC_COST
		MaterialsManager.Organics -= ORGANIC_COST
	if PRE_BOUGHT:
		CurrentLevel = MAX_LEVEL
	else:
		CurrentLevel += 1
	
	MaterialsManager.Save()
	UpgradesManager.Save(INTERNAL_NAME, CurrentLevel)
	ReloadVisible()
	emit_signal("upgrade_successfully_bought", CurrentLevel)

func _can_buy() -> bool:
	if !PRE_BOUGHT:
		MaterialsManager.Load()
		if MaterialsManager.Metals < METAL_COST:
			return false
		if MaterialsManager.Ceramics < CERAMIC_COST:
			return false
		if MaterialsManager.Synthetics < SYNTHETIC_COST:
			return false
		if MaterialsManager.Organics < ORGANIC_COST:
			return false
	if PARENT_UPGRADE:
		if PARENT_UPGRADE.CurrentLevel == 0:
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
	emit_signal("notify_children", 0)
