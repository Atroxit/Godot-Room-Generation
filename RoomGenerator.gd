extends Node2D

var img = preload("res://Rooms/TestRoom.png")

var SceneRows = 9
var SceneColumns = 9
var SceneGridSpacing = 64
var SceneCentreRoom

var RoomRows = 8
var RoomColumns = 8
var RoomGridSpacing = 8

var roomNum = 0
var RoomAmount = 16
var RoomList = []
var RoomsSpawned = []

# Called when the node enters the scene tree for the first time.
func _ready():
	SceneCentreRoom = [SceneRows/2, SceneColumns/2]
	
	var SceneRooms = []
	for x in range(SceneRows):
		SceneRooms.append([])
		for y in range(SceneColumns):
			SceneRooms[x].append(0)

	generateRoom(SceneCentreRoom[0], SceneCentreRoom[1])
	addSurroundingRooms(SceneCentreRoom[0], SceneCentreRoom[1])

	while RoomsSpawned.size() != RoomAmount:
		RoomSpawner()
		#print(RoomsSpawned.size())
	
	for i in range(RoomsSpawned.size()):
		generateRoom(RoomsSpawned[i][0], RoomsSpawned[i][1])
		
		
func generateEdges(x :int, y :int):
	pass
	
func RoomSpawner():
	randomize()
	var randNum = int(rand_range(0,RoomList.size()))
	
	for i in range(RoomsSpawned.size()):
		if RoomList[randNum] == RoomsSpawned[i]:
			return
				
	RoomsSpawned.append([RoomList[randNum][0], RoomList[randNum][1]])
	#generateRoom(RoomList[randNum][0], RoomList[randNum][1])

	for i in range(RoomsSpawned.size()):
		addSurroundingRooms(RoomsSpawned[i][0], RoomsSpawned[i][1])

func addSurroundingRooms(x :int, y :int):
	var up = [x-1, y]
	#print(up)
	if not checkIfExitsInArray(up[0],up[1]):
		RoomList.append(up)
		
	var down = [x+1, y]
	#print(down)
	if not checkIfExitsInArray(down[0],down[1]):
		RoomList.append(down)
		
	var left = [x, y-1]
	#print(left)
	if not checkIfExitsInArray(left[0],left[1]):
		RoomList.append(left)
		
	var right = [x, y+1]
	#print(right)
	if not checkIfExitsInArray(right[0],right[1]):
		RoomList.append(right)
	
func checkIfExitsInArray(x :int, y :int) -> bool:
	for i in range(RoomList.size()):
		if RoomList[i][0] == x && RoomList[i][1] == y:
			return true
		else:
			return false
	return false
	
func generateRoom(SceneRoomNumRow :int, SceneRoomNumColumn :int):
	var room = []
	for x in range(RoomRows):
		room.append([])
		for y in range(RoomColumns):
			room[x].append(0)
	
	#Settings the rooms layout
	for i in range(RoomRows):
		for j in range(RoomColumns):
			room[i][j] = getPixelColour(i, j) #row and column
	
	#Spawning the walls acording to the rooms layout
	for i in range(RoomRows):
		for j in range(RoomColumns):
			if room[i][j] == 1: 
				spawnWall(i, j, roomNum, SceneRoomNumRow, SceneRoomNumColumn)
	
	roomNum = roomNum + 1
				
func getPixelColour(i :int, j :int) -> int:
	img.lock()
	var x = img.get_pixel(i, j)
	if x:
		return 0
	else:
		return 1

func spawnWall(Row :int, Column :int, roomNum :int, SceneRoomNumRow :int, SceneRoomNumColumn :int):
	var gridRow = Row * RoomGridSpacing
	var gridColumn = Column * RoomGridSpacing
	var roomSceneOffsetRow = SceneRoomNumRow * SceneGridSpacing
	var roomSceneOffsetColumn = SceneRoomNumColumn * SceneGridSpacing
	var wall = load("res://Wall.tscn")
	var iWall = wall.instance()
	add_child(iWall)
	iWall.position = Vector2(gridRow + roomSceneOffsetRow, gridColumn + roomSceneOffsetColumn)
