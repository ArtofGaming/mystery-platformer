extends Node2D
@export var Block: PackedScene = preload("res://block.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var blocks: Node2D = Block.instantiate()
	add_child(blocks)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
