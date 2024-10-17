class_name Character extends Object

var role = [ 
	"victim", 
	"culprit", 
	"witness", 
	"bystander",
	"first to scene"
	]
var chara_name = [
	"Jane",
	"Don",
	"Clarisse",
	"Hector",
	"Melanie",
	"Monroe"
]
var character_role =  [ 
	"butler", 
	"maid", 
	"spouse", 
	"affair partner",  
	"business partner", 
	"old flame", 
	"rival", 
	"fan", 
	"apprentice",
]
var grudge = [
	"jealous",
	"wants their fortune",
	"victim cheated",
	"victim didn't love them back",
	"victim was blackmailing them",
	"",
]
var personal_item = [
	"a hankercheif",
	"a tube of mascara",
	"gloves",
	"a hair",
	"a key"
	]
var array_dupe = []
var hint = ""
var alibi = [
	"with another character",
	"running errands",
	"studying",
	"working",
	"sleeping"
]
var location = [
	"kitchen",
	"lounge",
	"den",
	"bathroom",
	"balcony"
]
var cause_of_death = [
	"strangulation",
	"drowning",
	"blunt force trauma",
	"blood loss",
	"poisoning",
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _generate_character() -> Character:
	var new_chara = Character.new()
	if role.size() > 0 and character_role.size() > 0 and grudge.size() > 0:
		new_chara.chara_name = _get_trait(chara_name)
		new_chara.role = _get_trait(role)
		new_chara.character_role = _get_trait(character_role)
		new_chara.grudge = _get_trait(grudge)
		new_chara.personal_item = _get_trait(personal_item);
		new_chara.location = _get_trait(location);
		new_chara.alibi = _get_trait(alibi);
		new_chara.cause_of_death = _get_trait(cause_of_death)

		return new_chara
	else:
		return null


func _get_trait(my_array) -> String:
	array_dupe = my_array.duplicate()
	array_dupe.shuffle()
	if my_array.has("bystander") and my_array.front() == "bystander":
		return my_array.front()
	else:
		return my_array.pop_front()
