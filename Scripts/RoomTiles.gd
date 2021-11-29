extends Node2D

onready var keyObject = preload("res://Scenes/Key.tscn")
onready var doorObject = preload("res://Scenes/Door.tscn")

onready var startingRoom = $"Start"
onready var hallway = $Hallway
onready var NS = $"N&S"
onready var NES = $"N&E&S"
onready var NWS = $"N&W&S"
onready var NEW = $"N&E&W"
onready var ESW = $"E&S&W"
onready var WS = $"W&S"
onready var WN = $"W&N"
onready var ES = $"E&S"
onready var EN = $"E&N"
onready var NESW = $"4Way"
onready var N = $"N"
onready var E = $"E"
onready var S = $"S"
onready var W = $"W"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var roomSize = Vector2 (26,26)
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
	NorthEastWest = {
	object = NEW,
	inDirections =[direction.South,direction.East,direction.West],
	outDirections = [direction.North,direction.East,direction.West]
	},
	EastSouthWest = {
	object = ESW,
	inDirections =[direction.West,direction.North,direction.East],
	outDirections = [direction.East,direction.South,direction.West]
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
	N = {
	object = N,
	inDirections =[direction.South],
	outDirections = [direction.North]
	},
	E = {
	object = E,
	inDirections =[direction.West],
	outDirections = [direction.East]
	},
	S = {
	object = S,
	inDirections =[direction.North],
	outDirections = [direction.South]
	},
	W = {
	object = W,
	inDirections =[direction.East],
	outDirections = [direction.West]
	},
}
onready var enemyTypesDict = {
	blob = preload("res://Scenes/Blob.tscn")
}
onready var objectTypesDict = {
	smallLights = preload("res://Scenes/SmallLight.tscn")
	
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

##Saving the nodes of active enemies
var activeEnemies = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func starting_room():
	roomType = roomTypesDict.start.object
	mainPath = true
	inPathways = roomTypesDict.start.inDirections
	outPathways = roomTypesDict.start.outDirections
	openDoorLocations.append(direction.East)
#	print ("Starting Room directions: ", openDoorLocations)
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

	## DEBUG ROOM
	delete_unused_rooms_except_for(roomType)
	load_light_Material(roomType)
	
#	yield(get_tree().create_timer(5.0), "timeout")

func open_door (direction):
	if !openDoorLocations.has(direction):
		openDoorLocations.append(direction)

func build_room():
	var listOfRoomOpenings = listOfRoomOpenings();
	if roomType != null:
		update_state();
		return;
	elif !openDoorLocations.empty():
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
		listOfRoomOpenings.append(roomTypesDict[roomKeys[i]].outDirections)
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
	
func delete_unused_rooms_except_for(nodeToSave):
	for i in range (self.get_child_count()-1,-1,-1):
		var nodeToDelete = get_child(i)
		if nodeToSave != nodeToDelete:
			nodeToDelete.queue_free()
			remove_child(nodeToDelete)
	var names = []
	for i in get_children().size():
		names.append(get_child(i).get_name())
	print (get_name())
	print (name)

			
func spawn_objects (count,objectType = null):
#	if mainPath and objectType == null:
#		count = 20;
	for i in range (0,count,1):
		var chosenTile = find_open_space();
		if chosenTile != null:
			if objectType == "SmallLight":
				##Just lights for now, no objectType being set/logic
				var object = objectTypesDict.smallLights.instance()
				object.position = chosenTile*tilePixelSize
				add_child(object);
			elif objectType == "Key":
				var key = keyObject.instance()
				key.position = chosenTile*tilePixelSize
				add_child(key)
			elif objectType == "Door":
				var key = doorObject.instance()
				key.position = chosenTile*tilePixelSize
				add_child(key)
				
			

func spawn_key():
	spawn_objects(1,"Key")
	
func spawn_enemies (count,enemyType = "Blob"):
	for i in range (0,count,1):
		var chosenTile = find_open_space()
		if chosenTile != null:
			if enemyType == "Blob":
				var enemy = enemyTypesDict.blob.instance()
				enemy.position = chosenTile*tilePixelSize
				add_child(enemy);
				activeEnemies.append(enemy)
	
func find_open_space ():
	if roomType != null:
		var tilesInRoom = roomType.get_used_cells()
		
		#clear list of ranges that are known to be a bad range
		for i in range(tilesInRoom.size()-1,0,-1):
			if tilesInRoom[i].x <= 0 or tilesInRoom[i].y <= 1 or tilesInRoom[i].y >= roomSize.y:
				tilesInRoom.remove(i)
			
		var foundSpawnPoint = false
		while !tilesInRoom.empty(): 
			##Choose a random tile in the set
			var randomIndex = SeedGenerator.rng.randi_range(0,tilesInRoom.size()-1)
			var chosenTile = tilesInRoom[randomIndex]
			##Selecting the space above the tile
			chosenTile += Vector2(0,-1)
			if empty_tile_check(chosenTile):
				return chosenTile;
			else: tilesInRoom.remove(randomIndex)
		print("Error - Could not find any available spaces")
		return null
	else:print ("Error - Room not set, so object can't be built");return null
func empty_tile_check(chosenTile):
	var tileArray = roomType.get_used_cells()
	for i in tileArray.size():
		if chosenTile == tileArray[i] or chosenTile+Vector2(0,-1) == tileArray[i]:
			return false
	return true
	
func load_light_Material(room):
	room.material = load("res://Materials/LightCanvasMaterial.tres")
