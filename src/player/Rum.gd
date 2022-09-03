extends Area2D

onready var particles = get_node("CollectionParticles")


func _on_Rum_body_entered(body):
	if body.name == "Player":
		$Sprite.hide()
		body.collect(name)
		particles.emitting = true
		yield(get_tree().create_timer(particles.lifetime * 1.1), "timeout")
		queue_free()
		
