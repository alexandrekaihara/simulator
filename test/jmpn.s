LOAD MINUSONE
JMPN ISLESSZERO
OUTPUT MINUSONE
STOP
ISLESSZERO:
LOAD ONE
JMPN ISGREATERZERO
OUTPUT ONE
STOP
ISGREATERZERO:
OUTPUT MINUSONE
STOP
ONE: CONST 1
MINUSONE: CONST -1
