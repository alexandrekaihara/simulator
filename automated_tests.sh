#!/bin/bash

echo "Testing add"
./simulator test/add.out

echo "Testing sub"
./simulator test/sub.out

echo "Testing mult"
./simulator test/mult.out

echo "Testing div"
./simulator test/div.out

echo "Testing jmp"
./simulator test/jmp.out

echo "Testing jmpp"
./simulator test/jmpp.out

echo "Testing jmpn"
./simulator test/jmpn.out

echo "Testing jmpz"
./simulator test/jmpz.out

echo "Testing copy"
./simulator test/copy.out

echo "Testing input"
./simulator test/input.out

echo "Testing output"
./simulator test/output.out

echo "Testing load"
./simulator test/load.out

echo "Testing store"
./simulator test/store.out
