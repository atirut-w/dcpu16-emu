class_name DCPU16
extends Reference
# An emulator for the DCPU-16 processor.


var memory: PoolIntArray


func _init() -> void:
	memory = PoolIntArray()
	for _i in range(0, 0x10000):
		memory.append(0)

	memory[0x1c] = 0x40 # Set PC to just after the special area.
	
	print("DCPU-16 emulator initialized.")


func op():
	var pc := memory[0x1c]
	var word := memory[pc] + (memory[pc] * 0x100)
	print("%04x" % word)
