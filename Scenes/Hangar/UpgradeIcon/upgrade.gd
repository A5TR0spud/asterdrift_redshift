@tool
extends Node2D
class_name Upgrade

## How far up the tech tree to look ahead from bought upgrades
const LOOK_AHEAD : int = 1
## How many pixels the cursor can drag before disabling the button
const GRACE : int = 4

@warning_ignore("unused_signal")

signal upgrade_successfully_bought(level : int)
signal notify_children(propogation : int)

@onready var BoolOn := preload("res://Assets/Hangar/Upgrades/Meta/BooleanIconTrue.png")
@onready var BoolOff := preload("res://Assets/Hangar/Upgrades/Meta/BooleanIconFalse.png")

@onready var LevelAccent := preload("res://Assets/Hangar/Upgrades/Meta/LevelAccentIcon.png")
@onready var EmptyLevel := preload("res://Assets/Hangar/Upgrades/Meta/LevelAccentIconEmpty.png")

@onready var MainIcon := $MainIcon
@onready var Butt := $MainIcon/Button
@onready var AvailableIcon := $MainIcon/IsAvailableIcon
@onready var BoolIcon := $MainIcon/BooleanIcon
@onready var Tooltip := $Tooltip
@onready var NameT := $Tooltip/Top/Nameplate
@onready var LeveT := $Tooltip/Top/Levels
@onready var DescT := $Tooltip/Middle/Middleman/Description
@onready var CostT := $Tooltip/Bottom/Costs
@onready var Bottom := $Tooltip/Bottom
@onready var ToggleT := $Tooltip/Bottom/ToggleLabel
@onready var ParentLine := $ParentLine
@onready var LevelBar := $MainIcon/LevelBar
@onready var RequirementT := $Tooltip/Middle/Middleman/Requirements

@export_group("Main")
## The name to be displayed in-game.
@export var NAME : String = "NAME":
	get:
		return NAME
	set(value):
		NAME = value
		if is_node_ready():
			_updateTooltip()
## The description to be displayed in-game.
@export_multiline var DESCRIPTION : String = "DESC":
	get:
		return DESCRIPTION
	set(value):
		DESCRIPTION = value
		if is_node_ready():
			_updateTooltip()
## Used by the save system to save and load this node's information.
@export var INTERNAL_NAME : String = "undefined"
## The visual sprite.
@export var SPRITE : Texture2D = null:
	get:
		return SPRITE
	set(value):
		SPRITE = value
		if is_node_ready():
			MainIcon.texture = SPRITE
@export_subgroup("Parent")
## The parent upgrade determining tree-ism, if any.
@export var PARENT_UPGRADE : Upgrade = null
## Any additional prerequisite upgrades.
@export var REQUIRED_UPGRADES: Array[Upgrade] = []
## Does this upgrade require the parent to be maxed out?
@export var REQUIRE_MAX_PARENT : bool = false
## If true, the upgrade won't be visible regardless of look-ahead if the parent hasn't been bought.
@export var HIDE_WITHOUT_PARENT : bool = false
@export_subgroup("Siblings")
## Turning this upgrade on disables all of these.
@export var EXCLUDE_UPGRADES: Array[Upgrade] = []
## Turning this upgrade on enables all of these.
@export var INCLUDE_UPGRADES: Array[Upgrade] = []
## Turning this upgrade off disables all of these.
@export var DEPENDENT_UPGRADES: Array[Upgrade] = []
## Turning this upgrade off enables all of these.
@export var INVERSE_DEPENDENT_UPGRADES: Array[Upgrade] = []
@export_group("Buying")
## The max level. If 1, will hide level counter in tooltip.
@export var MAX_LEVEL : int = 1
## If true, the upgrade gets removed in-game
@export var HIDE : bool = false
## If true, upgrade will always be bought automatically and for free. Also hides the level counter in the tooltip.
@export var PRE_BOUGHT : bool = false
## What it costs to buy this upgrade.
@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "Materials") var Cost: Materials:
	get:
		return Cost
	set(value):
		Cost = value
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
	if HIDE && !Engine.is_editor_hint():
		MAX_LEVEL = 0
	Tooltip.hide()
	is_readied = true
	MainIcon.texture = SPRITE
	CurrentLevel = UpgradesManager.Load(INTERNAL_NAME, false)
	if CurrentLevel > MAX_LEVEL:
		MaterialsManager.Load()
		MaterialsManager.Mats.Metals += Cost.Metals * (CurrentLevel - MAX_LEVEL)
		MaterialsManager.Mats.Ceramics += Cost.Ceramics * (CurrentLevel - MAX_LEVEL)
		MaterialsManager.Mats.Synthetics += Cost.Synthetics * (CurrentLevel - MAX_LEVEL)
		MaterialsManager.Mats.Organics += Cost.Organics * (CurrentLevel - MAX_LEVEL)
		MaterialsManager.Mats.Components += Cost.Components * (CurrentLevel - MAX_LEVEL)
		CurrentLevel = MAX_LEVEL
		UpgradesManager.Save(INTERNAL_NAME, CurrentLevel)
		MaterialsManager.Save()
	if HIDE && !Engine.is_editor_hint():
		queue_free()
		return
	ReloadVisible()
	for requirement: Upgrade in REQUIRED_UPGRADES:
		requirement.connect("upgrade_successfully_bought", self.ReloadVisible)
	_updateTooltip()
	if PARENT_UPGRADE != null:
		PARENT_UPGRADE.notify_children.connect(ChildIsNotified)
	if PRE_BOUGHT:
		_try_buy()
	

