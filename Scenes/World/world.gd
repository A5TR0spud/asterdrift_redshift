extends Node2D

var MaxTime : float = 30.0
var PowerDrain : float = 1.0

@onready var TimeBar = $CanvasLayer/Control/EnergyMeter
@onready var TimeLabel = $CanvasLayer/Control/EnergyMeter/EnergyLabel
@onready var EndScreen = $CanvasLayer/Control/EndRunScreenControl
@onready var Player = $Player
@onready var KillButton = $CanvasLayer/Control/EndRunButton
@onready var StatPanel = $CanvasLayer/Control/EndRunScreenControl/VBoxContainer/StatsPanel
@onready var BackupShieldBar = $CanvasLayer/Control/EnergyMeter/BackupBattery
@onready var SolarStatus = $CanvasLayer/Control/EnergyMeter/EnergyStatuses/Solar
@onready var SolarIndicator = $CanvasLayer/Control/EnergyMeter/Solar
@onready var ChargeStatus = $CanvasLayer/Control/EnergyMeter/EnergyStatuses/Charger
@onready var ChargeIndicator = $CanvasLayer/Control/EnergyMeter/Charger
@onready var DecorationSpawner = $DecorationSpawner
@onready var CollectableScene := preload("res://Scenes/World/Decoration/collectable.tscn")
@onready var ResourceMonitor := $CanvasLayer/Control/Resources/Inventory/Run/ResourceCounter
@onready var ResourceInventory := $CanvasLayer/Control/Resources/Inventory
@onready var HangarInventory := $CanvasLayer/Control/Resources/Inventory/Hangar/ResourceCounter
@onready var BaySynthBar := $CanvasLayer/Control/Resources/Inventory/Run/Caps/SynthCap
@onready var BayMetalBar := $CanvasLayer/Control/Resources/Inventory/Run/Caps/MetalCap
@onready var BayOrganBar := $CanvasLayer/Control/Resources/Inventory/Run/Caps/OrganCap
@onready var BayCeramBar := $CanvasLayer/Control/Resources/Inventory/Run/Caps/CeramCap
@onready var StationInventory := $CanvasLayer/Control/Resources/Inventory/Station
@onready var StationInventoryCounter := $CanvasLayer/Control/Resources/Inventory/Station/ResourceCounter

var FarmedOrganics: int = 0
var RTGEnergy: int = 0
var _oldPos: Vector2 = Vector2(0, 0)

func _ready():
	RunHandler.StartRun()
	EndScreen.hide()
	MaxTime = _getStartingEnergy()
	RunHandler.TimeLeft = MaxTime
	TimeBar.max_value = MaxTime
	TimeBar.size.x = MaxTime * 8
	FarmedOrganics = 0
	RTGEnergy = 0
	_updateDisplay()
	_oldPos = Player.global_position
	ResourceInventory.visible = UpgradesManager.Load("ResourceMonitor") > 0
	StationInventory.visible =_isStationInventoryVisible()
	HangarInventory.Display = MaterialsManager.Mats
	var coef: int = UpgradesManager.Load("SplitBay") * 3 + 1
	BaySynthBar.max_value = RunHandler.GetMaxBayResourceCount() * coef
	BayMetalBar.max_value = RunHandler.GetMaxBayResourceCount() * coef
	BayOrganBar.max_value = RunHandler.GetMaxBayResourceCount() * coef
	BayCeramBar.max_value = RunHandler.GetMaxBayResourceCount() * coef

func _isStationInventoryVisible() -> bool:
	if !UpgradesManager.LoadIsEnabled("Borealis"):
		return false
	var b: bool = true
	b = b && UpgradesManager.LoadIsEnabled("MassDriver")
	return b

func _getStartingEnergy() -> float:
	var s: float = 30
	s += UpgradesManager.Load("ShipBattery")
	return s

func _getMaxEnergy() -> float:
	var s: float = _getStartingEnergy()
	s += 30.0 * UpgradesManager.Load("Overcharge")
	return s

func _getPowerDrainRampTime() -> float:
	var s: float = _getStartingEnergy()
	s += UpgradesManager.Load("Calibration") * 15.0
	s += UpgradesManager.Load("SolarPanel") * 3.0
	s += UpgradesManager.Load("RTG")
	return s

