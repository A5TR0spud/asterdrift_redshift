extends VBoxContainer
class_name NotificationsManager

static var TransformPrefab := preload("res://Scenes/Utilities/Notifications/transform_notification.tscn")
static var PickupPrefab := preload("res://Scenes/Utilities/Notifications/pickup_notification.tscn")

static var Instance: NotificationsManager
static var Enabled: bool = false

func _ready():
	Instance = self
	if UpgradesManager.Load("ResourceChangelog") < 1:
		hide()
		Enabled = false
	else:
		show()
		Enabled = true

static func SendTransformNotification(original: Materials.Mats, result: Materials.Mats, source: Array[Notification.Sources] = []) -> void:
	if !Enabled:
		return
	
	var notif: TransformNotification = TransformPrefab.instantiate()
	notif.Victim = original
	notif.Result = result
	notif.Source = source
	Instance.add_child(notif)

static func SendPickupNotification(result: Materials.Mats, source: Array[Notification.Sources] = []) -> void:
	if !Enabled:
		return
	
	var notif: PickupNotification = PickupPrefab.instantiate()
	notif.Result = result
	notif.Source = source
	if !source.is_empty():
		notif.Duration = 3
	Instance.add_child(notif)