func _updateTooltip():
	NameT.text = NAME
	DescT.text = DESCRIPTION
	if PRE_BOUGHT || MAX_LEVEL <= 1:
		LeveT.hide()
	else:
		LeveT.show()
		LeveT.text = String.num(CurrentLevel) + "/" + String.num(MAX_LEVEL)
	CostT.Display = Cost
	RequirementT.hide()
	if !REQUIRED_UPGRADES.is_empty():
		RequirementT.text = "Requires: "
		var i: int = 0
		RequirementT.label_settings.font_color = Color(1, 1, 1, 1)
		for requirement: Upgrade in REQUIRED_UPGRADES:
			if requirement.CurrentLevel < 1:
				RequirementT.show()
				RequirementT.label_settings.font_color = Color(1, 0.7, 0.7, 1)
			RequirementT.text += requirement.NAME
			if i < REQUIRED_UPGRADES.size() - 1:
				RequirementT.text += ", "
			i += 1

func ChildIsNotified(propogation : int):
	if CurrentLevel > 0 || PARENT_UPGRADE.CurrentLevel > 0:
		propogation = 0
	else:
		propogation += 1
	emit_signal("notify_children", propogation)
	if PRE_BOUGHT:
		_try_buy()
	ReloadVisible()
	if !Engine.is_editor_hint():
		hide()
	var b: int = LOOK_AHEAD + UpgradesManager.Load("LookAhead")
	if propogation < b:
		if HIDE_WITHOUT_PARENT:
			if PARENT_UPGRADE.CurrentLevel > 0:
				show()
		elif PARENT_UPGRADE.visible:
			show()

func ReloadVisible(_ignored: int = 0):
	if !is_readied:
		return
	ParentLine.hide()
	if UpgradesManager.LoadIsEnabled(INTERNAL_NAME):
		BoolIcon.texture = BoolOn
	else:
		BoolIcon.texture = BoolOff
	if CurrentLevel == MAX_LEVEL:
		CostT.hide()
		ToggleT.show()
	else:
		CostT.show()
		ToggleT.hide()
	if PARENT_UPGRADE:
		ParentLine.show()
		var dir : Vector2 = PARENT_UPGRADE.global_position - global_position
		ParentLine.points[1] = dir
		if PARENT_UPGRADE.CurrentLevel > 0:
			ParentLine.default_color = Color(1,1,1,1)
			ParentLine.self_modulate = Color(1,1,1,1)
		else:
			ParentLine.self_modulate = Color(0.5, 0.5, 0.5, 1)
	if !PARENT_UPGRADE || CurrentLevel > 0:
		emit_signal("notify_children", 0)
	MainIcon.modulate = Color(1, 1, 1, 1)
	BoolIcon.hide()
	AvailableIcon.hide()
	if _can_buy():
		AvailableIcon.show()
	elif CurrentLevel == 0:
		MainIcon.modulate = Color(0.5, 0.5, 0.5, 1)
	if CurrentLevel == MAX_LEVEL:
		BoolIcon.show()
		LevelBar.hide()
	else:
		LevelBar.show()
		_updateLevelBar()
	_updateTooltip()

func _updateLevelBar():
	if LevelBar.get_child_count() != MAX_LEVEL:
		for child: Node2D in LevelBar.get_children():
			child.queue_free()
		for i: int in MAX_LEVEL:
			var sprite2d = Sprite2D.new()
			LevelBar.add_child(sprite2d)
			sprite2d.position.x = (MAX_LEVEL - 1) * -1.5 + 3 * (i)
	for i: int in MAX_LEVEL:
		var b: Sprite2D = LevelBar.get_child(i)
		b.texture = LevelAccent if i < CurrentLevel else EmptyLevel

