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
var roomSize = Vector2 (27,27)
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
var inPathways = []
var outPathways = []
var openDoorLocations = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func starting_room():
	roomType = roomTypesDict.start.object
	mainPath = true
	inPathways = roomTypesDict.start.inDirections
	outPathways = roomTypesDict.start.outDirections
	openDoorLocations.append(direction.East)
	print ("Starting Room directions: ", openDoorLocations)
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
	$EmptySpace.hide()
	roomType.show()
#	yield(get_tree().create_timer(5.0), "timeout")

func open_door (direction):
	if !openDoorLocations.has(direction):
		openDoorLocations.append(direction)

func build_room():
	var listOfRoomOpenings = listOfRoomOpenings();
	for i in listOfRoomOpenings.size():
		if i != 0 : ##Skips the starting room buildout
			if array_compare_to_check_exact_match(openDoorLocations,listOfRoomOpenings[i]):
				select_room(roomTypesDict.keys()[i])
				return;
	print ("Could not find a room in build_room() to match with the types of openings with the set: ", openDoorLocations)
	
	pass
func listOfRoomOpenings ():
	var listOfRoomOpenings = []
	var roomKeys = roomTypesDict.keys()
	for i in roomTypesDict.size():
		listOfRoomOpenings.append(roomTypesDict[roomKeys[i]].inDirections)
	return listOfRoomOpenings

func array_compare_to_check_exact_match (array1=[],array2=[]):
	var array1ToCompare = array1.duplicate()
	var array2ToCompare = array2.duplicate()
	while !array1ToCompare.empty():
		var value = array1ToCompare[0]
		if array2ToCompare.has(value):
			array2ToCompare.erase(value)
			array1ToCompare.remove(0)
		else:return false;
	if array1ToCompare.empty() and array2ToCompare.empty():return true;
	else:return false;
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
