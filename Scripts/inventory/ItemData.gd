extends Resource

class_name ItemData

enum Type {
	Frost,
	Cold,
	Normal,
}

@export var type: Type
@export var name: String = ""
@export var stackable: bool = false
@export var texture: Texture2D
