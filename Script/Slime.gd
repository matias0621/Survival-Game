extends CharacterBody2D

var speed = 50

var health = 150

var dead = false
var player_in_area = false
var player = null

@onready var slime = $SlimeCollectable
@export var itemRes: InvItem

func _ready():
	dead = false

func _physics_process(delta):
	if !dead:
		$DetectionArea/CollisionShape2D.disabled = false
		if player_in_area:
			position += (player.position - position) / speed
			$AnimatedSprite2D.play("move")
		else:
			$AnimatedSprite2D.play("idle")
	if dead:
		$DetectionArea/CollisionShape2D.disabled = true
	


func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body


func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false




func _on_hitbox_area_entered(area):
	var damage
	if area.has_method("arrow_deal_damage"):
		damage = 50
		take_damage(damage)

func take_damage(damage):
	health -= damage
	if health <= 0 and !dead:
		death()

func death():
	dead = true
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(1).timeout
	drop_slime()
	
	$AnimatedSprite2D.visible = false
	$Hitbox/CollisionShape2D.disabled = true
	$DetectionArea/CollisionShape2D.disabled = true

func drop_slime():
	slime.visible = true
	$SlimeCollactableArea/CollisionShape2D.disabled = false
	slime_collect()

func slime_collect():
	await  get_tree().create_timer(1.5).timeout
	slime.visible = false
	player.collect(itemRes)
	queue_free()

func _on_slime_collactable_area_body_entered(body):
	if body.has_method("player"):
		player = body
