extends Node2D
var PlayerHealth = 100
onready var roomTile = preload("res://Scenes/RoomTiles.tscn").instance()
export (int) var maxx = 100
export (int) var maxy = 100


export (Vector2) var gridSize = Vector2(4,4)

signal set_spawn_point

var roomSize = Vector2(25,25)
var map = []
var startPOS = Vector2()
enum direction{North,East,South,West}
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	make_grid(gridSize);
	select_starting_room()
	buildCorePath(startPOS)
	
	pass

func make_grid(gridDimensions = gridSize):
	for i in gridDimensions.x:
		map.append([]);
		for j in gridDimensions.y:
			var blankLocation = roomTile.duplicate()
			blankLocation.position = Vector2(i,j)*blankLocation.tilePixelSize*blankLocation.roomSize
			add_child(blankLocation)
			map[i].append(blankLocation);
	print_grid(map);

func select_starting_room(gridDimensions = gridSize):
	var randX;
	var randY;
	var foundEmptyRoom = false;
	var countLoop = 0
	while !foundEmptyRoom:
		randX = round(rand_range(0,gridDimensions.x-2)); #Starting room is always only open to the East
		randY = round(rand_range(0,gridDimensions.y-1));
		if map[randX][randY].roomType==null:
			map[randX][randY].starting_room();
			startPOS = Vector2(randX,randY)
			emit_signal("set_spawn_point",map[randX][randY].position)
			foundEmptyRoom = true;
		else: countLoop +=1; if countLoop >= 100:break;
		
	print ()
	if !foundEmptyRoom:
		print ("Couldn't find an empty room")

#pointB not being utilized
func buildCorePath (pointA,gridDimensions = gridSize, pointB = null):
	var roomCount = round(sqrt(gridDimensions.x*gridDimensions.y)) #formula to decide how many rooms based on room size
	var draftOfMap = map.duplicate();
	var lastPOS = startPOS
	var nextPos
	var currentDirection = direction.East
	var mainPath = find_path_through_empty_rooms(roomCount,lastPOS,currentDirection)
	##Main path has values, the first is a vector on the map coordinates, and the second is an array of the openings
	for i in mainPath.size():
		var roomOpenings = mainPath[i][1]
		var roomChoices = get_child(0).roomTypesDict
		var viableRoomTypes = []
		var roomKeys = roomChoices.keys()
		for j in roomKeys.size():
			if j == 0:
				pass
			else:
				if array1_matches_all(roomOpenings,roomChoices[roomKeys[j]].outDirections):
					viableRoomTypes.append(roomKeys[j])
		
		if !viableRoomTypes.empty():
			var chooseRoomType = round(rand_range(0,viableRoomTypes.size()-1))
			print (viableRoomTypes)
			var room = viableRoomTypes[chooseRoomType]
			print (room)
			map[mainPath[i][0].x][mainPath[i][0].y].select_room(room, true)
	
		else: print("No Viable room types in buildCorePath")
	
	print_grid(map)
#	for i in roomCount:
#		var openDirections = [];
#		if map[lastPOS.x][lastPOS.y-1] == null:
#			openDirections.append(direction.North)
#		if map[lastPOS.x+1][lastPOS.y] == null:
#			openDirections.append(direction.East)
#		if map[lastPOS.x][lastPOS.y+1] == null:
#			openDirections.append(direction.South)
#		if map[lastPOS.x-1][lastPOS.y] == null:
#			openDirections.append(direction.West)
#
#		if currentDirection == direction.East:
#			pass
func fill_in_empty_map_spaces (mainPath):
	for i in mainPath.size():
		pass
	
func find_path_through_empty_rooms (totalRoomsToDo, lastPOS,lastDirection, roomCount=0, chosenRooms = [], rooms=map.duplicate()):
	
	if totalRoomsToDo <= roomCount:
		return chosenRooms
	var directionsToChooseOrdered = []
	var directionsRemaining = [direction.North,direction.East,direction.South,direction.West]
	while !directionsRemaining.empty():
		
		var directionChoice = round(rand_range(0,directionsRemaining.size()-1))
		directionsToChooseOrdered.append(directionsRemaining[directionChoice])
		directionsRemaining.remove(directionChoice)
			
	for i in directionsToChooseOrdered:
		var roomToChoose = directionsToChooseOrdered[i]
		var nextRoomPOS 
		if roomToChoose == direction.North:
			nextRoomPOS = lastPOS + Vector2(0,-1);
		elif roomToChoose == direction.East:
			nextRoomPOS = lastPOS + Vector2(1,0);
		elif roomToChoose == direction.South:
			nextRoomPOS = lastPOS + Vector2(0,1);
		elif roomToChoose == direction.West:
			nextRoomPOS = lastPOS + Vector2(-1,0);
		else:print("error - no direction was found")
		
		##check to see if coordinates are out of the grid dimensions (assuming grid always starts at 0
		if nextRoomPOS.x > rooms.size()-1 or nextRoomPOS.x < 0 or nextRoomPOS.y < 0 or nextRoomPOS.y > rooms[nextRoomPOS.x].size()-1:
			continue;
			
		if rooms[nextRoomPOS.x][nextRoomPOS.y].roomType == null:
			rooms[nextRoomPOS.x][nextRoomPOS.y].mainPath = true
			if roomCount + 1 >= totalRoomsToDo:
				chosenRooms.append([nextRoomPOS,[lastDirection,roomToChoose]])
				print ("chosenRooms in iteration:", chosenRooms)
				return chosenRooms
#			print (chosenRooms.append(nextRoomPOS))
			chosenRooms.append([nextRoomPOS,[lastDirection,roomToChoose]])
			var newValue = find_path_through_empty_rooms(totalRoomsToDo,nextRoomPOS,roomToChoose,roomCount+1,chosenRooms, rooms.duplicate())
			print (newValue)
			if newValue !=null:
				if newValue.size() >= roomCount:
					return newValue
#			chosenRooms.append(newValue)
#			print("Choosing the rooms: ", chosenRooms)
#			if typeof(chosenRooms) == Array:
#				return chosenRooms
#			else: return false;
			
		
	print_grid (rooms)
#	print("Choosing the rooms: ", chosenRooms)
#	if chosenRooms.size() >= totalRoomsToDo:
#		return chosenRooms
#	else: print("error - did not find any suitable path")
	
		
#	return false

func array1_matches_all (array1, array2):
	for i in array1.size():
		if !array2.has(array1[i]):
			return false
	return true	
func print_grid(gridToPrint):
	for i in gridToPrint.size():
		var string = "("
		for j in gridToPrint[i].size():
			string += str(gridToPrint[i][j])+"), (" 
		string = string.rstrip(", (")
		print(string)
	print ("")
	print ("")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
