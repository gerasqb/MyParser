import java.lang.*;
%%
%class MyLexer
%byaccj
%line
%column
%public


%{
	public int yyline(){
	return yyline;}
	public int yycolumn(){
	return  yycolumn;}
%}


not_number = [0-9]+[a-zA-Z]+
number = ("-")?[0-9]+
comments = ("(*"([^"*"]|[\r\n]|("*"+([^"*"\"]|[\r\n])))*"*"+")")|("//"[^.\r\n]*)
var = [A-Za-z_][A-Za-z0-9_]*
some_operator = "+" | "-" | "**"| "*" | "/" | "%" | "==" | "!=" | ">" | ">=" | "<" | "<=" | "&&" | "||"
bracket_open = "("
bracket_close = ")"
%%

{not_number}	{
		System.exit(0);
}

{comments} {

 	return Parser.COMMENTS;
 	}

{number} {
 	return Parser.NUMBER;
 	}

{bracket_close} {
 	return Parser.BRACKET_CLOSE;
 	}
{bracket_open} {
 	return Parser.BRACKET_OPEN;
 	}

"(//.*)" {
 	return Parser.COMMENTS;
 	}

{some_operator} {
 	return Parser.SOME_OPERATOR;
 	}

 " " { }

 "skip" {
 	return Parser.SKIP_KW;
 	}

 "write" {
 	return Parser.WRITE_KW;
 	}

 "read" {
 	return Parser.READ_KW;
 	}

 "while" {
 	return Parser.WHILE_KW;
 	}

  "do" {
 	return Parser.DO_KW;
 	}

   "if" {
 	return Parser.IF_KW;
 	}

   "then" {
 	return Parser.THEN_KW;
 	}

    "else" {
 	return Parser.ELSE_KW;
 	}

    ";" {
 	return Parser.COLON;
 	}

 	":=" {
 	return Parser.COLONEQUAL;
 	}

 	":" {
 	return Parser.SEMICOLON;
 	}

"\n" | "\r" | "\r\n" {}

{var} {
 	return Parser.VAR;
 	}


[^]    {
		throw new Error("Symbol not support by lexer<"+yytext()+">"); 
 }
