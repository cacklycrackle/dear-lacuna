extends Sprite2D

## Dialogue for NPC to display
@export_multiline var dialogue: String
## Max duration that dialogue will be visible for if player remains on NPC
@export var duration := 10.0

@onready var popup_panel = $Control/PopupPanel
@onready var popup_label = $Control/PopupPanel/ScrollContainer/DialogueLabel
@onready var popup_timer := Timer.new()

var interactable := false


func _ready() -> void:
	add_child(popup_timer)
	popup_timer.one_shot = true
	popup_timer.timeout.connect(_on_popup_timer_timeout)
	popup_panel.position = global_position + Vector2(30, -20)

func _input(event: InputEvent) -> void:
	if interactable and event.is_action_pressed("interact"):
		popup_label.text = dialogue
		popup_panel.show()
		popup_timer.start(duration)

func _hide_popup() -> void:
	popup_panel.hide()
	popup_timer.stop()

func _on_popup_timer_timeout() -> void:
	_hide_popup()
	#print("Popup hidden by timer")

func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body.is_in_group(GameManager.PLAYER_GROUP) and body.collision_layer == 1:
		interactable = true
		#print("Player enter interactable area")

func _on_interactable_area_body_exited(body: Node2D) -> void:
	if body.is_in_group(GameManager.PLAYER_GROUP) and body.collision_layer == 1:
		interactable = false
		_hide_popup()
		#print("Player left interactable area")
