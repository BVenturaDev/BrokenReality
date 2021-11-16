extends StaticBody

signal entered

var rotation_angle = 45
var has_player := false

onready var player = get_parent().get_node("Player")
onready var sprite = $Sprite3D
onready var hitbox = $HitBox


func _ready() -> void:
	add_to_group("mirrors")

func _process(delta: float) -> void:
	if has_player == false:
		if player in hitbox.get_overlapping_bodies():
			emit_signal("entered")
			has_player = true
			yield(get_tree().create_timer(5), "timeout")
			has_player = false

