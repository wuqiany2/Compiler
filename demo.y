%{
#include <stdio.h>
#define YYERROR_VERBOSE
#define YYDEBUG 1
int yylineno;
char* yytext;

int error_count = 0;
extern int yylex();
extern int line_num;

void yyerror(const char* err_string){
	printf("Error at line %d: %s\n", yylineno, err_string);
	error_count++;
}

%}
%union{
	char* lexeme;
	int value;
}

%token LT LE EQ NE GT GE
%token AND BY CHAR ELSE FOR IF INT NOT OR PROCEDURE READ THEN TO WHILE WRITE
%token <lexeme> CHARCONST NAME NUMBER

%right '='
%left OR
%left AND
%nonassoc EQ NE LT LE GT GE
%left '+' '-'
%left '*' '/' '%'


%start Procedure
%%

Procedure: PROCEDURE NAME '{' Decls Stmts '}';

Decls: Decls Decl ';' 
	| Decl ';' ;

Decl: Type SpecList ;

Type: INT 
	| CHAR ;

SpecList: SpecList ',' Spec
	| Spec ;

Spec: NAME
	| NAME '[' Bounds ']';

Bounds: Bounds ',' Bound
	| Bound ;
	
Bound : NUMBER ':' NUMBER ;
	
Stmts : Stmts Stmt
	| Stmt ;
	
Stmt : Reference '=' Expr ';'
	| '{' Stmts '}'
	| WHILE '(' Bool ')' '{' Stmts '}'
	| FOR NAME '=' Expr TO Expr BY Expr '{' Stmts '}'
	| IF '(' Bool ')' THEN Stmt
	| IF '(' Bool ')' THEN WithElse ELSE Stmt
	| READ Reference ';'
	| WRITE Expr ';' ;

WithElse : IF '(' Bool ')' THEN WithElse ELSE WithElse
	| Reference '=' Expr ';'
	| '{' Stmts '}'
	| READ Reference ';'
	| WRITE Expr ';'
	| WHILE '(' Bool ')' '{' Stmts '}'
	| FOR NAME '=' Expr TO Expr BY Expr '{' Stmts '}';
	
Bool : NOT OrTerm
	| OrTerm ;
	
OrTerm : OrTerm OR AndTerm
	| AndTerm ;
	
AndTerm : AndTerm AND RelExpr
	| RelExpr ;
	
RelExpr : RelExpr LT Expr
	| RelExpr LE Expr
	| RelExpr EQ Expr
	| RelExpr NE Expr
	| RelExpr GE Expr
	| RelExpr GT Expr
	| Expr ;
	
Expr : Expr '+' Term
	| Expr '-' Term
	| Term;
	
Term : Term '*' Factor
	| Term '/' Factor
	| Term '%' Factor
	| Factor;
	
Factor : '(' Expr ')'
	| Reference
	| NUMBER
	| CHARCONST ;
	
Reference : NAME
	| NAME '[' Exprs ']';
	
Exprs : Expr ',' Exprs
	| Expr ;


%%

void LexMain(int argc, char* argv[]);

int main(int argc, char* argv[]){

	error_count = 0;
	LexMain(argc, argv);
	
	yyparse();
	
	if (error_count == 0) printf("Parse Successful!\n");
	return 0;

}
