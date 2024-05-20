package miniP;

import java.util.Scanner;

public class Cli {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.println("\033[H\033[2J");
        System.out.flush();
        System.out.println("|----------------Welcome----------------|");
        System.out.print("""
                Which one is your role:

                    1.Admin
                    2.Teacher
                                        
                :""");
        while (true) {
            boolean flag = false;
            int input = scanner.nextInt();
            switch (input) {
                case 1:
                    //TODO
                    break;
                case 2:
                    //TODO
                    break;
                default:
                    System.out.println("Invalid input.");
                    System.out.print("""
                        Which one is your role:

                            1.Admin
                            2.Teacher
                            
                        :""");
                    flag = true;
                    break;
            }
            if (flag == false)
                break;
        }
        scanner.close();
    }


    static void teacherCli() {
        Scanner scanner = new Scanner(System.in);
        System.out.println("\033[H\033[2J");
        System.out.flush();
        System.out.println("Enter your teacher ID: ");
        //TODO :
            //Search for the ID in file to match
        //TODO :
            // If ID match look for the teacher password to match
                // If the password matches procced to next lines
                    // Else terminate the operation or ask for id,pass again and again
        Teacher teacher = null;
        System.out.println("----------------Greeting " + teacher.getTeacherName() + "----------------");
        System.out.println("What do you want to do ?");
        System.out.println("""
                    1.
                    2.
                    3.
                    4.
                    5.
                    6.
                    """);
        while (true) {
            boolean flag = false;
            int input = scanner.nextInt();
            switch (input) {
                case 1:
                    //TODO
                    break;
                case 2:
                    //TODO
                    break;
                case 3:
                    //TODO
                    break;
                case 4:
                    //TODO
                    break;
                case 5:
                    //TODO
                    break;
                case 6:
                    //TODO
                    break;
                default:
                    System.out.println("Invalid input.");
                    System.out.println("""
                            1.
                            2.
                            3.
                            4.
                            5.
                            6.
                            """);
                    flag = true;
                    break;
            }
            if (flag == false)
                break;
        }
    }
}
