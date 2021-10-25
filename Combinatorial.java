import java.util.Scanner;

public class Combinatorial{
    public static void main(String[] args) {
        
        long r = -1, n = -1;
        Scanner kbInput = new Scanner(System.in);

        while(n < r || r<0){
            System.out.println("Value must be greater than 0");
            r = kbInput.nextLong();
            System.out.println("Value must be greater than the last value");
            n = kbInput.nextLong();
        }

        long result = comb(n, r);

        System.out.println("Result is " + result);

    }

    public static long comb(long n, long r){
        if(n == r || r == 0)
            return 1;
        else return comb(n-1, r) + comb(n-1, r-1);
    }
}