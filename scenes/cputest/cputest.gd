extends Control


var _cpu: DCPU16
var _running := false


func _ready() -> void:
	_cpu = DCPU16.new()


func _physics_process(_delta: float):
	if _running == true:
		_cpu.op()


func _on_Button_pressed():
	var filediag := FileDialog.new()
	filediag.mode = FileDialog.MODE_OPEN_FILE
	filediag.access = FileDialog.ACCESS_FILESYSTEM
	add_child(filediag)
	filediag.popup_centered_minsize(Vector2(800, 500))
	var path = yield(filediag, "file_selected")
	
	var file := File.new()
	if file.open(path, File.READ) != OK:
		return
	var program := file.get_buffer(file.get_len())
	file.close()
	
	for i in program.size():
		_cpu.memory[0x40 + i] = program[i]
	
	print("Program loaded")


func _on_Button2_pressed():
	_running = true


func _on_Button3_pressed():
	_running = false
