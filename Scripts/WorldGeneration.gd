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
	startPOS = select_starting_room()
	buildCorePath(startPOS)
	emit_signal("set_spawn_point",startPOS*roomTile.roomSize*roomTile.tilePixelSize+(Vector2(2,21)*roomTile.tilePixelSize))
	
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
			
			emit_signal("set_spawn_point",map[randX][randY].position)
			foundEmptyRoom = true;		
			print ("Starting Room Coordinates: ",randX,", ",randY)
		else: countLoop +=1; if countLoop >= 100:break;
		
	if foundEmptyRoom:return Vector2(randX,randY);
	else:print ("Couldn't find an empty room")

func buildCorePath (pointA,gridDimensions = gridSize):
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

#Iterative Process
#Passes through rooms starting at the locationInGrid
#passes through check_surronding_rooms to build a list of directions
#If room is not set, will roll on each doorway, and if it passes, builds a door in the current room and the corresponding one

func fill_in_empty_map_spaces (locationInGrid,roomsChecked = []):
	if !roomsChecked.has(locationInGrid):
		var directionsToCheck = check_surronding_rooms(locationInGrid)
		roomsChecked.append(locationInGrid)
		
		for i in directionsToCheck.size():
			var newLocation = locationInGrid + direction_to_vector2d(directionsToCheck[i])
			if !check_within_grid(newLocation) or map[newLocation.x][newLocation.y].roomType != null:
				continue;
			elif !map[locationInGrid.x][locationInGrid.y].openDoorLocations.has(directionsToCheck[i]):
#			else:
				var chanceToChooseRoom = 0.50
				var rollToChoose = rand_range(0,1)
				if rollToChoose <= chanceToChooseRoom:
					map[locationInGrid.x][locationInGrid.y].open_door(directionsToCheck[i])
					map[newLocation.x][newLocation.y].open_door(inverse_direction(directionsToCheck[i]))
		var paths = map[locationInGrid.x][locationInGrid.y].openDoorLocations
#		print (locationInGrid," open doors: ", paths)
		for i in paths.size():
#			if check_within_grid(locationInGrid+direction_to_vector2d(paths[i])): #This should be redundant
			fill_in_empty_map_spaces(locationInGrid+direction_to_vector2d(paths[i]),roomsChecked)
					
#Checks a 2DVector, if it's within the WorldGrid -> true, otherwise -> false
func check_within_grid (vector):
	if vector.x > gridSize.x-1 or vector.x < 0 or vector.y < 0 or vector.y > gridSize.y-1:
		return false;
	else:return true;


#Simple function that just calls the build_room function for every room in the grid.
func build_all_rooms():
	for i in map.size():
		for j in map[i].size():
			print("(",i,",",j,") - ",map[i][j].openDoorLocations)
			map[i][j].build_room()
			
##############################################################################################
#using a vector in the grid, checks to see if there are options on the cardinal directions:
#1. if the room is already set (determined by the roomType of each room) then it won't change the room
#2. if the space in the direction is still within the grid
#Will return an array of directions that is possible. if the room is actually set though, just returns the openDoorLocations
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
			var newDirection = vector2d_to_direction(lastLocation-currentLocation)
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

func _on_DebugButton_pressed():
	get_tree().reload_current_scene()
	pass # Replace with function body.
