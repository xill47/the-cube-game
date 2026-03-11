class_name SudokuTile
extends Sprite3D

func sudoku_opened(cube: MeshInstance3D):
	if cube.basis.is_equal_approx(Basis(Vector3.DOWN,Vector3.RIGHT,Vector3.BACK)):
		basis = Basis(Vector3.UP,Vector3.LEFT,Vector3.BACK)
		print("rotate")
	elif cube.basis.is_equal_approx(Basis(Vector3.UP,Vector3.LEFT,Vector3.BACK)):
		basis = Basis(Vector3.DOWN,Vector3.RIGHT,Vector3.BACK)
		print("rotate")
	elif cube.basis.is_equal_approx(Basis(Vector3.LEFT,Vector3.DOWN,Vector3.BACK)):
		basis = Basis(Vector3.LEFT,Vector3.DOWN,Vector3.BACK)
		print("rotate")
	elif cube.basis.is_equal_approx(Basis.IDENTITY):
		basis = Basis.IDENTITY
