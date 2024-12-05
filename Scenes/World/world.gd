extends Node2D

var MaxTime : float = 30.0
var TimeLeft : float = 30.0
var IsInRun : bool = true
var PowerDrain : float = 1.0

@onready var TimeBar = $CanvasLayer/Control/EnergyMeter
@onready var TimeLabel = $CanvasLayer/Control/EnergyMeter/EnergyLabel
@onready var Progressor = $CanvasLayer/Control/EnergyMeter/EnergyLabel/ClipMask/ProgressBar
@onready var EndScreen = $CanvasLayer/Control/EndRunScreenControl
@onready var Player = $Player
@onready var KillButton = $CanvasLayer/Control/EndRunButton
@onready var StatPanel = $CanvasLayer/Control/EndRunScreenControl/VBoxContainer/StatsPanel

func _ready():
	RunHandler.StartRun()
	EndScreen.hide()
	TimeLeft = MaxTime
	TimeBar.max_value = MaxTime
	TimeBar.size.x = MaxTime * 16
	_updateDisplay()
	IsInRun = true

func _physics_process(delta):
	if IsInRun:
		TimeLeft -= delta * PowerDrain
	if TimeLeft <= 0:
		TimeLeft = 0
		StopRun()
	_updateDisplay()
	
func _updateDisplay():
	TimeBar.value = TimeLeft
	var toDisplay : String = String.num(TimeLeft, 1)
	if !toDisplay.contains("."):
		toDisplay += ".0"
	TimeLabel.text = toDisplay

func _on_end_run_button_pressed():
	StopRun()

func StopRun():
	Player.CAN_MOVE = false
	EndScreen.show()
	Progressor.hide()
	IsInRun = false
	KillButton.hide()
	StatPanel.run()
	RunHandler.EndRun()

func _on_new_run_pressed():
	get_tree().change_scene_to_file("res://Scenes/World/World.tscn")

func _on_return_to_hangar_pressed():
	get_tree().change_scene_to_file("res://Scenes/Hangar/hangar.tscn")
