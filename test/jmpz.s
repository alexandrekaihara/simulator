LOAD ZERO
JMPZ ISZERO
OUTPUT MINUSONE
STOP
ISZERO: OUTPUT ONE
STOP
ZERO: CONST 0 
ONE: CONST 1
MINUSONE: CONST -1