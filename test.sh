#!/bin/bash

#==INPUT===
# s / p / e

TEST_DIR="testcases"
RESULTS_DIR="results/"
SCANNER_OUTPUT_FILE=$RESULTS_DIR"resultS.txt"
PARSER_OUTPUT_FILE=$RESULTS_DIR"resultP.txt"
PARSER_ERROR_OUTPUT_FILE=$RESULTS_DIR"resultPE.txt"
ERROR_PREFIX="err"
EXTENSION=".c"
NL=$'\n'

function makeScanner {
	make scanner
}

function runScanner {
	./scanner < $TEST_DIR/$1$EXTENSION
}

function runAllScanner {

	testResults="──── Date made: $(date) ────"$NL

	makeScanner
	for filePath in $TEST_DIR/*$EXTENSION; do

		testFile=$(basename -s $EXTENSION $filePath)

		testResults+=$"──── $testFile ────"$NL$NL
		testResults+=$(runScanner $testFile)
		testResults+=$NL$NL

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
	
	testResults="──── Date made: $(date) ────"$NL
	testResults+="TEST | OUTPUT LENGTH"$NL$NL

	outOk=0
	outEr=0

	makeParser
	for filePath in $TEST_DIR/*$EXTENSION; do

		testFile=$(basename -s $EXTENSION $filePath)
		
		# `2>&1` captures stdout to stderr
		out=$(runParser $testFile 2>&1)
		outLen=${#out}

		testResults+="$testFile: "$outLen$NL

		if [ $outLen -eq 0 ]; then
			outOk=$((outOk+1))
		else
			outEr=$((outEr+1))
		fi

	done

	testResults+=$NL"No output: "$outOk$NL
	testResults+="Has output: "$outEr

	tee $PARSER_OUTPUT_FILE <<< $testResults
}

function testAllParserErrors {
	
	testResults="──── Date made: $(date) ────"$NL
	testResults+="ERROR OUTPUT"$NL$NL

	makeParser
	for filePath in $TEST_DIR/$ERROR_PREFIX*$EXTENSION; do

		testFile=$(basename -s $EXTENSION $filePath)
			
		testResults+=$"──── $testFile ────"$NL$NL
		# `2>&1` captures stdout to stderr 
		# then cease stdout but keep stderr
		testResults+=$(runParser $testFile 2>&1 1> /dev/null)
		testResults+=$NL$NL

	done

	tee $PARSER_ERROR_OUTPUT_FILE <<< $testResults
}

function showHelpPrompt {
	echo "s: runAllScanner"$NL
	echo "p: testAllParser"$NL
	echo "e: testAllParserErrors"$NL
}

if [ ! -d $RESULTS_DIR ]; then
	mkdir $RESULTS_DIR
fi

if [ ${#@} -eq 0 ]; then
	showHelpPrompt

elif [ $@ = 's' ]; then
	runAllScanner

elif [ $@ = 'p' ]; then
	testAllParser

elif [ $@ = 'e' ]; then
	testAllParserErrors

else
	showHelpPrompt

fi