var _shouldReverseCharge: bool = false
func _physics_process(delta):
	PowerDrain = 1.0
	
	RunHandler.DistanceTravelled += _oldPos.distance_to(Player.global_position)
	_oldPos = Player.global_position
	
	if UpgradesManager.Load("Idling") > 0:
		var idleDrain: float = 0.625
		
		var d: float = (Player.linear_velocity.length() / Player.GetCurrentMaxSpeed())
		d = maxf(d - 0.5, 0.0)
		d *= 2.0
		d *= d
		PowerDrain *= d + (1.0 - d) * idleDrain
	
	if UpgradesManager.Load("Overclocking") > 0:
		var overclockDrain: float = 0.75
		
		var d: float = 1.0 - (Player.linear_velocity.length() / Player.GetCurrentMaxSpeed())
		d = maxf(d - 0.2, 0.0)
		d *= 1.25
		d *= d
		PowerDrain *= d + (1.0 - d) * overclockDrain
	
	if UpgradesManager.Load("RTG") > 0 && RTGEnergy < RunHandler.TimeSpent / 8.0 - 1:
		RTGEnergy += 1
		RunHandler.TimeLeft += 1
		NotificationsManager.SendTransformNotification(Materials.Mats.Clock, Materials.Mats.Energy, [Notification.Sources.RTG])
	
	if UpgradesManager.Load("Farm") > 0 && FarmedOrganics < RunHandler.TimeSpent / 7.0 - 1:
		FarmedOrganics += 1
		var instance : Collectable = CollectableScene.instantiate()
		instance.COLLECTION = Materials.Mats.Organics
		var pos : Vector2 = Vector2(0, 64).rotated(randf_range(0, deg_to_rad(360)))
		instance.global_position = Player.global_position + pos
		DecorationSpawner.add_child(instance)
		if UpgradesManager.Load("Demeter") < 1:
			RunHandler.TimeLeft -= 0.25
			NotificationsManager.SendTransformNotification(Materials.Mats.Energy, Materials.Mats.Organics, [Notification.Sources.HYDROPONIC])
		else:
			NotificationsManager.SendTransformNotification(Materials.Mats.Clock, Materials.Mats.Organics, [Notification.Sources.DEMETER, Notification.Sources.HYDROPONIC])
	
	if RunHandler.TimeLeft > MaxTime * 0.7 && UpgradesManager.Load("SolarPanel") > 0:
		PowerDrain *= 0.7
		if UpgradesManager.Load("ReverseCharger") > 0:
			RunHandler.ChargeBackup(delta)
		SolarStatus.show()
		SolarIndicator.show()
	else:
		SolarStatus.hide()
		SolarIndicator.hide()
	ChargeIndicator.visible = RunHandler.BackupBattery > 0 && !_shouldReverseCharge && UpgradesManager.Load("ReverseCharger") > 0
	if RunHandler.BackupBattery > 0 && RunHandler.TimeLeft <= 5 && UpgradesManager.Load("ReverseCharger") > 0:
		_shouldReverseCharge = true
	if RunHandler.TimeLeft >= MaxTime:
		_shouldReverseCharge = false
	if _shouldReverseCharge && RunHandler.BackupBattery > 0:
		ChargeStatus.show()
		var _batteryToLose: float = 0
		var _timeToAdd: float = 0
		#its only +2 per second, because of the ratio and then -1 from time
		_batteryToLose = delta * 2.0 * 3.0
		if _batteryToLose > RunHandler.BackupBattery:
			_batteryToLose = RunHandler.BackupBattery
			_shouldReverseCharge = false
		#ratio
		_timeToAdd = 0.5 * _batteryToLose
		RunHandler.BackupBattery -= _batteryToLose
		RunHandler.TimeLeft += _timeToAdd
	else:
		_shouldReverseCharge = false
	if !_shouldReverseCharge:
		ChargeStatus.hide()
	if RunHandler.IsInRun():
		if RunHandler.TimeLeft > _getMaxEnergy():
			RunHandler.TimeLeft = _getMaxEnergy()
		if RunHandler.TimeSpent > _getPowerDrainRampTime():
			PowerDrain += 0.1 * (RunHandler.TimeSpent - _getPowerDrainRampTime())
		RunHandler.TimeLeft -= delta * PowerDrain
		RunHandler.TimeSpent += delta
	else:
		StopRun()
		return
	if RunHandler.TimeLeft <= 0:
		RunHandler.TimeLeft = 0
		StopRun()
	_updateDisplay()
	
func _updateDisplay():
	TimeBar.value = RunHandler.TimeLeft
	var toDisplay : String = String.num(RunHandler.TimeLeft, 1)
	if !toDisplay.contains("."):
		toDisplay += ".0"
	TimeLabel.text = toDisplay
	
	if UpgradesManager.Load("ResourceMonitor") > 0:
		ResourceMonitor.Display = RunHandler.BayMats
	BayCeramBar.value = RunHandler.BayMats.Ceramics
	BayOrganBar.value = RunHandler.BayMats.Organics + BayCeramBar.value
	BayMetalBar.value = RunHandler.BayMats.Metals + BayOrganBar.value
	BaySynthBar.value = RunHandler.BayMats.Synthetics + BayMetalBar.value
	
	if _isStationInventoryVisible():
		StationInventoryCounter.Display = RunHandler.StationMats

func _on_end_run_button_pressed():
	StopRun()

func StopRun():
	Player.CAN_MOVE = false
	EndScreen.show()
	KillButton.hide()
	StatPanel.run()
	RunHandler.EndRun()

func _on_new_run_pressed():
	MaterialsManager.Save()
	get_tree().change_scene_to_file("res://Scenes/World/World.tscn")

func _on_return_to_hangar_pressed():
	MaterialsManager.Save()
	get_tree().change_scene_to_file("res://Scenes/Hangar/hangar.tscn")

@warning_ignore("unused_signal")
signal player_warp(amount: Vector2)

func _on_player_bounds_body_exited(body):
	if body is PlayerClass:
		for child: Node2D in DecorationSpawner.get_children():
			child.global_position = child.global_position - Player.global_position
		_oldPos -= Player.global_position
		emit_signal("player_warp", -Player.global_position)
		Player.global_position = Vector2.ZERO
		

func _on_world_bounds_body_exited(body):
	if body is Entity:
		if body.global_position.x > Player.global_position.x + 5000 - body.Radius * 2 - 10:
			body.global_position.x -= 10000 - 10
		elif body.global_position.x < Player.global_position.x + -5000 + body.Radius * 2 + 10:
			body.global_position.x += 10000 - 10
		
		if body.global_position.y > Player.global_position.y + 5000 - body.Radius * 2 - 10:
			body.global_position.y -= 10000 - 10
		elif body.global_position.y < Player.global_position.y + -5000 + body.Radius * 2 + 10:
			body.global_position.y += 10000 - 10
