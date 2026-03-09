class_name SudokuTile
extends Sprite3D

var target
var cube_basis
var starting_basis

func _ready() -> void:
	starting_basis = basis

func sudoku_opened(cube):
	if cube.basis == Basis(Vector3.DOWN,Vector3.RIGHT,Vector3.BACK):
		basis = Basis(Vector3.UP,Vector3.LEFT,Vector3.BACK)
		print("rotate")
	elif cube.basis == Basis(Vector3.UP,Vector3.LEFT,Vector3.BACK):
		basis = Basis(Vector3.DOWN,Vector3.RIGHT,Vector3.BACK)
		print("rotate")
	elif cube.basis == Basis(Vector3.LEFT,Vector3.DOWN,Vector3.BACK):
		basis = Basis(Vector3.LEFT,Vector3.DOWN,Vector3.BACK)
		print("rotate")
	elif cube.basis == Basis.IDENTITY:
		basis = Basis.IDENTITY

#I need help, i am so close
#func sudoku_opened(cube, rotate_direction):
#	var rotation_amount = cube.basis.get_rotation_quaternion()
#	basis = Basis.IDENTITY.rotated(rotate_direction, rotation_amount.get_angle())
