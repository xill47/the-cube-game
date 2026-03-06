extends Room


var test_chamber_puzzle: TestChamberPuzzle

func _ready() -> void:
	test_chamber_puzzle = TestChamberPuzzle.new([$Plate.state, $Plate2.state], $Door.state)

class TestChamberPuzzle:
	var plates: Array[PlateState]
	var door: DoorState
	
	@warning_ignore("shadowed_variable")
	func _init(plates: Array[PlateState], door: DoorState) -> void:
		self.plates = plates
		for plate: PlateState in plates:
			plate.changed.connect(_on_plate_changed)
		self.door = door
	
	func _on_plate_changed() -> void:
		var all_pressed = true
		for plate: PlateState in plates:
			all_pressed = plate.pressed and all_pressed
		if all_pressed:
			door.unlock()
