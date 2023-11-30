extends Node2D


@export var lines: Array[String]
@export var one_shot: bool
@export var auto_advance_time: float = 1.0

@onready var trigger := $TriggerArea as TriggerArea


func _ready() -> void:
	trigger.trigger_keys.append(GameManager.player)
	trigger.one_shot = one_shot


func _on_trigger_area_triggered() -> void:
	var params := DialogManager.StartDialogParams.new()
	params.auto_advance_time = auto_advance_time
	
	DialogManager.start_dialog(GameManager.player.global_position, lines, params)
