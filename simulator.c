#include <stdio.h>

int main(int argc, char *argv[]){
    if(argc == 2){
        int length = 0;
        for (; argv[1][length] != '\0'; length++){}
        extern void simulator(char* filename, int length);
        simulator(argv[1], length);
    }
    else return -1;
    return 0;
}