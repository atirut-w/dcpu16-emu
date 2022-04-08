class_name DCPU16
extends Reference
# An emulator for the DCPU-16 processor.


var memory: PoolIntArray


func _init() -> void:
	memory = PoolIntArray()
	for _i in range(0, 0x10000):
		memory.append(0)
	_reset()
	
	print("DCPU-16 emulator initialized.")


func _reset() -> void:
	for i in range(0x00, 0x08):
		memory[i] = 0

	for i in range(0x20, 0xf0):
		memory[i] = (i - 0x20) - 1

	memory[0x1c] = 0x40


func _update_special_regs() -> void:
	var pc := memory[0x1c]

	memory[0x1e] = memory[memory[pc + 1]]
	memory[0x1f] = memory[pc + 1]


func op():
	_update_special_regs()
	var word := memory[memory[0x1c]]
	memory[0x1c] += 1
	memory[0x1c] &= 0xffff

	var opcode := word & 0x1f
	var b := (word >> 5) & 0x1f
	var a := (word >> 10) & 0x3f

	if a == 0x1f:
		memory[0x1c] += 1
	
	match opcode:
		0x01:
			memory[b] = memory[a]
		_:
			push_error("Unknown opcode: 0x%x" % opcode)
