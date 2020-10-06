extends Node2D

onready var tm = $TileMap

var img1 = preload("res://Rooms/TestRoom.png")
var img2 = preload("res://Rooms/TestRoom2.png")
var imgList = [img1, img2]
var chosenImg

var SceneRows = 9
var SceneColumns = 9
var SceneGridSpacing = 8 #half of the rooms size

#Room Size
var RoomRows = 8
var RoomColumns = 8

var RoomAmount = 16
var RoomList = []
var RoomsSpawned = []

var SceneCentreRoom
var startRoomSpawned = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SceneCentreRoom = [SceneRows/2, SceneColumns/2]
	#print("Scene centre room at ", SceneCentreRoom)
	var SceneRooms = []
	for x in range(SceneRows):
		SceneRooms.append([])
		for y in range(SceneColumns):
			SceneRooms[x].append(0)
	
	generateRoom(SceneCentreRoom[0], SceneCentreRoom[1])
	RoomsSpawned.append(SceneCentreRoom)
	addSurroundingRooms(SceneCentreRoom[0], SceneCentreRoom[1])

	while RoomsSpawned.size() != RoomAmount:
		PickNextRoomPos()
	
	for i in range(RoomsSpawned.size()):
		generateEdges(RoomsSpawned[i][0], RoomsSpawned[i][1])
		
	tm.update_bitmask_region(Vector2.ZERO, Vector2(200,200))
	
func generateEdges(row :int, column :int):
	var upPos = [row-1, column]
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
	
#This function randomly selects a room from the available slots and adds it to the list
func PickNextRoomPos():
	randomize()
	var randNum = int(rand_range(0,RoomList.size()))
	
	for i in range(RoomsSpawned.size()):
		if RoomList[randNum] == RoomsSpawned[i]:
			return
				
	RoomsSpawned.append([RoomList[randNum][0], RoomList[randNum][1]])

	for i in range(RoomsSpawned.size()):
		addSurroundingRooms(RoomsSpawned[i][0], RoomsSpawned[i][1])

func addSurroundingRooms(row :int, column :int):
	var up = [row-1, column]

	if not checkIfExitsInArray(up):
		RoomList.append(up)
		
	var down = [row+1, column]
	if not checkIfExitsInArray(down):
		RoomList.append(down)
		
	var left = [row, column-1]
	if not checkIfExitsInArray(left):
		RoomList.append(left)
		
	var right = [row, column+1]
	if not checkIfExitsInArray(right):
		RoomList.append(right)
	
func checkIfExitsInArray(pos) -> bool:
	for i in range(RoomList.size()):
		if RoomList[i] == pos:
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
	
	if not startRoomSpawned:
		chosenImg = imgList[0]
		startRoomSpawned = true
	else:
		randomize()
		var randImg = int(rand_range(0,imgList.size()))
		chosenImg = imgList[randImg]
	
	#Settings the rooms layout based on colours returned from image
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
				setTile(i, j, SceneRoomNumRow, SceneRoomNumColumn, 0) #Walls
			elif room[i][j] == 0: 
				setTile(i, j, SceneRoomNumRow, SceneRoomNumColumn, 1) #floor
func getPixelColour(i :int, j :int) -> int:
	chosenImg.lock()
	var x = chosenImg.get_pixel(i, j)
	match x:
		Color(0,0,0,1): #wall
			return 1
	
	return 0 #nothing floor

func setTile(Row :int, Column :int, SceneRoomNumRow :int, SceneRoomNumColumn :int, tile_index :int):
	var roomSceneOffsetRow = SceneRoomNumRow * SceneGridSpacing
	var roomSceneOffsetColumn = SceneRoomNumColumn * SceneGridSpacing

	var offset = Vector2(Row + roomSceneOffsetRow, Column + roomSceneOffsetColumn)
	tm.set_cellv(offset,tile_index)
	
