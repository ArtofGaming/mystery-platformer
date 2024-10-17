extends Node
var my_cave: Cave
var gridSize = Vector2(64,64)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_with_size(60)
	pass
	
func init_with_size(size: int):
	my_cave = Cave.new().init_with_atlas("res://spritesheet_ground.png",70)
	my_cave.name = "CAVE"
	my_cave._generate_with_seed(0)
	add_child(my_cave)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
