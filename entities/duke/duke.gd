extends Sprite2D


## Dialogue for NPC to display
@export_multiline var dialogue: String

@onready var popup_panel = $Control/PopupPanel
@onready var popup_label = $Control/PopupPanel/DialogueLabel
@onready var char_timer := Timer.new()

const CHAR_LIMIT = 100
var interactable := false
var chunks = [""]
var chunk_ind = 0
var char_speed = 40
var char_ind = 0
var talking = false


func _ready() -> void:
	char_timer.timeout.connect(_on_char_timer_timeout)
	char_timer.wait_time = 1.0 / char_speed
	add_child(char_timer)
	popup_panel.position = global_position + Vector2(30, -20)
	var sentences = dialogue.split(".").slice(0, -1)
	for i in sentences:
		i += "."
		var j = chunks[-1]
		if i.length() + j.length() >= CHAR_LIMIT:
			chunks.append(i)
		else:
			chunks[-1] += i
	popup_label.text = ""

func _input(event: InputEvent) -> void:
	if interactable and event.is_action_pressed("interact"):
		popup_panel.show()
		speech()

func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body.is_in_group(GameManager.PLAYER_GROUP)  and body.collision_layer == 1:
		GameManager.vision_bool = false
		var bg_nodes = get_tree().get_nodes_in_group(VisionManager.BG_GROUP_NAME)
		for node in bg_nodes:
			if node is CanvasItem:
				var vision = node.material
				if vision is ShaderMaterial:
					if vision.get_shader_parameter("radius") < 100:
						vision.set_shader_parameter("radius", 100)
						vision.set_shader_parameter("player_pos", self.global_position)
		interactable = true

func _on_interactable_area_body_exited(body: Node2D) -> void:
	if body.is_in_group(GameManager.PLAYER_GROUP) and body.collision_layer == 1:
		char_timer.stop()
		interactable = false
		popup_panel.hide()
		GameManager.vision_bool = true
		char_ind = 0
		chunk_ind = 0
		talking = false
		#print("Player left interactable area")

func _on_char_timer_timeout() -> void:
	if char_ind >= chunks[chunk_ind].length():
		char_timer.stop()
		chunk_ind += 1
		char_ind = 0
		talking = false
	else:
		#print("chunk ", chunk_ind, " char ", char_ind)
		popup_label.text +=  chunks[chunk_ind][char_ind]
		char_ind += 1
		char_timer.start()

func speech():
	if talking:
		char_timer.stop()
		popup_label.text += chunks[chunk_ind].substr(char_ind)
		char_ind = 0
		chunk_ind += 1
		talking = false
	else:
		if char_ind == 0:
			popup_label.text = ""
		if chunk_ind == chunks.size():
			popup_panel.hide()
			chunk_ind = 0
		else:
			talking = true
			char_timer.start()
