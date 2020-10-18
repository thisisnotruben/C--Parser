# C--Parser

## Authors

* Ruben Alvarez Reyes
	* rubenreyes@email.arizona.edu

* Samuel Glenn Bryant
	* sbryant1@email.arizona.edu

## Description

* Flex 2.6.4.
* Bison 3.0.4.

## Test Usage for Flex

Switch `DEBUG_LEX` to `1` in [parse.l](parse.l)

```bash
# to run all tests and output to 'results/resultS.txt'
./test.sh s
```

## Test Usage for Bison

Switch `DEBUG_LEX` to `0` in [parse.l](parse.l)

Switch `YDEBUG` to `1` in [parse.y](parse.y) for debug output or `0` to cease all output

```bash
# to run all tests and output to 'results/resultP.txt'
./test.sh p

# to run all error tests and output errors to 'results/resultPE.txt'
./test.sh e
```

## Test Usage

```bash
# Makefile targets: parse, scanner, clean, $testFile
make $testFile
```
