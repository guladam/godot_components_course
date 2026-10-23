extends CanvasLayer

var level := 1
var xp_per_level := 50

@onready var stat_container: StatContainer = %StatContainer
@onready var health: StatPool = %Health
@onready var mana: StatPool = %Mana
@onready var xp: StatPool = %Xp

@onready var loaded: Button = %Loaded
@onready var health_progress: ProgressBar = %HealthProgress
@onready var health_progress_2: ProgressBar = %HealthProgress2
@onready var health_label: Label = %HealthLabel
@onready var mana_progress: ProgressBar = %ManaProgress
@onready var mana_label: Label = %ManaLabel
@onready var xp_progress: ProgressBar = %XPProgress
@onready var xp_label: Label = %XPLabel
@onready var strength_label: Label = %StrengthLabel
@onready var agility_label: Label = %AgilityLabel
@onready var intelligence_label: Label = %IntelligenceLabel

@onready var dmg_button: Button = %DmgButton
@onready var heal_button: Button = %HealButton
@onready var mana_button: Button = %ManaButton
@onready var refill_mana_button: Button = %RefillManaButton
@onready var xp_button: Button = %XPButton
@onready var str_button: Button = %StrButton
@onready var potion_button: Button = %PotionButton
@onready var belt_button: Button = %BeltButton

func _ready() -> void:
	loaded.text = "Loaded: %s" % stat_container.sheet.resource_path.get_file()
	
	health.changed.connect(_on_health_changed)
	mana.changed.connect(_on_mana_changed)
	xp.changed.connect(_on_xp_changed)
	stat_container.get_stat(&"str").changed.connect(_on_str_changed)
	stat_container.get_stat(&"agi").changed.connect(_on_agi_changed)
	stat_container.get_stat(&"int").changed.connect(_on_int_changed)
	
	_on_health_changed(0, health.current)
	_on_mana_changed(0, mana.current)
	_on_xp_changed(0, xp.current)
	_on_str_changed(0, stat_container.get_stat(&"str").get_value())
	_on_agi_changed(0, stat_container.get_stat(&"agi").get_value())
	_on_int_changed(0, stat_container.get_stat(&"int").get_value())
	
	dmg_button.pressed.connect(func(): health.change(-4))
	heal_button.pressed.connect(func(): health.change(5))
	mana_button.pressed.connect(func(): mana.change(-10))
	refill_mana_button.pressed.connect(func(): mana.change(mana.get_max()))
	xp_button.pressed.connect(func(): 
		xp.change(25)
		while xp.current >= xp_per_level * level:
			level += 1
			xp.change(-1 * xp_per_level * (level - 1))
	)
	str_button.pressed.connect(func():
		var potion_mod := StatModifier.flat(&"str_potion_2", 2)
		stat_container.get_stat(&"str").add_modifier(potion_mod)
	)
	potion_button.pressed.connect(_on_berzerk_potion_pressed)
	belt_button.pressed.connect(func():
		var belt_int_mod := StatModifier.flat(&"belt_of_wisdom", 25, false)
		var belt_str_mod := StatModifier.flat(&"belt_of_wisdom", -999, false)
		stat_container.get_stat(&"int").add_modifier(belt_int_mod)
		stat_container.get_stat(&"str").add_modifier(belt_str_mod)
	)


func _on_berzerk_potion_pressed() -> void:
	var timer: SceneTreeTimer = get_tree().create_timer(5, false)
	var berzerk_hp_mod := StatModifier.flat(&"berzerk_potion", 100)
	var berzerk_mp_mod := StatModifier.override(&"berzerk_potion", 0)
	stat_container.get_stat(&"hp").add_modifier(berzerk_hp_mod)
	stat_container.get_stat(&"mp").add_modifier(berzerk_mp_mod)
	timer.timeout.connect(func():
		stat_container.get_stat(&"hp").remove_modifiers_from(&"berzerk_potion")
		stat_container.get_stat(&"mp").remove_modifiers_from(&"berzerk_potion")
	, CONNECT_ONE_SHOT)


func _on_health_changed(_old: float, new: float) -> void:
	health_progress.value = new / health.get_max()
	health_progress_2.value = new / health.get_max()
	health_label.text = "%d / %d" % [new, health.get_max()]


func _on_mana_changed(_old: float, new: float) -> void:
	mana_progress.value = new / mana.get_max()
	mana_label.text = "%d / %d" % [new, mana.get_max()]


func _on_xp_changed(_old: float, new: float) -> void:
	xp_progress.value = new / (xp_per_level * level)
	xp_label.text = "%d / %d" % [new, xp_per_level * level]


func _on_str_changed(_old: float, new: float) -> void:
	strength_label.text = str(int(new))


func _on_agi_changed(_old: float, new: float) -> void:
	agility_label.text = str(int(new))


func _on_int_changed(_old: float, new: float) -> void:
	intelligence_label.text = str(int(new))
