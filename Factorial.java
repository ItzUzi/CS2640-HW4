public class Factorial {
    public static void main(String[] args) {

        int num = fact(25);
        System.out.println("num is: " + num);
    
    }

    public static int fact(int num){
        if(num <= 1)
            return 1;
        else
            return num * fact(num - 1);
    }
}
