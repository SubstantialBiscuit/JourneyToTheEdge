extends Area2D

tool

export var STRENGTH := 50
export var RADIUS := 10
const DENSITY := 0.01
var curr_body = null
onready var direction := Vector2.UP.rotated(rotation)
onready var collision := get_node("CollisionShape2D")
onready var particles := get_node("CPUParticles2D")


func _ready():
	collision.get("shape").set("radius", RADIUS)
	particles.set("emission_sphere_radius", RADIUS)
	particles.set("amount", int(pow(RADIUS, 2) * DENSITY))
	var speed := STRENGTH
	particles.set("initial_velocity", STRENGTH)
	particles.set("lifetime", clamp(RADIUS / STRENGTH, 0.01, 1))
	particles.set("scale", clamp(STRENGTH / 100, 0.1, 3.0))
	var grey := clamp(lerp(1.0, 0.3, STRENGTH / 100), 0.0, 1.0)
	particles.set("color", Color(grey, grey, grey))
	if not OS.is_debug_build():
		$Sprite.visible = false
	else:
		$Sprite.set("scale", Vector2(1, STRENGTH / 10))


func gust():
	if curr_body != null and curr_body.name == "Player":
		# Apply force relative to distance from centre
		var strength = clamp(
			lerp(STRENGTH, 0, position.distance_to(curr_body.position) / RADIUS),
			0.0,
			STRENGTH
		)
		curr_body.apply_central_impulse(direction * strength)
		# Apply torque to try to align the body with the wind direction
		var torque_dir = curr_body.direction.cross(direction)
		torque_dir /= abs(torque_dir)
		var torque_strength = lerp(0.5 * STRENGTH, 0, (direction.dot(curr_body.direction) + 1) / 2)
		curr_body.apply_torque_impulse(torque_dir * torque_strength)


func _on_Wind_body_entered(body):
	if body.name == "Player":
		curr_body = body
		gust()
		$GustTimer.start()


func _on_Wind_body_exited(body):
	if body.name == "Player":
		curr_body = null
		$GustTimer.stop()


func _on_GustTimer_timeout():
	gust()

