LOAD TEN
DIV MINUSTWO
ADD FIVE
JMPZ ISZERO
OUTPUT MINUSONE
STOP
ISZERO: LOAD TEN
DIV TWO
SUB FIVE
JMPZ ISZERO2
OUTPUT MINUSONE
STOP
ISZERO2: OUTPUT ONE
STOP
ONE: CONST 1
MINUSONE: CONST -1
TEN: CONST 10
TWO: CONST 2
MINUSTWO: CONST -2
FIVE: CONST 5