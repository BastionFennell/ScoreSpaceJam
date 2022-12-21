extends Node

export (int) var radius = 200
var tile_size = 10
var rounded_radius = stepify(radius, tile_size)
var steps = floor(rounded_radius / tile_size)
var last_update_pos
var world
var player

var tilemap = [
	{ "img": preload("res://assets/sprites/tiles/tile 1.png"), "chance": 0.6},
	{ "img": preload("res://assets/sprites/tiles/tile 2.png"), "chance": 0.10},
	{ "img": preload("res://assets/sprites/tiles/tile 3.png"), "chance": 0.15},
	{ "img": preload("res://assets/sprites/tiles/tile 4.png"), "chance": 0.15},
	{ "img": preload("res://assets/sprites/tiles/tile 1.png"), "chance": 0.6},
]

var current_map = [[]]

func _ready():
	world = get_node("/root/Globals").get_main_node()
	_initialize()

func _get_tile():
	var rand = randf();

	for i in tilemap.size():
		var tile = tilemap[i]
		rand -= tile.chance
		if rand <= 0:
			return tile

func _initialize():
	player = world.get_node("Player")

	# center
	var c = Vector2(stepify(player.global_position.x, tile_size), stepify(player.global_position.y, tile_size))
	last_update_pos = c

	current_map.resize(steps * 2)
	for i in current_map.size():
		current_map[i] = []
		current_map[i].resize(steps * 2)

	for i in steps:
		for j in steps:
			var x = c.x - rounded_radius + i * tile_size
			var y = c.y - rounded_radius + j * tile_size
			current_map[i][j] = {"position": Vector2(x, y), "tile": _get_tile()}

	for i in steps:
		for j in steps:
			var x = c.x - rounded_radius + i * tile_size
			var y = c.y + j * tile_size
			current_map[i][j + steps] = {"position": Vector2(x, y), "tile": _get_tile()}

	for i in steps:
		for j in steps:
			var x = c.x + i * tile_size
			var y = c.y - rounded_radius + j * tile_size
			current_map[i + steps][j] = {"position": Vector2(x, y), "tile": _get_tile()}


	for i in steps:
		for j in steps:
			var x = c.x + i * tile_size
			var y = c.y + j * tile_size
			current_map[i + steps][j + steps] = {"position": Vector2(x, y), "tile": _get_tile()}

	_draw_tiles()

func _draw_tile(i, j):
	var node = current_map[i][j]
	var tile_sprite = Sprite.new()
	tile_sprite.texture = node.tile.img
	tile_sprite.position = node.position
	tile_sprite.z_index = -1000

	world.call_deferred("add_child", tile_sprite)
	current_map[i][j].node = tile_sprite

func _draw_tiles():
	for i in current_map.size():
		for j in current_map[i].size():
			_draw_tile(i, j)

func _generate_y(c, row):
	var y = c.y - rounded_radius + row * tile_size
	for i in steps * 2:
		var x = c.x + i * tile_size	- rounded_radius
		current_map[i][row] = {"position": Vector2(x, y), "tile": _get_tile()}
		_draw_tile(i, row);

func _generate_x(c, column):
	var x = c.x - rounded_radius + column * tile_size
	current_map[column] = []
	current_map[column].resize(steps * 2)
	for j in steps * 2:
		var y = c.y + j * tile_size	- rounded_radius
		current_map[column][j] = {"position": Vector2(x, y), "tile": _get_tile()}
		_draw_tile(column, j);

func _update_tiles(c):
	var size = current_map.size()
	if c.x <= last_update_pos.x - tile_size:
		for j in size:
			current_map[size - 1][j].node.queue_free()

		for i in size - 1:
			current_map[size - (i + 1)] = current_map[size - (i + 2)]
		
		_generate_x(c, 0)

	if c.x >= last_update_pos.x + tile_size:
		for j in size:
			current_map[0][j].node.queue_free()

		for i in size - 1:
			current_map[i] = current_map[i + 1]

		_generate_x(c, size - 1)

	if c.y <= last_update_pos.y - tile_size:
		for i in size:
			current_map[i][size - 1].node.queue_free()

		for i in size:
			for j in size - 1:
				current_map[i][size - (j + 1)] = current_map[i][size - (j + 2)]

		_generate_y(c, 0)

	if c.y >= last_update_pos.y + tile_size:
		for i in size:
			current_map[i][0].node.queue_free()

		for i in size:
			for j in size - 1:
				current_map[i][j] = current_map[i][j + 1]
		
		_generate_y(c, size - 1)


func _process(delta):
	# center
	var c = Vector2(stepify(player.global_position.x, tile_size), stepify(player.global_position.y, tile_size))
	if c.x <= last_update_pos.x - tile_size || c.x >= last_update_pos.x + tile_size || c.y <= last_update_pos.y - tile_size || c.y >= last_update_pos.y + tile_size:
		_update_tiles(c)
		last_update_pos = c
