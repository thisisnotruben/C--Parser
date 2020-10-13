TESTDIR=testcases

TESTS=	test01 test02 test03 test04 test05 test06 test07 test08 test09 \
		test10 test11 test12 test13 test14 test15 test16 test17 test18 \
		test19 test20 test21 test22 test23 test24 test25 test26 test27 \
		test28 test29 test30 test31 test32 test33 test34 test35 test36 \
		test37 test38 test39 test40 test41 test42 test43 test44 test45 \
		test46 test47 test48 test49 test50

ERRS=	err01 err02 err03 err04 err05 err06 err07 err08 err09 err10 \
		err11 err12 err13 err14 err15 err16 err17 err18 err19 err20 \
		err21 err22 err23 err24

parse:	parse.l parse.y
	lex parse.l
	yacc -dv parse.y
	gcc -o parse lex.yy.c y.tab.c

scanner:	parse.l parse.y
	lex parse.l
	yacc -dv parse.y
	gcc -o scanner lex.yy.c y.tab.h

clean:
	rm lex.yy.c y.output y.tab.c y.tab.h parse scanner

$(TESTS): parse
	./parse < $(TESTDIR)/$@.c
$(ERRS): parse
	./parse < $(TESTDIR)/$@.c
