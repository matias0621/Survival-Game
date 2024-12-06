extends CharacterBody2D

var speed = 100

var player_state
@onready var animated_sprite_2d = $AnimatedSprite2D
@export var inv: Inv

var bow_equiped = true
var bow_cooldown = true
var arrow = preload("res://Scene/arrow.tscn")
var mouse_loc_from_player = null

func _physics_process(delta):
	mouse_loc_from_player = get_global_mouse_position() - self.position
	
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 or direction.y != 0:
		player_state = "walking"
	
	velocity = direction * speed
	move_and_slide()
	
	if Input.is_action_just_pressed("actuar"):
		bow_equiped = !bow_equiped
	
	var mouse_pose = get_global_mouse_position()
	$Marker2D.look_at(mouse_pose)
	
	if Input.is_action_just_pressed("left_mouse") and bow_equiped and bow_cooldown:
		bow_cooldown = false
		var arrow_instancie = arrow.instantiate()
		arrow_instancie.rotation = $Marker2D.rotation
		arrow_instancie.global_position = $Marker2D.global_position
		add_child(arrow_instancie)
		
		await get_tree().create_timer(0.4).timeout
		bow_cooldown = true
	
	play_anim(direction)

func play_anim(dir):
	if !bow_equiped:
		speed = 100
		if player_state == "idle":
			$AnimatedSprite2D.play("idle")
		if player_state == "walking":
			if dir.y == -1:
				animated_sprite_2d.play("n-walk")
			if dir.x == 1:
				animated_sprite_2d.play("e-walk")
			if dir.y == 1:
				animated_sprite_2d.play("s-walk")
			if dir.x == -1:
				animated_sprite_2d.play("w-walk")
			
			if dir.x > 0.5 and dir.y < -0.5:
				animated_sprite_2d.play("ne-walk")
			if dir.x > 0.5 and dir.y > 0.5:
				animated_sprite_2d.play("se-walk")
			if dir.x < -0.5 and dir.y > 0.5:
				animated_sprite_2d.play("sw-walk")
			if dir.x < -0.5 and dir.y < -0.5:
				animated_sprite_2d.play("nw-walk")
	
	if bow_equiped:
		speed = 0
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y < 0:
			animated_sprite_2d.play("n-attack")
		if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x > 0:
			animated_sprite_2d.play("e-attack")
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y > 0:
			animated_sprite_2d.play("s-attack")
		if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x < 0:
			animated_sprite_2d.play("w-attack")
		
		if mouse_loc_from_player.x >= 25 and mouse_loc_from_player.y <= -25:
			animated_sprite_2d.play("ne-attack")
		if mouse_loc_from_player.x >= 0.5 and mouse_loc_from_player.y >= 25:
			animated_sprite_2d.play("se-attack")
		if mouse_loc_from_player.x <= -0.5 and mouse_loc_from_player.y >= 25:
			animated_sprite_2d.play("sw-attack")
		if mouse_loc_from_player.x <= -25 and mouse_loc_from_player.y <= -25:
			animated_sprite_2d.play("nw-attack")


func player():
	pass

func collect(item):
	inv.insert(item)

func _on_area_2d_body_entered(body):
	pass # Replace with function body.
