extends Entity
class_name PirateEntity

## What team the pirate is on. Pirates of different factions are likely to engage in combat.
@export var Faction: int = 0
## Pirate will keep track of everything in this area.
@export var TrackingArea: Area2D
## Pirate will keep track of other pirates in this area. Pirate will attempt to stay near friendlies.
@export var FactionArea: Area2D
## How likely it is for the pirate to fight enemies. 
@export_range(0.0, 1.0) var Aggression: float = 0.8
## How likely it is for the pirate to flee from enemies, if it chooses not to fight.
@export_range(0.0, 1.0) var Fear: float = 1.0
## Pirate will follow allies or targetted enemies from this radius.
@export var FollowRange: int = 128

var _Tracked: Array[Entity] = []
var _TrackedFactions: Array[Entity] = []
var _LastKnownTrackedPos: Vector2 = Vector2.ZERO
var _LastKnownTrackedVel: Vector2 = Vector2.ZERO
var TrackedOrbiters: Array[Entity] = []
var TrackedFear: Array[Entity] = []
var faction_dir: Vector2 = Vector2.ZERO

func _ready():
	_Tracked = []
	TrackingArea.connect("body_entered", _trackerEnter)
	TrackingArea.connect("body_exited", _trackerExit)
	FactionArea.connect("body_entered", _factionEnter)
	FactionArea.connect("body_exited", _factionExit)
	for col in TrackingArea.get_overlapping_bodies():
		_trackerEnter(col)
	for col in FactionArea.get_overlapping_bodies():
		_factionEnter(col)
	Ready()

func Ready() -> void:
	pass

func PhysicsProcess(delta: float) -> void:
	pass

func _physics_process(delta):
	_reload_faction_dir()
	PhysicsProcess(delta)

func GetTrackedFactions() -> Array[Entity]:
	return _TrackedFactions

func GetTrackedEntities() -> Array[Entity]:
	return _Tracked

func TestEntityForEnemy(ent: Entity) -> bool:
	if ent is PirateEntity:
		return ent.Faction != Faction
	return ent.isPlayer

func TestEntityForAlly(ent: Entity) -> bool:
	if ent is PirateEntity:
		return ent.Faction == Faction
	return false

func TestAggression(ent: Entity = null) -> bool:
	if ent != null:
		return TestEntityForEnemy(ent) && TestAggression()
	return randf() > Fear

func TestFear(ent: Entity = null) -> bool:
	if ent != null:
		return TestEntityForEnemy(ent) && TestFear()
	return randf() < Fear

func _trackerEnter(body: Node2D) -> void:
	if body is Entity:
		_Tracked.append(body)

func _trackerExit(body: Node2D) -> void:
	if _Tracked.has(body):
		_Tracked.erase(body)

func _factionEnter(body: Node2D) -> void:
	if body is PirateEntity or (body is Entity and body.isPlayer):
		_TrackedFactions.append(body)
		_reload_tracked_targets()

func _factionExit(body: Node2D) -> void:
	if _TrackedFactions.has(body):
		_TrackedFactions.erase(body)
		_reload_tracked_targets()

func _reload_tracked_targets():
	TrackedFear = []
	TrackedOrbiters = []
	for ent in GetTrackedFactions():
		var dir = ent.global_position - global_position
		if TestEntityForAlly(ent) || TestAggression(ent):
			TrackedOrbiters.append(ent)
		elif TestFear(ent):
			TrackedFear.append(ent)

func _reload_faction_dir():
	faction_dir = Vector2.ZERO
	for ent in TrackedOrbiters:
		var dir = ent.global_position - global_position
		faction_dir += ent.linear_velocity.normalized()
		faction_dir += ((dir) - dir.normalized() * FollowRange).normalized() * 4.0
	for ent in TrackedFear:
		var dir = ent.global_position - global_position
		faction_dir -= dir.normalized() * 5.0
	faction_dir = faction_dir.normalized()
