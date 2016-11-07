import java.io.FileReader;
import java.io.IOException;

public class parser_console {
    public static void main(String args[]) throws IOException {
        Parser yyparser = null;
        if ( args.length > 0 ) {

            yyparser = new Parser(new FileReader(args[0]));
            yyparser.yyparse();
        }
        else {
            System.out.println("error: pass me file!");
        }
    }
}
