extends KinematicBody

var coin : PackedScene = preload("res://scenes/entities/Coin.tscn")

func hitted() -> void:
	var new_coin = coin.instance()
	new_coin.global_transform = self.global_transform
	get_tree().current_scene.add_child(new_coin)
	queue_free()
