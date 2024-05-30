package miniP;

import java.util.ArrayList;
import java.util.Scanner;

public class Cli {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        menu();
        boolean teacherCreated = false;
        while (true) {
            boolean flag = false;
            int input = scanner.nextInt();
            switch (input) {
                case 1:
                    adminCli(scanner, teacherCreated);
                    break;
                case 2:
                    teacherCli();
                    break;
                default:
                    menu();
                    flag = true;
                    break;
            }
            if (!flag)
                break;
        }
        scanner.close();
    }

    static void adminCli(Scanner scanner, boolean teacherCreated) {
        Admin admin = Admin.getInstance();
        clear();
        System.out.println("Please choose: ");
        System.out.print("""
                        
                        1.Add new teacher
                        2.Remove teacher
                        3.Add new assignments
                        4.Remove an assignment
                        5.Add new student
                        6.Remove a student
                        7.Show Teachers
                        8.Exit
                        
                        : """);

        boolean flagAdmin = false;
        int choice = scanner.nextInt();
        while(true) {
            if (flagAdmin || teacherCreated) {
                System.out.println("Please choose: ");
                System.out.print("""
                                
                                1.Add new teacher
                                2.Remove teacher
                                3.Add new assignments
                                4.Remove an assignment
                                5.Add new student
                                6.remove a student
                                7.Show Teachers
                                8.Exit
                                
                                :""");
            }
            if (flagAdmin || teacherCreated)
                choice = scanner.nextInt();

            flagAdmin = false;
            switch (choice){
                case 1:
                    clear();
                    scanner.nextLine();
                    System.out.print("Enter name: ");
                    String name = scanner.nextLine();
                    System.out.println();
                    System.out.print("Enter ID: ");
                    String Id = scanner.nextLine();
                    System.out.println();
                    if(admin.addTeacher(name, Id)){
                        teacherCreated = true;
                        System.out.printf("Teacher %s was added successfully!\n", name);
                    }

                    continue ;
                case 2:
                    admin.setTeacherCount(4);
                    System.out.println(Admin.getTeacherCount());
                    break;
                case 3:
                    break;
                case 4:
                    break;
                case 5:
                    break;
                case 6:
                    break;
                case 7:
                    ArrayList<Teacher> teachers = admin.retrieveTeachers();
                    for(Teacher teacher: teachers){
                        System.out.println(teacher.getTeacherName());
                    }

                    continue;
                case 8:
                    break;

                default:
                    flagAdmin = true;
                    clear();
                    System.out.println("Invalid option!");
            }
            if (!flagAdmin){
                break;
            }
        }
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
        System.out.print("""
                    
                        1.Add new teacher
                        2.Remove teacher
                        3.Add new assignments
                        4.Remove an assignment
                        5.Add new student
                        6.remove a student
                    
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
                    System.out.print("""
                            
                            1.Add new teacher
                            2.Remove teacher
                            3.Add new assignments
                            4.Remove an assignment
                            5.Add new student
                            6.remove a student
                            
                            :""");
                    flag = true;
                    break;
            }
            if (flag == false)
                break;
        }
    }

    public  static  void menu() {
        clear();
        System.out.println("|----------------Welcome----------------|");
        System.out.print("""
                Which one is your role:

                    1.Admin
                    2.Teacher
                
                :""");
    }
    public static void clear() {
        System.out.println("\033[H\033[2J");
        System.out.flush();
    }
}