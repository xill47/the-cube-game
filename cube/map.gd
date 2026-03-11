class_name Map
extends Node3D

#Refs to the Nodes.
@export var room_refs: Dictionary
#rooms can be int or string, however strings i think easier to remember and track.
@export var door_refs: Dictionary

var cur_room: AnimatedSprite3D


func room_changed(room: String, first_time: bool):
	var new_room = room_refs.get(room)
	if first_time:
		new_room.show()
	cur_room.get_child(0).hide()
	new_room.get_child(0).show()
	cur_room = new_room


func room_looted(room: String):
	var target_room: AnimatedSprite3D = room_refs.get(room)
	target_room.animation = "Looted"


#door can be int or string, whichever. States can be -{ unknown: 0, closed: 1, opened: 2}
func door_checked(door: int, state: int):
	var target_door: AnimatedSprite3D = door_refs.get(door)
	if state == 1:
		target_door.animation = "Closed"
	elif state == 2:
		target_door.animation = "Opened"
