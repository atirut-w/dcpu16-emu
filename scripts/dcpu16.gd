class_name DCPU16
extends Reference
# An emulator for the DCPU-16 processor.


var memory: PoolIntArray


func _init() -> void:
	memory = PoolIntArray()
	for _i in range(0, 0x10000):
		memory.append(0)
	reset()
	
	print("DCPU-16 emulator initialized.")


func reset() -> void:
	for i in range(0x00, 0x08):
		memory[i] = 0

	for i in range(0x20, 0x40):
		memory[i] = _unsign((i - 0x20) - 1)

	memory[0x1c] = 0


func _update_special_regs() -> void:
	var pc := memory[0x1c]

	memory[0x1e] = memory[memory[0x40 + pc + 1]]
	memory[0x1f] = memory[0x40 + pc + 1]


func _unsign(x: int) -> int:
	if x < 0:
		return x + 0x10000
	else:
		return x


func _sign(x: int) -> int:
	if x > 0x7fff:
		return x - 0x10000
	else:
		return x


func op():
	_update_special_regs()
	var word := memory[0x40 + memory[0x1c]]
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
		0x02:
			memory[b] += memory[a]
			if memory[b] > 0xffff:
				memory[b] &= 0xffff
				memory[0x1d] = 0x0001
			else:
				memory[0x1d] = 0x0
		0x03:
			memory[b] -= memory[a]
			if memory[b] < 0:
				memory[b] += 0x10000
				memory[0x1d] = 0xffff
			else:
				memory[0x1d] = 0x0
		0x04:
			memory[b] *= memory[a]
			memory[b] &= 0xffff
			memory[0x1d] = ((memory[b] * memory[a]) >> 16) & 0xffff
		0x05:
			memory[b] = _unsign(_sign(memory[b]) * _sign(memory[a]))
			memory[b] &= 0xffff
			memory[0x1d] = ((memory[b] * memory[a]) >> 16) & 0xffff
		0x06:
			if a != 0:
				memory[b] /= memory[a]
				memory[0x1d] = ((memory[b] << 16) / memory[a]) & 0xffff
			else:
				memory[b] = 0
				memory[0x1d] = 0
		0x07:
			if a != 0:
				memory[b] = _unsign(_sign(memory[b]) / _sign(memory[a]))
				memory[b] &= 0xffff
				memory[0x1d] = ((memory[b] << 16) / memory[a]) & 0xffff
			else:
				memory[b] = 0
				memory[0x1d] = 0
		_:
			push_error("Unknown opcode: 0x%x" % opcode)
