package miniP;

import java.util.ArrayList;
import java.util.Scanner;

public class Cli {
    public static void main(String[] args) {
        System.out.println("|----------------Welcome----------------|");
        Scanner scanner = new Scanner(System.in);
        menu();
        while (true) {
            boolean flag = false;
            int input = scanner.nextInt();
            switch (input) {
                case 1:
                    adminCli(scanner);
                    break;
                case 2:
                    teacherCli(scanner);
                    break;
                default:
                    System.out.println("Invalid option.");
                    menu();
                    flag = true;
                    break;
            }
            if (!flag)
                break;
        }
        scanner.close();
    }

    static void adminCli(Scanner scanner) {
        Admin admin = Admin.getInstance();
        clear();

        while(true) {
            System.out.println("\nPlease choose: ");
            System.out.print("""
                            
                            1.Add new teacher
                            2.Remove teacher
                            3.Add new assignments
                            4.Remove an assignment
                            5.Add new student
                            6.Remove a student
                            7.Show Teachers
                            8.Exit
                            
                            :""");
            int choice = scanner.nextInt();

            switch (choice){
                case 1:
                    clear();
                    scanner.nextLine();
                    System.out.print("Enter name: ");
                    String name = scanner.nextLine();
                    System.out.print("Enter ID: ");
                    String Id = scanner.nextLine();
                    System.out.println();
                    Teacher teacher = new Teacher(name, Id, Admin.retrieveTeachers().size());
                    if(Admin.addTeacher(teacher))
                        System.out.printf("Teacher %s added successfully!\n", name);
                    break;
                case 2:
                    clear();
                    scanner.nextLine();
                    System.out.print("Enter name: ");
                    name = scanner.nextLine();
                    System.out.print("Enter ID: ");
                    Id = scanner.nextLine();
                    System.out.print("Enter Password: ");
                    String password = scanner.nextLine();
                    teacher = new Teacher(name, Id, password);
                    if(Admin.removeTeacher(teacher))
                        System.out.printf("Teacher %s removed successfully!\n", name);
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
                    ArrayList<Teacher> teachers = Admin.retrieveTeachers();
                    for(Teacher t: teachers){
                        System.out.println(t.getTeacherName() + "-" + t.getID() + "-" + t.getPassword());
                    }
                    break;
                case 8:
                    return;
                default:
                    clear();
                    System.out.println("Invalid option!");
            }
        }
    }
    static void teacherCli(Scanner scanner) {
        clear();
        Teacher teacher = null;
        System.out.println("Enter your teacher ID: ");
        while (true) {
            String id = scanner.nextLine();
            ArrayList<Teacher> teachers = null;
            boolean flag = false;
            for (Teacher t : teachers) {
                if (t.getID().equals(id)) {
                    flag = true;
                    teacher = t;
                    break;
                }
            }
            if (!flag) {
                System.out.println("No teacher found with this ID! ");
                while (true){
                    System.out.println("Choose an option: ");
                    System.out.print("""
                
                        1.Enter your teacher ID
                        2.Exit
                    
                    :""");

                    int choice = scanner.nextInt();
                    if (choice == 2) {
                        return;
                    } else if (choice != 1){
                        System.out.println("Invalid option! ");
                    }
                }
            }
            else
                break;
        }

        System.out.println("----------------Greeting " + teacher.getTeacherName() + "----------------");
        while(true) {
            System.out.println("\nPlease choose: ");
            System.out.print("""
                            
                            1.Add new assignments
                            2.Remove an assignment
                            3.Add new student
                            4.Remove a student
                            5.Show students
                            6.Show assignments
                            7.Exit
                            
                            :""");
            int choice = scanner.nextInt();

            switch (choice){
                case 1:
                    break;
                case 2:
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
                    return;
                default:
                    clear();
                    System.out.println("Invalid option!");
            }
        }
    }

    public  static  void menu() {
        clear();
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