func _try_buy() -> void:
	if !_can_buy():
		return
	if !PRE_BOUGHT:
		MaterialsManager.Mats.Metals -= Cost.Metals
		MaterialsManager.Mats.Ceramics -= Cost.Ceramics
		MaterialsManager.Mats.Synthetics -= Cost.Synthetics
		MaterialsManager.Mats.Organics -= Cost.Organics
		MaterialsManager.Mats.Components -= Cost.Components
	if PRE_BOUGHT:
		CurrentLevel = MAX_LEVEL
	else:
		CurrentLevel += 1
	
	MaterialsManager.Save()
	SetEnabled(true)
	UpgradesManager.Save(INTERNAL_NAME, CurrentLevel)
	ReloadVisible()
	emit_signal("upgrade_successfully_bought", CurrentLevel)

func _can_buy() -> bool:
	if Engine.is_editor_hint():
		return false
	if PARENT_UPGRADE:
		if REQUIRE_MAX_PARENT && PARENT_UPGRADE.CurrentLevel < PARENT_UPGRADE.MAX_LEVEL:
			ParentLine.default_color = Color(1.0, 0.2, 0.3, 1.0)
			return false
		if PARENT_UPGRADE.CurrentLevel == 0:
			return false
		ParentLine.default_color = Color(1, 1, 1, 1)
	if !REQUIRED_UPGRADES.is_empty():
		for requirement: Upgrade in REQUIRED_UPGRADES:
			if requirement.CurrentLevel < 1:
				return false
	if !PRE_BOUGHT:
		MaterialsManager.Load()
		if MaterialsManager.Mats.Metals < Cost.Metals:
			return false
		if MaterialsManager.Mats.Ceramics < Cost.Ceramics:
			return false
		if MaterialsManager.Mats.Synthetics < Cost.Synthetics:
			return false
		if MaterialsManager.Mats.Organics < Cost.Organics:
			return false
		if MaterialsManager.Mats.Components < Cost.Components:
			return false
	return CurrentLevel < MAX_LEVEL

func _on_button_mouse_entered():
	Tooltip.show()

func _on_button_mouse_exited():
	Tooltip.hide()

func _on_button_pressed():
	if CurrentLevel < MAX_LEVEL:
		_try_buy()
	else:
		toggle()

func SetEnabled(enabled: bool, triggerIncludes: bool = true) -> void:
	if CurrentLevel != MAX_LEVEL:
		return
	UpgradesManager.Save(INTERNAL_NAME, MAX_LEVEL, enabled)
	ReloadVisible()
	# Turning this upgrade on disables all of these.
	#@export var EXCLUDE_UPGRADES: Array[Upgrade] = []
	# Turning this upgrade on enables all of these.
	#@export var INCLUDE_UPGRADES: Array[Upgrade] = []
	# Turning this upgrade off disables all of these.
	#@export var DEPENDENT_UPGRADES: Array[Upgrade] = []
	# Turning this upgrade off enables all of these.
	#@export var INVERSE_DEPENDENT_UPGRADES: Array[Upgrade] = []
	if enabled && triggerIncludes:
		for exclude: Upgrade in EXCLUDE_UPGRADES:
			exclude.SetEnabled(false, false)
		for include: Upgrade in INCLUDE_UPGRADES:
			include.SetEnabled(true, false)
	if !enabled && triggerIncludes:
		for dependent: Upgrade in DEPENDENT_UPGRADES:
			dependent.SetEnabled(false, false)
		for inverse_dependent: Upgrade in INVERSE_DEPENDENT_UPGRADES:
			inverse_dependent.SetEnabled(true, false)
	emit_signal("upgrade_successfully_bought", CurrentLevel if enabled else 0)

func toggle() -> void:
	if CurrentLevel != MAX_LEVEL:
		return
	var b: bool = UpgradesManager.LoadIsEnabled(INTERNAL_NAME)
	b = !b
	SetEnabled(b)
	#UpgradesManager.Save(INTERNAL_NAME, MAX_LEVEL, b)
	#ReloadVisible()
	#emit_signal("upgrade_successfully_bought", CurrentLevel if b else 0)

@warning_ignore("unused_parameter")
func _on_upgrade_successfully_bought(level):
	UpgradesManager.Save(INTERNAL_NAME, CurrentLevel, UpgradesManager.LoadIsEnabled(INTERNAL_NAME))
	emit_signal("notify_children", 0)

var _cPos: Vector2 = Vector2(0, 0)
var _c: bool = false

func _process(_delta):
	if Engine.is_editor_hint():
		return
	if Butt.button_pressed:
		if !_c:
			_cPos = get_global_mouse_position()
			_c = true
		if (_cPos - get_global_mouse_position()).length() > GRACE:
			Butt.disabled = true
	if !Input.is_action_pressed("left mouse button"):
		_c = false
		Butt.disabled = false
