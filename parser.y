%{
  import java.io.*;
  import java.nio.file.Files;
  import java.nio.file.Paths;
%}
      
%token NUMBER 
%token SOME_OPERATOR 
%token BRACKET_CLOSE
%token BRACKET_OPEN
%token SPACE
%token VAR 
%token SKIP_KW 
%token WRITE_KW 
%token READ_KW 
%token WHILE_KW 
%token DO_KW 
%token IF_KW 
%token THEN_KW
%token ELSE_KW 
%token SEMICOLON 
%token COLONEQUAL 
%token COLON
%token NL
%token COMMENTS

%left SOME_OPERATOR

%nonassoc    SPACE 
%%
      
      
start: s {$1.nodeval.printNode(0);}
	;
	
s:    SKIP_KW 							{	$$.nodeval = new treeNode($1.sval);}
	| VAR COLONEQUAL expression 		{	$$.nodeval = new treeNode("S");
											$$.nodeval.add(new treeNode($1.sval));
											$$.nodeval.add(new treeNode($2.sval)); 
											$$.nodeval.add($3.nodeval);
										}
	| s COLON s 						{	$$.nodeval = new treeNode("S"); 
											$$.nodeval.add($1.nodeval); 
											$$.nodeval.add(new treeNode($2.sval));  
											$$.nodeval.add($3.nodeval); 
										}
	| WRITE_KW expression 					{	$$.nodeval = new treeNode("S");
											$$.nodeval.add(new treeNode($1.sval)); 
											$$.nodeval.add($2.nodeval); 
										}
	| READ_KW VAR 						{	$$.nodeval = new treeNode("S");
											$$.nodeval.add(new treeNode($1.sval)); 
											$$.nodeval.add(new treeNode($2.sval)); 
										}
	| WHILE_KW expression DO_KW s 			{	$$.nodeval = new treeNode("S"); 
											$$.nodeval.add(new treeNode($1.sval)); 
											$$.nodeval.add($2.nodeval); 
											$$.nodeval.add(new treeNode($3.sval));
											$$.nodeval.add($4.nodeval);
										}
	| IF_KW expression THEN_KW s ELSE_KW s 	{	$$.nodeval = new treeNode("S"); 
											$$.nodeval.add(new treeNode($1.sval)); 
											$$.nodeval.add($2.nodeval); 
											$$.nodeval.add(new treeNode($3.sval));
											$$.nodeval.add($4.nodeval);
											$$.nodeval.add(new treeNode($5.sval));
											$$.nodeval.add($6.nodeval);
										}
;

expression: 
	  NUMBER														{	$$.nodeval = new treeNode($1.sval);}
	| VAR															{	$$.nodeval = new treeNode($1.sval);}
	| BRACKET_OPEN expression SOME_OPERATOR expression BRACKET_CLOSE 	{	$$.nodeval = new treeNode("expr"); 
																		$$.nodeval.add(new treeNode($1.sval)); 
																		$$.nodeval.add($2.nodeval); 
																		$$.nodeval.add(new treeNode($3.sval));
																		$$.nodeval.add($4.nodeval);
																		$$.nodeval.add(new treeNode($5.sval));
																	}
	| expression SOME_OPERATOR expression							{	$$.nodeval = new treeNode("expr"); 
																		$$.nodeval.add($1.nodeval); 
																		$$.nodeval.add(new treeNode($2.sval)); 
																		$$.nodeval.add($3.nodeval);
																	} 
	
;   

%%
	
  private MyLexer lexer;

  private int yylex () {
    int yyl_return = -1;
    try {

      yyl_return = lexer.yylex();
	  int tk = yyl_return;
	  String unionText = "";
		if(tk==Parser.VAR){
			unionText = String.format("VAR(\"%s\", %d, %d, %d); ",lexer.yytext(),lexer.yyline(),lexer.yycolumn(),lexer.yycolumn() + lexer.yytext().length()-1);
		}
		else if(tk==Parser.NUMBER){
			unionText = String.format("NUMBER(%s, %d, %d, %d); ",lexer.yytext(),lexer.yyline(),lexer.yycolumn(),lexer.yycolumn() + lexer.yytext().length()-1);
		}
		else if(tk==Parser.SOME_OPERATOR){
			unionText = String.format("SOME_OP(%s, %d, %d, %d); ",lexer.yytext(),lexer.yyline(),lexer.yycolumn(),lexer.yycolumn() + lexer.yytext().length()-1);
		}
		else if(tk==Parser.COMMENTS){
			unionText = String.format("COMMENTS(\"%s\", %d, %d, %d); ",lexer.yytext().replaceAll("\\p{Cntrl}", ""),lexer.yyline(),lexer.yycolumn(),lexer.yycolumn() + lexer.yytext().length()-1);
		}
		else if(tk==Parser.NL){

		}
		else
		{
			String tokenName = null;
			switch (tk){
				case Parser.BRACKET_CLOSE:               tokenName = "BRACKET_CLOSE"; break;
				case Parser.BRACKET_OPEN:               tokenName = "BRACKET_OPEN"; break;
				case Parser.SKIP_KW:               tokenName = "SKIP_KW"; break;
				case Parser.WRITE_KW:               tokenName = "WRITE_KW"; break;
				case Parser.READ_KW:               tokenName = "READ_KW"; break;
				case Parser.WHILE_KW:               tokenName = "WHILE_KW"; break;
				case Parser.DO_KW:               tokenName = "DO_KW"; break;
				case Parser.IF_KW:               tokenName = "IF_KW"; break;
				case Parser.THEN_KW:               tokenName = "THEN_KW"; break;
				case Parser.ELSE_KW:               tokenName = "ELSE_KW"; break;
				case Parser.SEMICOLON:               tokenName = "SEMICOLON"; break;
				case Parser.COLONEQUAL:               tokenName = "COLONEQUAL"; break;
				case Parser.COLON:               tokenName = "COLON"; break;
				default: tk =-1;break;
			}
			unionText = String.format("%s(%d, %d, %d); ",tokenName,lexer.yyline(),lexer.yycolumn(),lexer.yycolumn() + lexer.yytext().length()-1);
		}
			
	  yylval = new ParserVal(unionText);
    }
    catch (IOException e) {
      System.err.println("IO error :"+e);
    }
    return yyl_return;
  }


  public void yyerror (String error) {
    System.out.println ("statement not belongs to language L");
  }

  public Parser(Reader r) {
    lexer = new MyLexer(r);
  }
  
  
