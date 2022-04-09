    SET A, 0
    SET B, 1
:loop
    SET C, A
    ADD C, B
    SET A, B
    SET B, C
    SET PC, loop