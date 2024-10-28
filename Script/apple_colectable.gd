extends Area2D

func _ready():
	fallFromTree()

func fallFromTree():
	$AnimationPlayer.play("fallingFromTree")
	await get_tree().create_timer(1.5).timeout
	$AnimationPlayer.play("fade")
	print("+1 apple")
	await get_tree().create_timer(0.3).timeout
	queue_free()
