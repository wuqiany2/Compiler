/*Definition Section*/
%{

#include <stdio.h>
#include <string.h>
#include "demo.tab.h"

int line_num = 0;
%}

%option noyywrap
%option yylineno

%%
"and" {return AND;}
"by" {return BY;}
"char" {return CHAR;}
"else" {return ELSE;}
"for" {return FOR;} 
"if" {return IF;}
"int" {return INT;}
"not" {return NOT;}
"or" {return OR;}
"procedure" {return PROCEDURE;}
"read" {return READ;}
"then" {return THEN;}
"to" {return TO;}
"while" {return WHILE;}
"write" {return WRITE;}

[A-Za-z][A-Za-z0-9]* {yylval.lexeme = strdup(yytext); return NAME;}
[0-9]+ { yylval.value = atoi(yytext);  return NUMBER;}
'([^'\\\n]|\\.)' {yylval.lexeme = strdup(yytext); return CHARCONST;}
[+\-*/%=(),!{}[\].;:] { yylval.lexeme = strdup(yytext); return (int) yytext[0];}

"<" {return LT;}
"<=" {return LE;}
"==" {return EQ;}
"!=" {return NE;}
">" {return GT;}
">=" {return GE;}

"//".* {/*do nothing, line comment*/}

[\n] {line_num++;}
[ \t\r] {;}
. {} 

%%
/*User Code Section*/

void LexMain(int argc, char* argv[]){
	
	if(argc != 2){
		printf("Command Format Error, please use run with -h for help\n");
		exit(1);
	}
	else{
		if (strcmp(argv[1],"-h") == 0){
			printf("Format: %s [options] [source filename]\n", argv[0]);
			printf("options:\n");
			printf("\t-h : help\n");
			exit(1);
		}
		else{
			FILE* file = fopen(argv[1],"r");
			yyin = file;
		}
	}


	return;
}



