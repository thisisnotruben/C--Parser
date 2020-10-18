%{

#include <stdio.h>

#define YDEBUG 0

#define Y_DEBUG_PRINT(x, y) \
    if (YDEBUG) \
        printf("%-30s%-30s ln: %d\n", x, y, input_line_nbr)

#ifndef YDEBUG
    #undef Y_DEBUG_PRINT(x)
    #define Y_DEBUG_PRINT(x)
#endif // YDEBUG

void yyerror(char const *);
void warn(char const *s);

extern int yylex(void);
extern char the_token[];
extern int input_line_nbr;
extern char *full_line;
extern int lex_state;

%}

%token STRINGCON CHARCON INTCON EQUALS NOTEQU GREEQU LESEQU GREATE LESSTH COMMENTCON
%token ANDCOM ORCOMP SEMIC COMMA LPARN RPARN LBRAC RBRAC LCURL RCURL ABANG
%token EQUAL ADD SUB MUL DIV ID EXTERN FOR WHILE RETURN IF ELSE
%token VOID CHAR INT OTHER

%nonassoc PREC_LOWER_THAN_ELSE
%nonassoc ELSE
%nonassoc PREC_LOGOP
%nonassoc PREC_RELOP
%nonassoc PREC_BINOP
%nonassoc PREC_ERROR

%left ORCOMP
%left ANDCOM
%left EQUALS NOTEQU
%left LESSTH LESEQU GREATE GREEQU
%left ADD SUB
%left MUL DIV
%right UMINUS
%right ABANG

%%

Prog
    :                                           { Y_DEBUG_PRINT("Prog-1", "Empty"); }
    | ProgEitherList                            { Y_DEBUG_PRINT("Prog-2", "ProgEitherList"); }
    ;

ProgEitherList
    : ProgEither                                { Y_DEBUG_PRINT("ProgEitherList-1", "ProgEither"); }
    | ProgEitherList ProgEither                 { Y_DEBUG_PRINT("ProgEitherList-2", "ProgEitherList ProgEither"); }
    ;

ProgEither
    : DclSemic                                  { Y_DEBUG_PRINT("ProgEither-1", "DclSemic"); }
    | Function                                  { Y_DEBUG_PRINT("ProgEither-2", "Function"); }
    ;

DclSemic
    : Dcl SEMIC                                 { Y_DEBUG_PRINT("DclSemic", "Dcl SEMIC"); }
    | Dcl error                                 { warn(": missing SEMIC"); }
    | error                                     { warn(": missing COMMA"); }
    ;

Dcl
    : Type VarDeclList                          { Y_DEBUG_PRINT("Dcl-1", "Type VarDeclList"); }
    | Type DclIdRep                             { Y_DEBUG_PRINT("Dcl-2", "Type DclIdRep"); }
    | VOID DclIdRep                             { Y_DEBUG_PRINT("Dcl-3", "VOID DclIdRep"); }
    | DclIdRep                                  { Y_DEBUG_PRINT("Dcl-4", "DclIdRep"); }
    | EXTERN Type DclIdRep                      { Y_DEBUG_PRINT("Dcl-5", "EXTERN Type DclIdRep"); }
    | EXTERN VOID DclIdRep                      { Y_DEBUG_PRINT("Dcl-6", "EXTERN VOID DclIdRep"); }
    | EXTERN DclIdRep                           { Y_DEBUG_PRINT("Dcl-7", "EXTERN DclIdRep"); }
    ;

VarDecl
    : ID                                        { Y_DEBUG_PRINT("VarDecl-1", "ID"); }
    | ID LBRAC INTCON RBRAC                     { Y_DEBUG_PRINT("VarDecl-2", "ID LBRAC INTCON RBRAC"); }
    | ID LBRAC error                            { warn(": missing RBRAC"); }
    | ID RBRAC                                  { yyerror(": missing LBRAC\n"); }
    ;

Type
    : CHAR                                      { Y_DEBUG_PRINT("Type-1", "CHAR"); }
    | INT                                       { Y_DEBUG_PRINT("Type-2", "INT"); }
    ;

VarDeclList
    : VarDecl                                   { Y_DEBUG_PRINT("VarDeclList-1", "VarDecl"); }
    | VarDeclList COMMA VarDecl                 { Y_DEBUG_PRINT("VarDeclList-2", "VarDeclList COMMA VarDecl"); }
    ;

DclIdRep
    : DclId                                     { Y_DEBUG_PRINT("DclIdRep-1", "DclId"); }
    | DclIdRep COMMA DclId                      { Y_DEBUG_PRINT("DclIdRep-2", "DclIdRep COMMA DclId"); }
    ;

DclId
    : ID LPARN ParamTypes RPARN                 { Y_DEBUG_PRINT("DclId-1", "ID LPARN ParamTypes RPARN"); }
    | ID LPARN error RPARN                      { warn(": missing ParamTypes"); }
    ;

ParamTypes
    : VOID                                      { Y_DEBUG_PRINT("ParamTypes-1", "VOID"); }
    | ParamDclRep                               { Y_DEBUG_PRINT("ParamTypes-2", "ParamDclRep"); }
    ;

