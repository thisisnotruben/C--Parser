# C--Parser

## Authors

* Ruben Alvarez Reyes
	* rubenreyes@email.arizona.edu

* Samuel Glenn Bryant
	* sbryant1@email.arizona.edu

## Description

* Flex 2.6.4.
* Bison 3.0.4.

## TODO

Function grammar rules need work as I got stuck there, though it seems like most of the other rules 
from b-- translated well. Rules need to be cross checked as well as it will be late when I push 
this and undoubtedly I probably made some errors. Let me know if you have any questions.

## Test Usage for Flex

Switch `DEBUG_LEX` to `1` in [parse.l](parse.l)

```bash
# to run specific test in 'testcases/'
./test.sh $testFile

# to run all tests and output to 'resultS.txt'
./test.sh s
```

## Test Usage for Bison

Switch `DEBUG_LEX` to `0` in [parse.l](parse.l)

Switch `YDEBUG` to `1` in [parse.y](parse.y) for debug output or `0` to cease all output

```bash
# to run all tests and output to 'resultP.txt'
./test.sh p
```

## Test Usage

```bash
# Makefile targets: parse, scanner, clean, $testFile
make $testFile
```
