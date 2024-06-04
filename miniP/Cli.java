package miniP;

import java.util.ArrayList;
import java.util.Scanner;
import java.util.zip.CheckedOutputStream;

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
        clear();
        while(true) {
            System.out.println("\nPlease choose: ");
            System.out.print("""
                            
                            1.Teacher Management
                            2.Course Management
                            3.Student Management
                            4.Exit
                                                    
                            :""");
            int choice = scanner.nextInt();

            switch (choice) {
                case 1:
                    clear();
                    teacherManager(scanner);
                    break;
                case 2:
                    clear();
                    courseManager(scanner);
                    break;
                case 3:
                    studentManager(scanner);
                    clear();
                    break;
                case 4:
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
        ArrayList<Teacher> teachers = Admin.retrieveData(Teacher.class);
        scanner.nextLine();
        while (true) {
            System.out.println("Enter your teacher ID: ");
            String id = scanner.nextLine();
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
                    clear();
                    scanner.nextLine();
                    System.out.println("Enter the course name you want to add student to: ");
                    String courseName = scanner.nextLine();
                    System.out.println("Enter the course ID you want to add student to: ");
                    String courseID = scanner.nextLine();
                    Course course = new Course(courseName, courseID);
                    if (!course.getTeacher().equals(teacher)) {
                        System.out.println("You are not the teacher of this course.");
                        break;
                    }
                    System.out.println("Enter student name: ");
                    String studentName = scanner.nextLine();
                    System.out.println("Enter student ID: ");
                    String studentID = scanner.nextLine();
                    System.out.println();
                    Student student = new Student(studentName, studentID, Admin.retrieveData(Student.class).size());
                    if(Admin.addData(student))
                        System.out.printf("Student %s added successfully!\n", studentName);
                    break;
                case 4:

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

    static void teacherManager(Scanner scanner) {
        clear();
        while (true) {
            System.out.println("\nPlease choose: ");
            System.out.print("""
                            
                            1.Add new teacher
                            2.Remove teacher
                            3.Show Teachers
                            4.Add teacher to course
                            5.Back
                            6.Exit
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
                    Teacher teacher = new Teacher(name, Id, Admin.retrieveData(Teacher.class).size());
                    if(Admin.addData(teacher))
                        System.out.printf("Teacher %s added successfully!\n", name);
                    break;
                case 2:
                    clear();
                    scanner.nextLine();
                    System.out.print("Enter teacher name: ");
                    name = scanner.nextLine();
                    System.out.print("Enter teacher ID: ");
                    Id = scanner.nextLine();
                    System.out.print("Enter teacher Password: ");
                    String password = scanner.nextLine();
                    teacher = new Teacher(name, Id, password);
                    if(Admin.removeData(teacher))
                        System.out.printf("Teacher %s removed successfully!\n", name);
                    break;
                case 3:
                    ArrayList<Teacher> teachers = Admin.retrieveData(Teacher.class);
                    if (teachers.isEmpty()) {
                        System.out.println("There is no teacher in database.");
                        break;
                    }
                    for(Teacher t: teachers)
                        System.out.println(t.getTeacherName() + "-" + t.getID() + "-" + t.getPassword());
                    break;
                case 4:
                    clear();
                    scanner.nextLine();
                    System.out.println("Enter the teacher name: ");
                    String teacherName = scanner.nextLine();
                    System.out.println("Enter the teacher ID: ");
                    String teacherID = scanner.nextLine();
                    teachers = Admin.retrieveData(Teacher.class);
                    boolean flag = false;
                    teacher = new Teacher();
                    for (Teacher t : teachers)
                        if (t.getTeacherName().equals(teacherName) && t.getID().equals(teacherID)) {
                            flag = true;
                            teacher = t;
                            break;
                        }
                    if (!flag) {
                        System.out.println("There is no teacher with this data.");
                        break;
                    }
                    System.out.println("Enter the course name: ");
                    String courseName = scanner.nextLine();
                    System.out.println("Enter the course ID: ");
                    String courseID = scanner.nextLine();
                    Course course = new Course();
                    ArrayList<Course> courses = Admin.retrieveData(Course.class);
                    flag = false;
                    for (Course c : courses)
                        if (c.getName().equals(courseName) && c.getID().equals(courseID)) {
                            flag = true;
                            course = c;
                            break;
                        }
                    if (!flag) {
                        System.out.println("There is no course with this data.");
                        break;
                    }
                    if (course.getTeacher() == null){
                        course.setTeacher(teacher);
                        Admin.updateData(course);
                        System.out.println("Course \"" + course.getName() + "\"'s teacher is now : " + teacher.getTeacherName());
                    }
                    else {
                        System.out.println("This course teacher is : " + course.getTeacher().getTeacherName());
                    }
                    break;
                case 5:
                    adminCli(scanner);
                case 6:
                    System.exit(0);
                default:
                    clear();
                    System.out.println("Invalid option!");
            }
        }
    }

    static void courseManager(Scanner scanner) {
        clear();
        while (true) {
            System.out.println("\nPlease choose: ");
            System.out.print("""
                            
                            1.Add new course
                            2.Remove course
                            3.Show courses
                            4.Back
                            5.Exit
                            :""");
            int choice = scanner.nextInt();
            switch (choice){
                case 1:
                    clear();
                    scanner.nextLine();
                    System.out.println("Enter course name: ");
                    String name = scanner.nextLine();
                    System.out.println("Enter number of units: ");
                    int unit = scanner.nextInt();
                    scanner.nextLine();
                    System.out.println("Enter exam date(YYYY-MM-DD): ");
                    String date = scanner.nextLine();
                    Course course = new Course(name, unit, date, Integer.toString(Admin.retrieveData(Course.class).size()));
                    if (Admin.addData(course))
                        System.out.printf("Course %s added successfully\n", name);
                    break;
                case 2:
                    clear();
                    scanner.nextLine();
                    System.out.print("Enter course name: ");
                    name = scanner.nextLine();
                    System.out.print("Enter course ID: ");
                    String Id = scanner.nextLine();
                    course = new Course(name, Id);
                    if(Admin.removeData(course))
                        System.out.printf("Course %s removed successfully!\n", name);
                    break;
                case 3:
                    ArrayList<Course> courses = Admin.retrieveData(Course.class);
                    if (courses.isEmpty()) {
                        System.out.println("There is no course in database.");
                        break;
                    }
                    for(Course c: courses)
                        System.out.println(c.getName() + "-" + c.getID() + "-" + (c.getTeacher() == null ? "No teacher" : c.getTeacher().getTeacherName()) + "-" + c.getStudentCount());

                    break;
                case 4:
                    adminCli(scanner);
                case 5:
                    System.exit(0);
                default:
                    clear();
                    System.out.println("Invalid option!");
            }
        }
    }

    static void studentManager(Scanner scanner) {
        clear();
        while (true) {
            System.out.println("\nPlease choose: ");
            System.out.print("""
                            
                            1.Add new course
                            2.Remove course
                            3.Show courses
                            4.Back
                            5.Exit
                            :""");
            int choice = scanner.nextInt();
            switch (choice){
                case 1:
                    clear();
                    scanner.nextLine();
                    System.out.println("Enter student name: ");
                    String name = scanner.nextLine();
                    System.out.println("Enter student ID: ");
                    String Id = scanner.nextLine();
                    System.out.println();
                    Student student = new Student(name, Id, Admin.retrieveData(Student.class).size());
                    if(Admin.addData(student))
                        System.out.printf("Student %s added successfully!\n", name);
                    break;
                case 2:
                    clear();
                    scanner.nextLine();
                    System.out.print("Enter student name: ");
                    name = scanner.nextLine();
                    System.out.print("Enter student ID: ");
                    Id = scanner.nextLine();
                    System.out.print("Enter student Password: ");
                    String password = scanner.nextLine();
                    student = new Student(name, Id, password);
                    if(Admin.removeData(student))
                        System.out.printf("Student %s removed successfully!\n", name);
                    break;
                case 3:
                    ArrayList<Student> students = Admin.retrieveData(Student.class);
                    if (students.isEmpty()) {
                        System.out.println("There is no student in database.");
                        break;
                    }
                    for(Student s: students)
                        System.out.println(s.getStudentName() + "-" + s.getStudentID() + "-" + s.getPassword());

                    break;
                case 4:
                    adminCli(scanner);
                case 5:
                    System.exit(0);
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