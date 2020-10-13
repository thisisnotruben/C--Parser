%{

#include "y.tab.h"

int input_line_nbr = 1, lex_state = 0;

#define DEBUG_LEX 0

#define DEBUG_PRINT(x, y) \
    if (DEBUG_LEX) \
        printf("%-10d%-10s%-10s ln: %d\n", y, x, yytext, input_line_nbr)

#ifndef DEBUG_LEX
    #undef DEBUG_PRINT(x, y)
    #define DEBUG_PRINT(x, y)
#endif // DEBUG_LEX

%}

letter              [A-Za-z]
digit               [0-9]
whitespace          [ \t]
ch                  [ -]
alfanum             [A-Za-z0-9_]
eol                 \n
anything            .
id                  {letter}{alfanum}*
charcon             '({ch}|\\n|\\0)'
intcon              {digit}+
stringcon           \"({ch}|\n)[^\"]+\"

%s COMMENT STRING
%option noyywrap

%%
<INITIAL>{

    "/*"            { BEGIN(COMMENT); yymore(); }
    \"              { BEGIN(STRING); yymore(); }

    "=="            { DEBUG_PRINT("EQUALS", EQUALS); return EQUALS; }
    "!="            { DEBUG_PRINT("NOTEQU", NOTEQU); return NOTEQU; }
    ">="            { DEBUG_PRINT("GREEQU", GREEQU); return GREEQU; }
    "<="            { DEBUG_PRINT("LESEQU", LESEQU); return LESEQU; }
    ">"             { DEBUG_PRINT("GREATE", GREATE); return GREATE; }
    "<"             { DEBUG_PRINT("LESSTH", LESSTH); return LESSTH; }
    "&&"            { DEBUG_PRINT("ANDCOM", ANDCOM); return ANDCOM; }
    "||"            { DEBUG_PRINT("ORCOMP", ORCOMP); return ORCOMP; }
    ";"             { DEBUG_PRINT("SEMIC", SEMIC); return SEMIC; }
    ","             { DEBUG_PRINT("COMMA", COMMA); return COMMA; }
    "("             { DEBUG_PRINT("LPARN", LPARN); return LPARN; }
    ")"             { DEBUG_PRINT("RPARN", RPARN); return RPARN; }
    "["             { DEBUG_PRINT("LBRAC", LBRAC); return LBRAC; }
    "]"             { DEBUG_PRINT("RBRAC", RBRAC); return RBRAC; }
    "{"             { DEBUG_PRINT("LCURL", LCURL); return LCURL; }
    "}"             { DEBUG_PRINT("RCURL", RCURL); return RCURL; }
    "!"             { DEBUG_PRINT("ABANG", ABANG); return ABANG; }
    "="             { DEBUG_PRINT("EQUAL", EQUAL); return EQUAL; }
    "+"             { DEBUG_PRINT("ADD", ADD); return ADD; }
    "-"             { DEBUG_PRINT("SUB", SUB); return SUB; }
    "*"             { DEBUG_PRINT("MUL", MUL); return MUL; }
    "/"             { DEBUG_PRINT("DIV", DIV); return DIV; }
    "for"           { DEBUG_PRINT("FOR", FOR); return FOR; }
    "if"            { DEBUG_PRINT("IF", IF); return IF; }
    "else"          { DEBUG_PRINT("ELSE", ELSE); return ELSE; }
    "while"         { DEBUG_PRINT("WHILE", WHILE); return WHILE; }
    "return"        { DEBUG_PRINT("RETURN", RETURN); return RETURN; }
    "void"          { DEBUG_PRINT("VOID", VOID); return VOID; }
    "int"           { DEBUG_PRINT("INT", INT); return INT; }
    "char"          { DEBUG_PRINT("CHAR", CHAR); return CHAR; }
	"extern"        { DEBUG_PRINT("EXTERN", EXTERN); return EXTERN; }
    {intcon}        { DEBUG_PRINT("INTCON", INTCON); return INTCON; }
    {charcon}       { DEBUG_PRINT("CHARCON", CHARCON); return CHARCON; }
    {id}            { DEBUG_PRINT("ID", ID); return ID; }
    {whitespace}    { ; }
    {eol}           { input_line_nbr++; }
    {anything}      { DEBUG_PRINT("ANYTHING", -1); return OTHER; }

}

<STRING>{

    \"              { DEBUG_PRINT("STRINGCON", STRINGCON); BEGIN(INITIAL); return STRINGCON; }
    [^\"\n]         { yymore(); }
}
<COMMENT>{

    "*/"            { DEBUG_PRINT("COMMENT", COMMENTCON); BEGIN(INITIAL); }
    {eol}           { yymore(); input_line_nbr++; }
    {anything}      { yymore(); }

}

%%
#if DEBUG_LEX
    int main(int argc, char **argv)
    {
        while (yylex() != 0);
        return 0;
    }
#endif
