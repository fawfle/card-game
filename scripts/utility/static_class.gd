class_name StaticClass
## A helper class for making a class "static". In practice, it only stops a class from being instantiated. Also, it extends the default class [RefCounted].

func _init() -> void:
	push_error("This class is static and should not be instantiated.")
