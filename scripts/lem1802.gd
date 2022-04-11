class_name LEM1802
extends DCPUComponent
# LEM1802 - Low Energy Monitor


func _init() -> void:
    id = 0x7349f615
    version = 0x1802
    manufacturer = 0x1c6c8b36


func _interrupt() -> void:
    print("Interrupt received")
