extends Node2D

var img = preload("res://Rooms/TestRoom.png")
#test
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
	print("Scene centre room at ", SceneCentreRoom)
	var SceneRooms = []
	for x in range(SceneRows):
		SceneRooms.append([])
		for y in range(SceneColumns):
			SceneRooms[x].append(0)

	generateRoom(SceneCentreRoom[0], SceneCentreRoom[1])
	RoomsSpawned.append(SceneCentreRoom)
	addSurroundingRooms(SceneCentreRoom[0], SceneCentreRoom[1])

	while RoomsSpawned.size() != RoomAmount:
		RoomSpawner()
		#print(RoomsSpawned.size())
	
	print(RoomsSpawned)
	for i in range(RoomsSpawned.size()):
		generateEdges(RoomsSpawned[i][0], RoomsSpawned[i][1])
		#generateRoom(RoomsSpawned[i][0], RoomsSpawned[i][1])
		
		
func generateEdges(row :int, column :int):
	var upPos = [row-1, column]
	
	print("Current Room Pos ", "Row ", row," , ","Column ",column)
	print("Up Pos from Room ", upPos[0], upPos[1])
	var downPos = [row+1, column]
	var leftPos = [row, column-1] 
	var rightPos = [row, column+1]
	
	var up = true
	for i in range(RoomsSpawned.size()):
		if RoomsSpawned[i] == upPos:
			up = false
	var down = true
	for i in range(RoomsSpawned.size()):
		if RoomsSpawned[i] == downPos:
			down = false
	var left = true
	for i in range(RoomsSpawned.size()):
		if RoomsSpawned[i] == leftPos:
			left = false
	var right = true
	for i in range(RoomsSpawned.size()):
		if RoomsSpawned[i] == rightPos:
			right = false

	generateRoom(row,column,up,down,left,right)
	
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

func addSurroundingRooms(row :int, column :int):
	var up = [row-1, column]
	#print(up)
	if not checkIfExitsInArray(up[0],up[1], RoomList):
		RoomList.append(up)
		
	var down = [row+1, column]
	#print(down)
	if not checkIfExitsInArray(down[0],down[1], RoomList):
		RoomList.append(down)
		
	var left = [row, column-1]
	#print(left)
	if not checkIfExitsInArray(left[0],left[1], RoomList):
		RoomList.append(left)
		
	var right = [row, column+1]
	#print(right)
	if not checkIfExitsInArray(right[0],right[1], RoomList):
		RoomList.append(right)
	
func checkIfExitsInArray(row :int, column :int, array :Array) -> bool:
	for i in range(array.size()):
		if array[i] == [row, column]:
			return true
		else:
			return false
	return false
	
func generateRoom(SceneRoomNumRow :int, SceneRoomNumColumn :int, up :bool = false, down :bool = false, left :bool = false, right :bool = false):
	var room = []
	for x in range(RoomRows):
		room.append([])
		for y in range(RoomColumns):
			room[x].append(0)
	
	#Settings the rooms layout
	for i in range(RoomRows):
		for j in range(RoomColumns):
			room[i][j] = getPixelColour(i, j) #row and column
	
	if up:
		for j in range(RoomColumns):
			room[0][j] = 1
	if down:
		for j in range(RoomColumns):
			room[RoomRows-1][j] = 1
	if left:
		for i in range(RoomRows):
			room[i][0] = 1
	if right:
		for i in range(RoomRows):
			room[i][RoomColumns-1] = 1
	
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
	#iWall.position = Vector2(gridRow + roomSceneOffsetRow, gridColumn + roomSceneOffsetColumn)
	iWall.position = Vector2(gridColumn + roomSceneOffsetColumn, gridRow + roomSceneOffsetRow)
