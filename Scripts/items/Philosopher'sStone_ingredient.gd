extends Resource
class_name Item
 
@export var icon: Texture2D
@export var name : String
 
@export var recipe: Array[Item]
 
@export_enum("Item", "Ingredient") 
var type = "Ingredient"
 
@export_multiline var description: String
