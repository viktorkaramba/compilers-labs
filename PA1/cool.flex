/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */
int comment_depth;
bool strlen_check();
int strlen_error();
%}

%x COMMENT
%x STRING
/*
 * Define names for regular expressions here.
 */

DIGIT			[0-9]
LOWERCASE_LETTER	[a-z]
UPPERCASE_LETTER	[A-Z]
NEWLINE			(\r\n|\n)+
WHITESPACE		[ \t]*
DASHCOMMENT		--.*\n
TYPEID			{UPPERCASE_LETTER}({LOWERCASE_LETTER}|{UPPERCASE_LETTER}|{DIGIT}|"_")*
OBJECTID		{LOWERCASE_LETTER}({LOWERCASE_LETTER}|{UPPERCASE_LETTER}|{DIGIT}|"_")*
INT_CONST		{DIGIT}+
TRUE			[t][rR][uU][eE]
FALSE			[f][aA][lL][sS][eE]
BOOL_CONST		{TRUE}|{FALSE}
DARROW			=>
LE			<=
ASSIGN			<-
CLASS			(?i:class)
ELSE			(?i:else)
FI			(?i:fi)
IF			(?i:if)
IN			(?i:in)
INHERITS		(?i:inherits)
LET			(?i:let)
LOOP			(?i:loop)
POOL			(?i:pool)
THEN			(?i:then)
WHILE			(?i:while)
CASE			(?i:case)
ESAC			(?i:esac)
OF			(?i:of)
NEW			(?i:new)
ISVOID			(?i:isvoid)
NOT			(?i:not)
%%

"(*" {
     BEGIN(COMMENT);	
     comment_depth++;	
}
 <COMMENT>"(*" {
	       comment_depth++;   	      
}
<COMMENT>"*)" {
	      comment_depth--;
	      if (comment_depth == 0) {
	       	 BEGIN(INITIAL);
	      }    	      
}
"*)" {
     cool_yylval.error_msg = "Unmatched *)";
     return ERROR;
}
<COMMENT>\n {
	    curr_lineno++;    
}
<COMMENT>. {}
{DASHCOMMENT} {
	      curr_lineno++;
}
<COMMENT><<EOF>> {
		 BEGIN(INITIAL);
		 cool_yylval.error_msg = "EOF in comment";
		 return ERROR;
}
\" {
   BEGIN(STRING);
   string_buf_ptr = string_buf;
}
<STRING>\" {
	   BEGIN(INITIAL);
	   if (strlen_check()) {
	      return strlen_error();
	   }
	   string_buf_ptr = 0;
	   cool_yylval.symbol = stringtable.add_string(string_buf);
	   return STR_CONST;
}
<STRING><<EOF>> {
		cool_yylval.error_msg = "EOF in string constant";
		return ERROR;
}

<STRING>\\\n {
	     curr_lineno++;
}
<STRING>\n {
	   curr_lineno++;
	   BEGIN(INITIAL);
	   cool_yylval.error_msg = "Unterminated string constant";
	   return ERROR;
}
<STRING>\\0 {
	   cool_yylval.error_msg = "String contains null character";
	   *string_buf_ptr++ = '0';
	   return ERROR;
}
<STRING>\\[^btnf] {
		  if (strlen_check()) {
	      	     return strlen_error();
	  	  }
		  *string_buf_ptr++ = yytext[1];
}
<STRING>\\b {
	    if (strlen_check()) {
	      return strlen_error();
	    }
	    *string_buf_ptr++ = '\b';
}
<STRING>\\t {
	    if (strlen_check()) {
	      return strlen_error();
	    }
	    *string_buf_ptr++ = '\t';
}
<STRING>\\n {
	    if (strlen_check()) {
	      return strlen_error();
	    }
	    *string_buf_ptr++ = '\n';
}
<STRING>\\f {
	    if (strlen_check()) {
	      return strlen_error();
	    }
	    *string_buf_ptr++ = '\f';
}
<STRING>. {
	  if (strlen_check()) {
	      return strlen_error();
	  }
	  *string_buf_ptr++ = *yytext;
}
{INT_CONST} {
	cool_yylval.symbol = inttable.add_string(yytext);
	return INT_CONST;
}

{BOOL_CONST} {
	if (yytext[0]=='t') {
		 cool_yylval.boolean = true;
	}
	else {
		cool_yylval.boolean = false;
	}
	return BOOL_CONST;
}

{DARROW}		{ return (DARROW); }
{LE}			{ return (LE);     }
{ASSIGN}		{ return (ASSIGN); }
"<"			{ return '<';	   }
"@"			{ return '@';	   }
"~"			{ return '~';	   }
"="			{ return '=';	   }
"."			{ return '.';	   }
","			{ return ',';	   }
"{"			{ return '{';	   }
"}"			{ return '}';	   }
"("			{ return '(';	   }
")"			{ return ')';	   }
"-"			{ return '-';	   }
"+"			{ return '+';	   }
"*"			{ return '*';	   }
":"			{ return ':';	   }
";"			{ return ';';	   }
"/"			{ return '/';	   }
{CLASS}			{ return CLASS;	   }
{ELSE}			{ return ELSE;	   }
{FI}			{ return FI;	   }
{IF}			{ return IF;	   }
{IN}			{ return IN;	   }
{INHERITS}		{ return INHERITS; }
{LET}			{ return LET;	   }
{LOOP}			{ return LOOP;	   }
{POOL}			{ return POOL;	   }
{THEN}			{ return THEN;	   }
{WHILE}			{ return WHILE;	   }
{CASE}			{ return CASE;	   }
{ESAC}			{ return ESAC;	   }
{OF}			{ return OF;	   }
{NEW}			{ return NEW;	   }
{ISVOID}		{ return ISVOID;   }
{NOT}			{ return NOT;	   }
{TYPEID} {
	 cool_yylval.symbol = idtable.add_string(yytext);
	 return TYPEID; 
}
{OBJECTID} {
	 cool_yylval.symbol = idtable.add_string(yytext);
	 return OBJECTID; 
}

{WHITESPACE} { }
\n {
   curr_lineno++;
}
. {
  cool_yylval.error_msg = strdup(yytext);
  return ERROR;
}
 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */


 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */


%%
bool strlen_check () {
     return (string_buf_ptr - string_buf) + 1 > MAX_STR_CONST;
}

int strlen_error() {
    BEGIN(INITIAL);
    cool_yylval.error_msg = "String constant too long";
    return ERROR;
}