class_name DCPU16
extends Reference
# An emulator for the DCPU-16 processor.


var memory: PoolIntArray


func _init() -> void:
	memory = PoolIntArray()
	for _i in range(0, 0x10000):
		memory.append(0)

	memory[0x1c] = 0x40
	
	print("DCPU-16 emulator initialized.")


func op():
	var word := memory[memory[0x1c]]
	memory[0x1c] += 1
	memory[0x1c] %= 0x10000

	var opcode := word & 0x1f
	var b := (word >> 5) & 0x1f
	var a := (word >> 10) & 0x1f
	print("word: %x, op: %x, a: %x, b: %x" % [word, opcode, a, b])
