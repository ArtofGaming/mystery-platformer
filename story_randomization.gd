
extends Node2D
var cast = []
var chara_gen = null
var briefing_text = RichTextLabel
var chosen_victim = ""
var chara_limit = 5
var array_dupe = []
var crime_scene = ""
var died_of = ""
var error = ""
var witness_saw = [
	"an argument",
	"the culprit near the murder scene",
	"the murder weapon go missing at time",
	"someone with a strange item",
]
	
var left_behind_clue = ""

var bad_coverup = ""
var motive = ""
var weapon = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	chara_gen = get_node("chara")
	briefing_text = get_node("Control/text")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _generate_story() -> void:
	while cast.size() < 5:
		_generate_characters()
	var format_opening = "
		Detective, come quick! There has been a murder.
		%s has been found in the %s.
		%s seems to have died from %s. 
		Once the body was found, everyone present in the building was asked to stay. 
		Get a confession and don't get caught in the culprit's traps. Good luck.
	"
	var opening = format_opening % [chosen_victim,crime_scene,chosen_victim,died_of]

	briefing_text.text = opening

	#VICTIM was found dead at TIME by BODYFINDER. 
	#They seems to have died from CAUSE.
	#THING was missing from the scene when BODYFINDER found them. 
	#Suspects are: SUSPECT, RELATIONSHIP, HIDDEN GRUDGE...
	#The killer is KILLER who killed them because of GRUDGE. 
	#During the murder ERROR went wrong and UNINTENDEDCLUE was left behind.
	#The killer did COVERUPATTEMPT to try and hide their crime.

	pass

func _generate_characters() -> void:
	for i in range(chara_limit):
		cast.append(chara_gen._generate_character())
		if cast[i].role.contains("victim"):
			chosen_victim = cast[i].chara_name
			crime_scene = cast[i].location
			died_of = cast[i].cause_of_death
		elif cast[i].role.contains("culprit"):
			motive = cast[i].grudge
			left_behind_clue = cast[i].personal_item
	
	#c[array.name.to_string()] = array[randi() % array.size()]

func _on_button_pressed() -> void:
	_generate_story()
