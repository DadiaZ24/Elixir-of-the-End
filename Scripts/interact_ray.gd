extends RayCast3D

func _process(delta):
	if is_colliding():
		print("A apontar para:", get_collider())
