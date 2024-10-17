class_name CaveCell extends Object
enum CaveCellType {
    INVALID = -1, 
    WALL = 0,
    FLOOR = 1, 
    MAX = 2
    }

var coordinate = Vector2.ZERO
var type : CaveCellType = CaveCellType.INVALID

func _init_with_coordinate(_coordinate) -> CaveCell:
    var new_cell = CaveCell.new()
    coordinate = _coordinate
    type = CaveCellType.INVALID
    return new_cell


