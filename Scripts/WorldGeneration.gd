extends Node2D
var PlayerHealth = 100
onready var roomTile = preload("res://Scenes/RoomTiles.tscn").instance()
export (int) var maxx = 100
export (int) var maxy = 100


export (Vector2) var gridSize = Vector2(4,4)

signal set_spawn_point

var roomSize = Vector2(27,27)
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
	var roomCount = round(sqrt(gridDimensions.x*gridDimensions.y))+round(((gridDimensions.x*gridDimensions.y)/3)) #formula to decide how many rooms based on room size
	var draftOfMap = map.duplicate();
	var nextPos = pointA
	var currentDirection
	if nextPos == startPOS:
#		nextPos += Vector2(1,0)
		currentDirection = direction.East
	var mainPath = find_path_through_empty_rooms(roomCount,nextPos)
	print ("Spawn Point: ",startPOS)
	print ("mainPath: ", mainPath)
	set_required_openings (mainPath)
	fill_in_empty_map_spaces (pointA);
	build_all_rooms()
	##Main path has values, the first is a vector on the map coordinates, and the second is an array of the openings
#	for i in mainPath.size():
#		var roomOpenings = mainPath[i][1]
#		var roomChoices = get_child(0).roomTypesDict
#		var viableRoomTypes = []
#		var roomKeys = roomChoices.keys()
#		for j in roomKeys.size():
#			if j == 0:
#				pass
#			else:
#				if array1_matches_all(roomOpenings,roomChoices[roomKeys[j]].inDirections):
#					viableRoomTypes.append(roomKeys[j])
#
#		if !viableRoomTypes.empty():
#			var chooseRoomType = round(rand_range(0,viableRoomTypes.size()-1))
##			print (viableRoomTypes)
#			var room = viableRoomTypes[chooseRoomType]
##			print (room)
#			map[mainPath[i][0].x][mainPath[i][0].y].select_room(room, true)
#
#		else: print("No Viable room types in buildCorePath")
	
#	print_grid(map)
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
func fill_in_empty_map_spaces (locationInGrid,roomsChecked = []):
	if !roomsChecked.has(locationInGrid):
		var directionsToCheck = check_surronding_rooms(locationInGrid)
		roomsChecked.append(locationInGrid)
		
		for i in directionsToCheck.size():
			var newLocation = locationInGrid + direction_to_vector2d(directionsToCheck[i])
			if !check_within_grid(newLocation) or map[newLocation.x][newLocation.y].roomType != null:
				continue;
			else:
				var chanceToChooseRoom = 0.50
				var rollToChoose = rand_range(0,1)
				if rollToChoose <= chanceToChooseRoom:
					map[locationInGrid.x][locationInGrid.y].open_door(directionsToCheck[i])
					map[newLocation.x][newLocation.y].open_door(inverse_direction(directionsToCheck[i]))
		var paths = map[locationInGrid.x][locationInGrid.y].openDoorLocations
		print (locationInGrid," open doors: ", paths)
		for i in paths.size():
			if check_within_grid(locationInGrid+direction_to_vector2d(paths[i])): #This should be redundant
				fill_in_empty_map_spaces(locationInGrid+direction_to_vector2d(paths[i]),roomsChecked)
					
func check_within_grid (vector):
	if vector.x > gridSize.x-1 or vector.x < 0 or vector.y < 0 or vector.y > gridSize.y-1:
		return false;
	else:return true;
	
func build_all_rooms():
	for i in map.size():
		for j in map[i].size():
			map[i][j].build_room()
	
func check_surronding_rooms (locationInGrid):
	var possibleDirections =  []
	if map[locationInGrid.x][locationInGrid.y].roomType == null:
		for i in direction.size():
			var newLocation = locationInGrid+direction_to_vector2d(direction.values()[i])
			if !check_within_grid(newLocation):continue;
			elif map[newLocation.x][newLocation.y].roomType == null:
				possibleDirections.append(direction.values()[i])
		return possibleDirections
	else: return map[locationInGrid.x][locationInGrid.y].openDoorLocations
	return possibleDirections

func set_required_openings (mainPath):
	for i in mainPath.size():
		if i != 0:
			var lastLocation = mainPath[i-1]
			var currentLocation = mainPath [i]
			var newDirection = vector2d_to_direction(currentLocation-lastLocation)
			map[currentLocation.x][currentLocation.y].open_door(newDirection)
			map[lastLocation.x][lastLocation.y].open_door(inverse_direction(newDirection))
		pass

