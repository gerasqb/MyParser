import java.util.ArrayList;
import java.util.List;

public class treeNode {
    public String name;
    public ArrayList<treeNode> childs;
    public treeNode(String n){
        childs = new ArrayList<>();

        name = n;

    }
    public void add(treeNode ch){
        childs.add(ch);
    }
    public void printNode(int level){
        String offset = "";
        for(int i = 0; i < level; i++){
            offset +="   ";
        }
        System.out.println(offset + name);
        for(int i=0; i < childs.size(); i++){
            childs.get(i).printNode(level+1);
        }
    }
}