ParamDclRep
    : ParamDcl                                  { Y_DEBUG_PRINT("ParamDclRep-1", "ParamDcl"); }
    | ParamDclRep COMMA ParamDcl                { Y_DEBUG_PRINT("ParamDclRep-2", "ParamDclRep COMMA ParamDcl"); }
    ;

ParamDcl
    : Type ID ParamDclBraceOpt                  { Y_DEBUG_PRINT("ParamDcl-1", "Type ID ParamDclBraceOpt"); }
    ;

ParamDclBraceOpt
    :                                           { Y_DEBUG_PRINT("ParamDclBraceOpt-1", "Empty"); }
    | LBRAC RBRAC                               { Y_DEBUG_PRINT("ParamDclBraceOpt-2", "LBRAC RBRAC"); }
    | LBRAC                                     { yyerror(": missing RBRAC\n"); }
    ;

Function
    : FunctionHead FunctionBody                 { Y_DEBUG_PRINT("Function-1", "FunctionHead FunctionBody"); }
    ;

FunctionHead
    : DclId                                     { Y_DEBUG_PRINT("FunctionHead-1", "DclId"); }
    | Type DclId                                { Y_DEBUG_PRINT("FunctionHead-2", "Type DclId"); }
    | VOID DclId                                { Y_DEBUG_PRINT("FunctionHead-3", "VOID DclId"); }
    ;

FunctionBody
    : LCURL FunctionEitherListOpt RCURL         { Y_DEBUG_PRINT("FunctionBody-1", "LCURL FunctionEitherListOpt RCURL"); }
    | RCURL                                     { yyerror(": missing LCURL\n"); }
    | LCURL error                               { warn(": missing RCURL"); }
    ;

FunctionEitherListOpt
    :                                           { Y_DEBUG_PRINT("FunctionEitherListOpt-1", "Empty"); }
    | FunctionEitherList                        { Y_DEBUG_PRINT("FunctionEitherListOpt-2", "FunctionEitherList"); }
    ;

FunctionEitherList
    : FunctionEither                            { Y_DEBUG_PRINT("FunctionEitherList-1", "FunctionEither"); }
    | FunctionEitherList FunctionEither         { Y_DEBUG_PRINT("FunctionEitherList-2", "FunctionEitherList FunctionEither"); }
    ;

FunctionEither
    : DclSemic                                  { Y_DEBUG_PRINT("FunctionEither-1", "DclSemic"); }
    | Stmt                                      { Y_DEBUG_PRINT("FunctionEither-2", "Stmt"); }
    ;

/* imported from B-- below */

Stmt
    : IF LPARN Expr RPARN Stmt %prec PREC_LOWER_THAN_ELSE                           { Y_DEBUG_PRINT("Stmt-1", "IF LPARN Expr RPARN Stmt"); }
    | IF LPARN Expr RPARN Stmt ELSE Stmt                                            { Y_DEBUG_PRINT("Stmt-2", "IF LPARN Expr RPARN Stmt ELSE Stmt"); }
    | IF error                                                                      { warn(": malformed if"); }
    | WHILE LPARN Expr RPARN Stmt                                                   { Y_DEBUG_PRINT("Stmt-3", "WHILE LPARN Expr RPARN Stmt"); }
    | FOR LPARN StmtForAssign SEMIC StmtOptExpr SEMIC StmtForAssign RPARN Stmt      { Y_DEBUG_PRINT("Stmt-4", "FOR LPARN StmtForAssign SEMIC StmtOptExpr SEMIC StmtForAssign RPARN Stmt"); }
    | FOR LPARN error RPARN Stmt                                                    { warn(": malformed for-loop"); }
    | RETURN StmtOptExpr SEMIC                                                      { Y_DEBUG_PRINT("Stmt-5", "RETURN StmtOptExpr SEMIC"); }
    | Assign SEMIC                                                                  { Y_DEBUG_PRINT("Stmt-6", "Assign SEMIC"); }
    | Assign error                                                                  { warn(": missing SEMIC"); } /* Intoduced 1 conflicts at `Expr: ID . ExprId` */
    | ID LPARN StmtId RPARN SEMIC                                                   { Y_DEBUG_PRINT("Stmt-7", "ID LPARN StmtId RPARN SEMIC"); }
    | ID LPARN StmtId RPARN error                                                   { warn(": missing SEMIC"); }
    | LCURL StmtListOpt RCURL                                                       { Y_DEBUG_PRINT("Stmt-8", "LCURL StmtListOpt RCURL"); }
    /*| LCURL StmtListOpt RCURL                                                     { warn(": missing LCURL"); } */
    | SEMIC                                                                         { Y_DEBUG_PRINT("Stmt-9", "SEMIC"); }
    ;

StmtListOpt
    :                                       { Y_DEBUG_PRINT("StmtListOpt-1", "Empty"); }
    | StmtList                              { Y_DEBUG_PRINT("StmtListOpt-2", "StmtList"); }
    ;