func inverse_direction (directionToInverse):
	if directionToInverse == direction.North:
		return direction.South
	elif directionToInverse == direction.East:
		return direction.West
	elif directionToInverse == direction.South:
		return direction.North
	elif directionToInverse == direction.West:
		return direction.East
	else:print("func inverse_direction was not fed in a enum direction")
func vector2d_to_direction (vector):
	if vector == Vector2(0,-1):return direction.North;
	elif vector == Vector2(1, 0):return direction.East;
	elif vector == Vector2(0, 1):return  direction.South;
	elif vector == Vector2(-1, 0):return direction.West;
	else:print("func vector2d_to_direction was not fed in a vector")
func direction_to_vector2d (directionToTranslate):
	if directionToTranslate == direction.North:return Vector2(0,-1) ;
	elif directionToTranslate == direction.East:return Vector2(1, 0);
	elif directionToTranslate == direction.South:return Vector2(0, 1);
	elif directionToTranslate == direction.West:return Vector2(-1, 0);
	else:print("func direction_to_vector2d was not fed in a recognized direction")
	
#func find_path_through_empty_rooms (totalRoomsToDo, lastPOS, roomCount=0, chosenRooms = [], rooms=map.duplicate()):
#
#	if roomCount >= totalRoomsToDo:
#		return chosenRooms
#	var directionsToChooseOrdered = []
#	var directionsRemaining = [direction.North,direction.East,direction.South,direction.West]
#	while !directionsRemaining.empty():
#
#		var directionChoice = round(rand_range(0,directionsRemaining.size()-1))
#		directionsToChooseOrdered.append(directionsRemaining[directionChoice])
#		directionsRemaining.remove(directionChoice)
#
#	for i in directionsToChooseOrdered:
#		var roomToChoose = directionsToChooseOrdered[i]
#		var nextRoomPOS = lastPOS + direction_to_vector2d(roomToChoose)
#
#		##check to see if coordinates are out of the grid dimensions (assuming grid always starts at 0
#		if nextRoomPOS.x > rooms.size()-1 or nextRoomPOS.x < 0 or nextRoomPOS.y < 0 or nextRoomPOS.y > rooms[nextRoomPOS.x].size()-1:
#			continue;
#		elif chosenRooms.has(nextRoomPOS):
#			continue
#		else:
#			chosenRooms.append(nextRoomPOS)
#			if roomCount + 1 >= totalRoomsToDo:
##				print ("chosenRooms in iteration:", chosenRooms)
#				return chosenRooms
##			print (chosenRooms.append(nextRoomPOS))
#			var newValue = find_path_through_empty_rooms(totalRoomsToDo,nextRoomPOS,roomCount+1,chosenRooms, rooms.duplicate())
##			print (newValue)
#			if newValue !=null:
#				if newValue.size() >= roomCount:
#					return newValue
#	return null;
#			chosenRooms.append(newValue)
#			print("Choosing the rooms: ", chosenRooms)
#			if typeof(chosenRooms) == Array:
#				return chosenRooms
#			else: return false;
			
func find_path_through_empty_rooms (totalPathCountGoal,currentPosition,chosenRoomPath=[],lengthOfPath=0):
#	if lengthOfPath<totalPathCountGoal:
	var chosenDirections = []
	var openSpaces = check_surronding_rooms(currentPosition)
#	if openSpaces.empty():
#		openSpaces=map[currentPosition.x][currentPosition.y].openDoorLocations
	while !openSpaces.empty():
		var rollDirection = round(rand_range(0,openSpaces.size()-1))
		chosenDirections.append(openSpaces[rollDirection])
		openSpaces.remove(rollDirection)
	if chosenDirections.empty():
		return null
	for i in chosenDirections.size():
		var newPosition = currentPosition+direction_to_vector2d(chosenDirections[i])
		if !chosenRoomPath.has(newPosition):
			lengthOfPath += 1;
			var newPath = chosenRoomPath.duplicate()
			newPath.append(currentPosition)
			if lengthOfPath >= totalPathCountGoal:
				return newPath;
			var pathWayFound = find_path_through_empty_rooms (totalPathCountGoal,newPosition,newPath,lengthOfPath)
			if pathWayFound == null:
				continue;
			else: return pathWayFound
#	else:return chosenRoomPath
#	print_grid (rooms)
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
