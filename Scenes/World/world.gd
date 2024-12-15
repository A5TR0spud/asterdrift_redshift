extends Node2D

var MaxTime : float = 30.0
var PowerDrain : float = 1.0

@onready var TimeBar = $CanvasLayer/Control/EnergyMeter
@onready var TimeLabel = $CanvasLayer/Control/EnergyMeter/EnergyLabel
@onready var Progressor = $CanvasLayer/Control/EnergyMeter/EnergyLabel/ClipMask/ProgressBar
@onready var EndScreen = $CanvasLayer/Control/EndRunScreenControl
@onready var Player = $Player
@onready var KillButton = $CanvasLayer/Control/EndRunButton
@onready var StatPanel = $CanvasLayer/Control/EndRunScreenControl/VBoxContainer/StatsPanel
@onready var BackupShieldBar = $CanvasLayer/Control/EnergyMeter/BackupBattery
@onready var SolarStatus = $CanvasLayer/Control/EnergyMeter/EnergyStatuses/Solar
@onready var SolarIndicator = $CanvasLayer/Control/EnergyMeter/Solar
@onready var ChargeStatus = $CanvasLayer/Control/EnergyMeter/EnergyStatuses/Charger
@onready var ChargeIndicator = $CanvasLayer/Control/EnergyMeter/Charger

func _ready():
	RunHandler.StartRun()
	EndScreen.hide()
	MaxTime += UpgradesManager.Load("ShipBattery")
	RunHandler.TimeLeft = MaxTime
	TimeBar.max_value = MaxTime
	TimeBar.size.x = MaxTime * 16
	_updateDisplay()

var _shouldReverseCharge: bool = false
func _physics_process(delta):
	if RunHandler.TimeLeft > MaxTime * 0.7 && UpgradesManager.Load("SolarPanel") > 0:
		PowerDrain = 0.7
		if UpgradesManager.Load("ReverseCharger") > 0:
			RunHandler.ChargeBackup(delta)
		SolarStatus.show()
		SolarIndicator.show()
	else:
		PowerDrain = 1.0
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

func _on_end_run_button_pressed():
	StopRun()

func StopRun():
	Player.CAN_MOVE = false
	EndScreen.show()
	Progressor.hide()
	KillButton.hide()
	StatPanel.run()
	RunHandler.EndRun()

func _on_new_run_pressed():
	MaterialsManager.Save()
	get_tree().change_scene_to_file("res://Scenes/World/World.tscn")

func _on_return_to_hangar_pressed():
	MaterialsManager.Save()
	get_tree().change_scene_to_file("res://Scenes/Hangar/hangar.tscn")
