#!/bin/bash

#=====INPUT=====
# testfile / s / p

TEST_DIR="testcases"
SCANNER_OUTPUT_FILE="resultS.txt"
PARSER_OUTPUT_FILE="resultP.txt"
EXTENSION=".c"
NEW_LINE=$'\n'

function makeScanner {
	make scanner
}

function runScanner {
	./scanner < $TEST_DIR/$1$EXTENSION
}

function runAllScanner {

	testResults="──── Date made: $(date) ────"$NEW_LINE

	makeScanner
	for filePath in $TEST_DIR/*$EXTENSION; do

		testFile=$(basename -s $EXTENSION $filePath)

		testResults+=$"──── $testFile ────"$NEW_LINE$NEW_LINE
		testResults+=$(runScanner $testFile)
		testResults+=$NEW_LINE$NEW_LINE

	done
	tee $SCANNER_OUTPUT_FILE <<< $testResults > /dev/null
}

function makeParser {
	make parse
}

function runParser {
	./parse < $TEST_DIR/$1$EXTENSION
}

function testAllParser {
	
	testResults="──── Date made: $(date) ────"$NEW_LINE
	testResults+="TEST  | OUTPUT LENGTH"$NEW_LINE$NEW_LINE

	outOk=0
	outEr=0

	makeParser
	for filePath in $TEST_DIR/*$EXTENSION; do

		testFile=$(basename -s $EXTENSION $filePath)
		
		# `2>&1` captures stdout & stderr
		out=$(runParser $testFile 2>&1)
		outLen=${#out}

		testResults+="$testFile: "$outLen$NEW_LINE

		if [ $outLen -eq 0 ]; then
			outOk=$((outOk+1))
		else
			outEr=$((outEr+1))
		fi

	done

	testResults+=$NEW_LINE"No output: "$outOk$NEW_LINE
	testResults+="Has output: "$outEr
	
	tee $PARSER_OUTPUT_FILE <<< $testResults
}

if [ $@ = 's' ]; then
	runAllScanner

elif [ $@ = 'p' ]; then
	testAllParser

else
	makeScanner
	runScanner $@
fi
