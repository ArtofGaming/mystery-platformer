
class_name Cave extends Node

@export var Block: PackedScene = preload("res://block.tscn")

@export var grid: Array = []
@export var grid_height = 30
@export var grid_width = 30
var _atlas: Texture2D
#var _grid_size: int
var tile_size = 70

var cave_name = ""
var chance_to_become_wall: float = .45
var cave_cell = CaveCell.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func init_with_atlas(atlas_name: String, gridSize: int) -> Cave:
	var my_cave = Cave.new()
	my_cave._atlas = load(atlas_name)
	my_cave._grid_size = gridSize
	return my_cave


func _initialize_grid():
	grid = []
	for y in range(grid_height):
		var row = []
		for x in range(grid_width):
			var coordinate = [x,y]
			var cell: CaveCell = cave_cell._init_with_coordinate(coordinate)
			if (random_number_between_0_and_1() < chance_to_become_wall):
				cell.type = CaveCell.CaveCellType.WALL
			else:
				cell.type = CaveCell.CaveCellType.FLOOR
			row.append(cell)
		grid.append(row)

func _generate_with_seed(seed:int):
	print("Cave is being generated")
	var start_date = Time.get_ticks_msec()
	_initialize_grid()
	_generate_tiles()
	var format_time_string = "Generated in %s seconds"
	var time_string = format_time_string % (Time.get_ticks_msec() - start_date)
	print(time_string)

func _is_valid_coordinate(coordinate: Vector2) -> bool:
	return  !(coordinate.x < 0 
			|| coordinate.x >= grid_width 
			|| coordinate.y < 0 
			|| coordinate.y >= grid_height)

func _cave_cell_from_coordinate(coordinate: Vector2) -> CaveCell:
	if (_is_valid_coordinate(coordinate)):
		return grid[coordinate.y][coordinate.x]
	return null

func random_number_between_0_and_1() -> float:
	return randf_range(0,1)

func _generate_tiles():
	for y in range(grid_height):
		for x in range(grid_width):
			var cell: CaveCell = _cave_cell_from_coordinate(Vector2(x,y))
			var blocks: Node2D = Block.instantiate()
			var sprite: Sprite2D = blocks.get_node("Sprite2D")
			if (cell.type == cell.CaveCellType.WALL):
				sprite.frame = 0
			else:
				sprite.frame = 1
			add_child(blocks)
			blocks.position = position_for_grid_coordinate(Vector2(x,y))

func position_for_grid_coordinate(coordinate:Vector2) -> Vector2:
	return Vector2(coordinate.x * tile_size, coordinate.y * tile_size)

#func _process(delta: float) -> void:
	#pass
