extends Node2D


onready var startingRoom = $"Starting Area"
onready var hallway = $Hallway
onready var NS = $"N&S"
onready var NES = $"N&E&S"
onready var NWS = $"N&W&S"
onready var WS = $"W&S"
onready var WN = $"W&N"
onready var ES = $"E&S"
onready var EN = $"E&N"
onready var NESW = $"4Way"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var roomSize = Vector2 (25,25)
var tilePixelSize = Vector2(64,64)

onready var roomTypesDict = {
	start = {
	object = startingRoom,
	inDirections =[direction.West],
	outDirections = [direction.East]
	
	},
	hall = {
	object = hallway,
	inDirections =[direction.West,direction.East],
	outDirections = [direction.East,direction.West]
	},
	NorthSouth = {
	object = NS,
	inDirections = [direction.South,direction.North],
	outDirections = [direction.North,direction.South]
	},
	NorthEastSouth = {
	object = NES,
	inDirections =[direction.South,direction.West,direction.North],
	outDirections = [direction.North,direction.East,direction.South]
	},
	NorthWestSouth = {
	object = NWS,
	inDirections =[direction.South,direction.East,direction.North],
	outDirections = [direction.North,direction.West,direction.South]
	},
	WestSouth = {
	object = WS,
	inDirections =[direction.East,direction.North],
	outDirections = [direction.West,direction.South]
	},
	WestNorth = {
	object = WN,
	inDirections = [direction.South,direction.East],
	outDirections = [direction.West,direction.North]
	},
	EastSouth = {
	object = ES,
	inDirections =[direction.West,direction.North],
	outDirections = [direction.East,direction.South]
	},
	EastNorth = {
	object = EN,
	inDirections =[direction.South,direction.West],
	outDirections = [direction.East,direction.North]
	},
	All4 = {
	object = NESW,
	inDirections =[direction.North,direction.East,direction.South,direction.West],
	outDirections = [direction.North,direction.East,direction.South,direction.West]
	},
}


enum direction{North,East,South,West}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var roomType = null
var mainPath = false
var inPathways = null
var outPathways = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func starting_room():
	roomType = roomTypesDict.start.object
	mainPath = true
	inPathways = roomTypesDict.start.inDirections
	outPathways = roomTypesDict.start.outDirections
	update_state();

func select_room (roomChosen, isThisMainPath = false):
	print(roomChosen)
	if roomTypesDict.has(roomChosen):
		roomType = roomTypesDict[roomChosen].object;
		mainPath = isThisMainPath
		inPathways = roomTypesDict[roomChosen].inDirections
		outPathways = roomTypesDict[roomChosen].outDirections
		update_state();
	else: print("select_room's roomChosen is not found in dictionary")
		
			
func update_state():
	roomType.show()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
