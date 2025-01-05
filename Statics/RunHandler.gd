extends Node
class_name RunHandler

static var Mats: Materials
static var _is_running : bool = false
static var TimeLeft : float = 30.0
static var TimeSpent: float = 0
static var BackupBattery: float = 15:
	get:
		return BackupBattery
	set(value):
		if IsInRun():
			BackupBattery = value
static var DistanceTravelled: float = 0.0:
	get:
		return DistanceTravelled
	set(value):
		if IsInRun():
			DistanceTravelled = value
static var UpcyclerCount: int = 0

static func IsInRun() -> bool:
	return _is_running

static func GetBayResourceCount() -> int:
	return Mats.Synthetics + Mats.Ceramics + Mats.Metals + Mats.Organics

static func GetMaxBayResourceCount() -> int:
	var r: int = 10
	r += UpgradesManager.Load("BiggerBay") * 20
	r += UpgradesManager.Load("BERTHA") * 30
	if UpgradesManager.LoadIsEnabled("SplitBay"):
		@warning_ignore("integer_division")
		r = maxi(r / 2, 5)
	return r

static func CanCollect(mat: Materials.Mats) -> bool:
	if mat == Materials.Mats.Components:
		return true
	if UpgradesManager.Load("SplitBay") > 0:
		if mat == Materials.Mats.Metals:
			return Mats.Metals < GetMaxBayResourceCount()
		if mat == Materials.Mats.Ceramics:
			return Mats.Ceramics < GetMaxBayResourceCount()
		if mat == Materials.Mats.Synthetics:
			return Mats.Synthetics < GetMaxBayResourceCount()
		if mat == Materials.Mats.Organics:
			return Mats.Organics < GetMaxBayResourceCount()
		return true
	return GetBayResourceCount() < GetMaxBayResourceCount()

static func AddResource(mat: Materials.Mats, amount: int = 1) -> bool:
	if mat == Materials.Mats.Components:
		Mats.Components += amount
		return true
	
	if !CanCollect(mat):
		return false
	
	if mat == Materials.Mats.Metals:
		Mats.Metals += 1
	elif mat == Materials.Mats.Ceramics:
		Mats.Ceramics += 1
	elif mat == Materials.Mats.Synthetics:
		Mats.Synthetics += 1
	elif mat == Materials.Mats.Organics:
		Mats.Organics += 1
	amount -= 1
	if amount > 0:
		AddResource(mat, amount)
	return true

static func StartRun() -> void:
	if _is_running:
		return
	_is_running = true
	TimeSpent = 0.0
	DistanceTravelled = 0.0
	if UpgradesManager.Load("BackupShield"):
		BackupBattery = 15
	else:
		BackupBattery = 0
	if Mats == null:
		Mats = Materials.new()
	Mats.Metals = 0
	Mats.Ceramics = 0
	Mats.Synthetics = 0
	Mats.Organics = 0
	Mats.Components = 0
	UpcyclerCount = DataManager.Load("UpcyclerCount", 0)

static func EndRun() -> void:
	if !_is_running:
		return
	if UpgradesManager.Load("CoreAssembler") > 0:
		var x = DataManager.Load("coreAssemblyTimeLeft", 300)
		DataManager.Save("coreAssemblyTimeLeft", x - TimeSpent)
	_is_running = false
	MaterialsManager.Mats.Metals += Mats.Metals
	MaterialsManager.Mats.Ceramics += Mats.Ceramics
	MaterialsManager.Mats.Synthetics += Mats.Synthetics
	MaterialsManager.Mats.Organics += Mats.Organics
	MaterialsManager.Mats.Components += Mats.Components
	MaterialsManager.Save()
	DataManager.Save("UpcyclerCount", UpcyclerCount)

static func DamageBackup(damage: float) -> void:
	var fuseLevel: int = UpgradesManager.Load("Fuse")
	var shield: int = UpgradesManager.Load("EnergyShield")
	if fuseLevel > 0 && shield > 0:
		damage = minf(damage, 6 - fuseLevel)
	if UpgradesManager.Load("BackupShield") > 0:
		BackupBattery -= damage
		if BackupBattery < 0:
			TimeLeft += BackupBattery
			BackupBattery = 0
	else:
		TimeLeft -= damage

static func ChargeBackup(amount: float) -> void:
	if UpgradesManager.Load("BackupShield") < 1:
		BackupBattery = 0
		return
	BackupBattery += amount
	if BackupBattery > 20:
			BackupBattery = 20
