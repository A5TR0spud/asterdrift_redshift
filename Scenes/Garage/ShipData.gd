@tool
extends Resource
class_name ShipData

#@export var name : String
@export var hull_color : Color = Color("363d52")
@export var hull_int : int = 0
@export var cockpit_color : Color = Color("01001f")
@export var cockpit_int : int = 0
#var cockpit_sheen : float
#var lhs_highlight : Color
#var rhs_highlight : Color
@export var accent_color : Color = Color("478cbf")
@export var accent_color_int : int = 4
@export var accent_type : AccentTypes = AccentTypes.STANDARD
@export var accent_type_int : int = 1
@export var blinker_on : Color = Color(1, 0, 0, 1)
@export var blinker_on_int : int = 0
@export var blinker_off : Color = Color(0, 0, 0, 1)
@export var blinker_off_int : int = 7
@export var blinker_interval : float = 1
@export var blinker_interp : bool = false
@export var inline : Color = Color("212532")
@export var inline_int : int = 1
@export var outline : Color = Color("338bff")
@export var outline_int : int = 0

enum AccentTypes {
	NONE,
	STANDARD,
	GREEBLE,
	HORNET,
}

func new():
	hull_color = Color("363d52")
	cockpit_color = Color("01001f")
	#cockpit_sheen = 0
	#lhs_highlight = Color("004f94")
	#rhs_highlight = Color("7e0094")
	accent_color = Color("478cbf")
	accent_type = AccentTypes.STANDARD
	blinker_on = Color(1, 0, 0, 1)
	blinker_off = Color(0, 0, 0, 1)
	blinker_interval = 1
	blinker_interp = false
	inline = Color("212532")
	outline = Color("338bff")
	
	hull_int = 0
	cockpit_int = 0
	accent_color_int = 4
	accent_type_int = 1
	blinker_on_int = 0
	blinker_off_int = 7
	inline_int = 1
	outline_int = 0
	
	return self

func copy(other : ShipData):
	self.hull_int = other.hull_int
	self.cockpit_int = other.cockpit_int
	self.accent_color_int = other.accent_color_int
	self.accent_type_int = other.accent_type_int
	self.blinker_on_int = other.blinker_on_int
	self.blinker_off_int = other.blinker_off_int
	self.blinker_interval = other.blinker_interval
	self.blinker_interp = other.blinker_interp
	self.inline_int = other.inline_int
	self.outline_int = other.outline_int
	
	self.hull_color = other.hull_color
	self.cockpit_color = other.cockpit_color
	self.accent_color = other.accent_color
	self.accent_type = other.accent_type
	self.blinker_on = other.blinker_on
	self.blinker_off = other.blinker_off
	self.inline = other.inline
	self.outline = other.outline
