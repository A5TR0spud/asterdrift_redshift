extends Node
class_name RunHandler

static var BayMats: Materials
static var StationMats: Materials
static var QueuedMassDriverPackages: Materials
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
	return BayMats.Synthetics + BayMats.Ceramics + BayMats.Metals + BayMats.Organics

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
		return BayMats.Get(mat) < GetMaxBayResourceCount()
	return GetBayResourceCount() < GetMaxBayResourceCount()

static func AddResource(mat: Materials.Mats, amount: int = 1) -> bool:
	if mat == Materials.Mats.Components:
		BayMats.Components += amount
		return true
	
	if !CanCollect(mat):
		return false
	
	var massDriver: bool = UpgradesManager.LoadIsEnabled("MassDriver") && UpgradesManager.LoadIsEnabled("Borealis")
	
	BayMats.Add(mat)
	if massDriver && BayMats.Get(mat) >= GetMaxBayResourceCount():
		StationMats.Add(mat, BayMats.Get(mat))
		BayMats.Set(mat)
		QueuedMassDriverPackages.Add(mat)

	amount -= 1
	if amount > 0:
		AddResource(mat, amount)
	return true

static func GetTotalResources() -> Materials:
	var ma: Materials = Materials.new()
	ma.SetTo(BayMats)
	ma.AddBy(StationMats)
	return ma

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
	if BayMats == null:
		BayMats = Materials.new()
	BayMats.SetAll()
	if StationMats == null:
		StationMats = Materials.new()
	StationMats.SetAll()
	if QueuedMassDriverPackages == null:
		QueuedMassDriverPackages = Materials.new()
	QueuedMassDriverPackages.SetAll()
	UpcyclerCount = DataManager.Load("UpcyclerCount", 0)

static func EndRun() -> void:
	if !_is_running:
		return
	if UpgradesManager.Load("CoreAssembler") > 0:
		var x = DataManager.Load("coreAssemblyTimeLeft", 300)
		DataManager.Save("coreAssemblyTimeLeft", x - TimeSpent)
	_is_running = false
	MaterialsManager.Mats.AddBy(GetTotalResources())
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
