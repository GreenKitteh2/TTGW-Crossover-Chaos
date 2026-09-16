extends TextureRect

## Child References
@onready var body_menu := $Options/BodyType/OptionButton
@onready var species_menu := $Options/Species/OptionButton
@onready var head_index := $Options/HeadIndex/Index

## Locals
var dna : ToonDNA:
	set(x):
		dna = x
		apply_dna(x)

## Signals
signal s_dna_changed(dna : ToonDNA)

## Sets up the body and species menus
func _ready():
	for body_type in ToonDNA.BodyType.keys():
		body_menu.add_item(body_type)
	
	for species in ToonDNA.ToonSpecies.keys():
		species_menu.add_item(species)

## Syncs DNA options to the current state of the dna variable
func apply_dna(_dna : ToonDNA):
	body_menu.selected = dna.body_type as int
	species_menu.selected = dna.species as int
	head_index.set_text(str(dna.head_index))

## Sets the body of the Toon
func set_body(body_type : int):
	dna.body_type = body_type as ToonDNA.BodyType
	s_dna_changed.emit(dna)

func set_species(species : int):
	dna.species = species as ToonDNA.ToonSpecies
	s_dna_changed.emit(dna)

func set_head(up : bool = false):
	if up:
		dna.head_index+=1
	else:
		dna.head_index-=1
	s_dna_changed.emit(dna)
