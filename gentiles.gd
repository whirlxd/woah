@tool
extends EditorScript

const SHEET := "res://1bit 16px patterns and tiles.png"
const SAVE_AS := "res://art/tileset.tres"

# Define the tile grids (just size + separation now)
const GRIDS := [
	{
		"cell": Vector2i(16, 16),
		"sep":  Vector2i(2, 2)
	},
	{
		"cell": Vector2i(64, 64),  # or 48,48 if that matches
		"sep":  Vector2i(2, 2)
	}
]

func _run() -> void:
	var tex := load(SHEET)
	if tex == null:
		push_error("Could not load sheet at " + SHEET)
		return

	var tileset := TileSet.new()

	for g in GRIDS:
		var src := TileSetAtlasSource.new()
		src.texture = tex
		src.tile_size = g["cell"]
		src.separation = g["sep"]

		tileset.add_source(src)

		# auto-populate by scanning how many tiles fit horizontally/vertically
		var cols := int(tex.get_width() / g["cell"].x)
		var rows := int(tex.get_height() / g["cell"].y)

		for y in range(rows):
			for x in range(cols):
				src.create_tile(Vector2i(x, y))

	var ok := ResourceSaver.save(tileset, SAVE_AS)
	if ok == OK:
		print("TileSet saved to ", SAVE_AS)
	else:
		push_error("Failed to save TileSet: " + str(ok))
