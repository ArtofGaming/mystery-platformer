
class_name Cave extends Node

@export var Block: PackedScene = preload("res://block.tscn")

@export var grid: Array = []
@export var grid_height = 30
@export var grid_width = 30
var _atlas: Texture2D
var _grid_size: int
var tile_size = 128

var cave_name = ""
var chance_to_become_wall: float = .45
var cave_cell = CaveCell.new()
var caverns: Array = []

var num_of_transition_steps: int = 1

#number of cells in moore neighborhood to convert
var floors_minimum_to_convert_to_wall: int = 4
var walls_maximum_to_convert_to_floor: int = 3

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

func _generate_with_seed(my_seed:int):
	print("Cave is being generated")
	var start_date = Time.get_ticks_msec()
	_initialize_grid()
	for step in range(num_of_transition_steps):
		var format_step_string = "Performing transition step #%s"
		var step_string = format_step_string % (step + 1)
		print(step_string)
		do_transition_step()
	identify_caverns()
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
				pass
			else:
				#edit this to use 3x3 ground tiles
				sprite.frame = 0
				add_child(blocks)
				blocks.position = position_for_grid_coordinate(Vector2(x,y))

func position_for_grid_coordinate(coordinate:Vector2) -> Vector2:
	return Vector2(coordinate.x * tile_size, coordinate.y * tile_size)

func count_wall_moore_neighbors_from_grid_coordinate(coordinate:Vector2) -> int:
	var wall_count:int = 0
	for i in range(-1,2):
		for j in range(-1,2):
			if (i == 0 and j == 0):
				break
			var neighbor_coordinate = Vector2(coordinate.x + i, coordinate.y + j)
			if (!_is_valid_coordinate(neighbor_coordinate)):
				wall_count += 1
			elif (_cave_cell_from_coordinate(neighbor_coordinate).type == CaveCell.CaveCellType.WALL):
				wall_count += 1
	return wall_count

func do_transition_step():
	var new_grid: Array = []
	for y in range(grid_height):
		var new_row: Array = []
		for x in range(grid_width):
			var coordinate = Vector2(x,y)
			var moore_neighbor_wall_count = count_wall_moore_neighbors_from_grid_coordinate(coordinate)

			var old_cell: CaveCell = _cave_cell_from_coordinate(coordinate)
			var new_cell: CaveCell = CaveCell.new()._init_with_coordinate(coordinate)

			if (old_cell.type == CaveCell.CaveCellType.WALL):
				if (moore_neighbor_wall_count < walls_maximum_to_convert_to_floor):
					new_cell.type = CaveCell.CaveCellType.FLOOR
				else:
					new_cell.type = CaveCell.CaveCellType.WALL
			else:
				if (moore_neighbor_wall_count > floors_minimum_to_convert_to_wall):
					new_cell.type = CaveCell.CaveCellType.WALL
				else:
					new_cell.type = CaveCell.CaveCellType.FLOOR
			new_row.append(new_cell)
		new_grid.append(new_row)
	grid = new_grid

func identify_caverns() -> void:
	var array: Array = []
	caverns = array
	var flood_fill_array: Array = []

	for y in range(grid_height):
		var flood_fill_array_row: Array = []
		
		for x in range(grid_width):
			var cell_to_copy: CaveCell = grid[y][x]
			var copied_cell: CaveCell = CaveCell.new()._init_with_coordinate(cell_to_copy.coordinate)
			copied_cell.type = cell_to_copy.type
			flood_fill_array_row.append(copied_cell)
		flood_fill_array.append(flood_fill_array_row)

	var fill_number: int = CaveCell.CaveCellType.MAX

	for y in range(grid_height):
		for x in range(grid_width):
			if ((flood_fill_array[y][x]).type == CaveCell.CaveCellType.FLOOR):
				caverns.append(array)
				flood_fill_caverns(flood_fill_array, Vector2(x,y), fill_number)
				fill_number += 1
	var format_cavern_count_string = "Number of caverns in cave: %s"
	var cavern_count_string = format_cavern_count_string % (caverns.size())
	print(cavern_count_string)


func flood_fill_caverns(array: Array, from_coordinate: Vector2, fill_number: int) -> void:
	var cell:CaveCell = array[from_coordinate.y][from_coordinate.x]
	if (cell.type != CaveCell.CaveCellType.FLOOR):
		return
	cell.type = fill_number
	[caverns[-1]].append(cell)
	if (from_coordinate.x > 0):
		flood_fill_caverns(array, Vector2(from_coordinate.x - 1, from_coordinate.y), fill_number)
	if (from_coordinate.x < grid_width - 1):
		flood_fill_caverns(array, Vector2(from_coordinate.x + 1, from_coordinate.y), fill_number)
	if (from_coordinate.y > 0):
		flood_fill_caverns(array, Vector2(from_coordinate.x, from_coordinate.y - 1), fill_number)
	if (from_coordinate.y < grid_height - 1):
		flood_fill_caverns(array, Vector2(from_coordinate.x, from_coordinate.y + 1), fill_number)
#func _process(delta: float) -> void:
