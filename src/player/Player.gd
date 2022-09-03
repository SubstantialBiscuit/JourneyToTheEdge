extends RigidBody2D

export var MAX_HEALTH := 100.0
export var MAX_MORALE := 30.0
export var SHIP_POWER := 100.0
export var SHIP_BRAKES := 20.0
export var TURN_POWER := 300.0
export var DRAG_FACTOR := 5.0
const RUM := 20
onready var health := MAX_HEALTH
onready var morale := MAX_MORALE
onready var hud := get_parent().get_node("PlayerHUD")
onready var chest := false
var invincible := false
var drag := Vector2.ZERO
var direction := Vector2.UP
var local_collision_pos := Vector2.ZERO
var local_collision_normal := Vector2.ZERO

signal died
signal mutiny


# Called when the node enters the scene tree for the first time.
func _ready():
	print_velocity()


func print_velocity():
	print(
		"Velocity: %s, Vel Angle: %s, Rotation: %s" %
		[linear_velocity, rad2deg(linear_velocity.angle_to(Vector2.UP)), rotation_degrees])
	yield(get_tree().create_timer(5.0), "timeout")
	print_velocity()


func _draw():
	if OS.is_debug_build():
		# Rotate vectors to get them in local coordinates
		draw_line(Vector2.ZERO, direction.rotated(-rotation) * 100, Color(0, 0, 0), 2)
		draw_line(Vector2.ZERO, drag.rotated(-rotation) * 100, Color(0.5, 0.5, 1))
		draw_line(Vector2.ZERO, linear_velocity.rotated(-rotation), Color(0.5, 1, 0.5))
		draw_circle(get_global_transform().xform_inv(local_collision_pos), 2, Color(1, 0, 0))
		draw_line(
			get_global_transform().xform_inv(local_collision_pos),
			get_global_transform().xform_inv(local_collision_normal),
			Color(1, 0, 0)
		)


func _process(delta):
	morale -= delta
	hud.set_morale((morale / MAX_MORALE) * 100)
	if morale <= 0:
		mutiny()


func _physics_process(delta):
	direction = Vector2.UP.rotated(rotation)
	var force := 0.0
	var torque := 0.0
	if Input.is_action_pressed("ui_up"):
		force += delta * SHIP_POWER
	if Input.is_action_pressed("ui_down"):
		force -= delta * SHIP_BRAKES
	if Input.is_action_pressed("ui_left"):
		torque -= delta * TURN_POWER
	if Input.is_action_pressed("ui_right"):
		torque += delta * TURN_POWER
	# Calculate the dot product between the linear velocity and the direction
	# the ship is facing to have higher drag force when linear velocity is at
	# 90deg to the ship
	var dot := linear_velocity.normalized().dot(direction)
	drag = lerp(
		Vector2.ZERO, -linear_velocity * delta * DRAG_FACTOR, abs(abs(dot) - 1)
	)
	apply_torque_impulse(torque)
	apply_central_impulse(direction * force + drag)
	if OS.is_debug_build():
		update()


func damage(amount):
	if OS.is_debug_build():
		update()
	if not invincible:
		health -= amount
		hud.set_health((health / MAX_HEALTH) * 100)
		if health <= 0:
			death()
		invincible = true
		$InvicibilityTimer.start()
		$DamageParticles.position = get_global_transform().xform_inv(local_collision_pos)
		$DamageParticles.direction = local_collision_normal.normalized()
		$DamageParticles.initial_velocity = amount
		$DamageParticles.angular_velocity = amount
		$DamageParticles.emitting = true


func death():
	$WakeParticles.hide()
	$Sprite.hide()
	$DeathParticles.emitting = true
	emit_signal("died")


func mutiny():
	$WakeParticles.hide()
	$DeathParticles.emitting = true
	emit_signal("mutiny")


func collect(item: String):
	if item == "Rum":
		morale = clamp(morale + RUM, 0, MAX_MORALE)
	elif item == "Chest":
		chest = true


func _integrate_forces( state ):
	if state.get_contact_count() > 0:
		local_collision_pos = state.get_contact_local_position(0)
		local_collision_normal = state.get_contact_local_normal(0)


func _on_Player_body_entered(body):
	if body.name == "TileMap":
		damage(linear_velocity.length())


func _on_InvicibilityTimer_timeout():
	invincible = false

