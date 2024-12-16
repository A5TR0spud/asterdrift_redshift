extends Node
class_name RunHandler

static var Mats: Materials
static var _is_running : bool = false
static var TimeLeft : float = 30.0
static var TimeSpent: float = 0
static var BackupBattery: float = 15

static func IsInRun() -> bool:
	return _is_running

static func StartRun() -> void:
	if _is_running:
		return
	_is_running = true
	TimeSpent = 0.0
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