Assign
    : ID Assign1 EQUAL Expr                 { Y_DEBUG_PRINT("Assign", "ID Assign1 EQUAL Expr"); }
    ;

Expr
    : SUB Expr %prec UMINUS                 { Y_DEBUG_PRINT("Expr-1", "UMINUS Expr"); }
    | ABANG Expr                            { Y_DEBUG_PRINT("Expr-2", "ABANG Expr"); }
    | Expr Logop Expr %prec PREC_LOGOP      { Y_DEBUG_PRINT("Expr-3", "Expr Logop Expr"); }
    | Expr Relop Expr %prec PREC_RELOP      { Y_DEBUG_PRINT("Expr-4", "Expr Relop Expr"); }
    | Expr Binop Expr %prec PREC_BINOP      { Y_DEBUG_PRINT("Expr-5", "Expr Binop Expr"); }
  /*| Expr Expr %prec PREC_ERROR            { warn(": missing operator"); } */
    | ID ExprId                             { Y_DEBUG_PRINT("Expr-6", "ID ExprId"); }
    | LPARN Expr RPARN                      { Y_DEBUG_PRINT("Expr-7", "LPARN Expr RPARN");}
    | INTCON                                { Y_DEBUG_PRINT("Expr-8", "INTCON"); }
    | CHARCON                               { Y_DEBUG_PRINT("Expr-9", "CHARCON"); }
    | STRINGCON                             { Y_DEBUG_PRINT("Expr-10", "STRINGCON"); }
    | error                                 { warn(": invalid expression "); }
    ;

Binop
    : ADD                   { Y_DEBUG_PRINT("Binop-1", "ADD"); }
    | SUB                   { Y_DEBUG_PRINT("Binop-2", "SUB"); }
    | MUL                   { Y_DEBUG_PRINT("Binop-3", "MUL"); }
    | DIV                   { Y_DEBUG_PRINT("Binop-4", "DIV"); }
    ;

Relop
    : EQUALS                { Y_DEBUG_PRINT("Relop-1", "EQUALS"); }
    | NOTEQU                { Y_DEBUG_PRINT("Relop-2", "NOTEQU"); }
    | LESEQU                { Y_DEBUG_PRINT("Relop-3", "LESEQU"); }
    | LESSTH                { Y_DEBUG_PRINT("Relop-6", "LESSTH"); }
    | GREEQU                { Y_DEBUG_PRINT("Relop-4", "GREEQU"); }
    | GREATE                { Y_DEBUG_PRINT("Relop-5", "GREATE"); }
    ;

Logop
    : ANDCOM                { Y_DEBUG_PRINT("Logop-1", "ANDCOM"); }
    | ORCOMP                { Y_DEBUG_PRINT("Logop-2", "ORCOMP"); }
    ;

/* util bodies below from the imported B-- */

StmtForAssign
    :
    | Assign                { Y_DEBUG_PRINT("StmtForAssign-1", "Assign"); }
    ;

StmtOptExpr
    :
    | Expr                  { Y_DEBUG_PRINT("StmtOptExpr-1", "Expr"); }
    ;

StmtId
    :                       { Y_DEBUG_PRINT("StmtId-1", "Empty"); }
    | ExprList              { Y_DEBUG_PRINT("StmtId-2", "ExprList"); }
    ;

StmtList
    : Stmt                   { Y_DEBUG_PRINT("StmtList-1", "Stmt"); }
    | StmtList Stmt          { Y_DEBUG_PRINT("StmtList-2", "StmtList Stmt"); }
    ;

Assign1
    :                       { Y_DEBUG_PRINT("Assign1-1", "Empty"); }
    | LBRAC Expr RBRAC      { Y_DEBUG_PRINT("Assign1-2", "LBRAC Expr RBRAC"); }
    | error RBRAC           { warn(": missing LBRAC"); }
    ;

ExprId
    :                       { Y_DEBUG_PRINT("ExprId-1", "Empty"); }
    | LPARN StmtId RPARN    { Y_DEBUG_PRINT("ExprId-2", "LPARN StmtId RPARN"); }
    | LBRAC Expr RBRAC      { Y_DEBUG_PRINT("ExprId-3", "LBRAC Expr RBRAC"); }
    | error RBRAC           { Y_DEBUG_PRINT("ExprId-4", "error RBRAC"); }
    ;

ExprList
    : Expr                  { Y_DEBUG_PRINT("ExprList-1", "Expr"); }
    | ExprList COMMA Expr   { Y_DEBUG_PRINT("ExprList-2", "ExprList COMMA Expr"); }
    ;

%%

int main(int argc, char **argv)
{
    int result = yyparse();

    switch(lex_state)
    {
        case 1:
            yyerror("End of file within a comment\n");
            break;
        case 2:
            yyerror("End of file within a string\n");
            break;
    }

    return result;
}

int yywrap() { return 1; }

void yyerror(char const *s) { fprintf(stderr, "%s on line %d", s, input_line_nbr); }

void warn(char const *s) { fprintf(stderr, "%s\n", s); }
