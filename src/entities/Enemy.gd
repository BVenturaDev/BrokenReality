extends KinematicBody

export var speed = 8

var move_speed = speed
var rotation_angle = 45

onready var pathfollow = get_parent()
onready var sprite = $AnimatedSprite3D

func _ready() -> void:
	add_to_group("enemies")

func _process(delta: float) -> void:
	_patrol(delta)

func _patrol(delta) -> void:
	pathfollow.offset += move_speed * delta

func hitted() -> void:
	move_speed = 0
	yield(get_tree().create_timer(2), "timeout")
	move_speed = speed

