extends Node2D
class_name Marker

enum MARKER_TYPE{
	NOSURE,
	EMPTY,
	LIGHTED,
}

@onready var no_sure_marker: Sprite2D = $NoSureMarker
@onready var empty_marker: Sprite2D = $EmptyMarker
@onready var lighted_marker: Sprite2D = $LightedMarker

var type:MARKER_TYPE:
	set(value):
		type = value
		for i in get_children():
			i.hide()
		match value:
			MARKER_TYPE.NOSURE: no_sure_marker.show()
			MARKER_TYPE.EMPTY: empty_marker.show()
			MARKER_TYPE.LIGHTED: lighted_marker.show()
