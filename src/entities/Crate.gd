extends KinematicBody

var coin : PackedScene = preload("res://scenes/entities/Coin.tscn")

export var has_coin : bool = true


func _ready() -> void:
	add_to_group("crates")

func hitted() -> void:
	if has_coin:
		var new_coin = coin.instance()
		new_coin.global_transform = self.global_transform
		get_tree().current_scene.add_child(new_coin)
	queue_free()
