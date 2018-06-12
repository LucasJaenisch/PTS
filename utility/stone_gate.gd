extends StaticBody2D

onready var audio_player = $AudioStreamPlayer2D
onready var coll = $CollisionShape2D

onready var tile_map = get_parent().get_node("TileMap")

export var closed = true


func _ready():
	if tile_map != null:
		collision_layer = 0
		coll.disabled = true
	
	if closed:
		close()
	else:
		open()


func open():
	if tile_map != null:
		t_open()
		return
	collision_layer = 0
	coll.disabled = true
	audio_player.play()

func close():
	if tile_map != null:
		t_close()
		return
	collision_layer = 1
	coll.disabled = false
	audio_player.play()

func t_open():
	var pos = tile_map.world_to_map(global_position)
	tile_map.set_cellv(pos, -1)

func t_close():
	var pos = tile_map.world_to_map(global_position)
	tile_map.set_cellv(pos, 0)