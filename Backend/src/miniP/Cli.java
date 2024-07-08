package miniP;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.CheckedOutputStream;

public class Cli {
    public static void main(String[] args) throws IOException {
        ArrayList<Assignment> assignments = Admin.retrieveData(Assignment.class);
        for (Assignment a : assignments)
            System.out.println(a.getName());
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

    static void adminCli(Scanner scanner) throws IOException {
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
                    clear();
                    scanner.nextLine();
                    System.out.println("Enter the course name you want to add assignment to: ");
                    String courseName = scanner.nextLine();
                    System.out.println("Enter the course ID you want to add assignment to: ");
                    String courseID = scanner.nextLine();
                    ArrayList<Course> courses = Admin.retrieveData(Course.class);
                    Course course = null;
                    for (Course c  : courses) {
                        if (c.getName().equals(courseName) && c.getID().equals(courseID))
                            course = c;
                    }
                    if (course == null) {
                        System.out.println("There is no course with this data.");
                        break;
                    }
                    if (course.getTeacher() == null) {
                        System.out.println("You are not the teacher of this course.");
                        break;
                    }
                    if (!course.getTeacher().getID().equals(teacher.getID())) {
                        System.out.println("You are not the teacher of this course.");
                        break;
                    }
                    System.out.println("Enter the deadline of this assignment(YYYY-MM-DD): ");
                    String deadline = scanner.nextLine();
                    System.out.println("Enter the title of this assignment: ");
                    String title = scanner.nextLine();
                    System.out.println("Enter any description for assignment: ");
                    String description = scanner.nextLine();
                    System.out.println("Enter the score of this assignment: ");
                    double score = scanner.nextDouble();
                    Assignment assignment = new Assignment(course, deadline, title, description, score);
                    List<Assignment> assignments = course.getAssignments();
                    if (assignments != null)
                        for (Assignment a : assignments) {
                            if (a.getCourse().equals(course)
                                    && a.getName().equals(assignment.getName())) {
                                System.out.println("This assignment is already add to this course.");
                                break;
                            }
                        }
                    course.addAssignment(assignment);
                    Admin.updateData(course);
                    Admin.addData(assignment);
                    System.out.println("Assignment add to the course successfully");
                    break;
                case 2:
                    clear();
                    scanner.nextLine();
                    System.out.println("Enter the course name you want to remove assignment from: ");
                    courseName = scanner.nextLine();
                    System.out.println("Enter the course ID you want to remove assignment from: ");
                    courseID = scanner.nextLine();
                    courses = Admin.retrieveData(Course.class);
                    course = null;
                    for (Course c  : courses) {
                        if (c.getName().equals(courseName) && c.getID().equals(courseID))
                            course = c;
                    }
                    if (course == null) {
                        System.out.println("There is no course with this data.");
                        break;
                    }
                    if (course.getTeacher() == null) {
                        System.out.println("You are not the teacher of this course.");
                        break;
                    }
                    if (!course.getTeacher().getID().equals(teacher.getID())) {
                        System.out.println("You are not the teacher of this course.");
                        break;
                    }
                    System.out.println("Enter the title of this assignment: ");
                    title = scanner.nextLine();
                    assignment = null;
                    assignments = course.getAssignments();
                    if (assignments != null)
                        for (Assignment a : assignments) {
                            if (a.getCourse().equals(course)
                                    && a.getName().equals(title)) {
                                assignment = a;
                                break;
                            }
                        }
                    if (assignment == null) {
                        System.out.println("There is no assignment with this data to remove.");
                        break;
                    }
                    course.removeAssignment(assignment);
                    Admin.removeData(assignment);
                    Admin.updateData(course);
                    System.out.println("Assignment removed from the course successfully");
                    break;
                case 3:
                    clear();
                    scanner.nextLine();
                    System.out.println("Enter the course name you want to add student to: ");
                    courseName = scanner.nextLine();
                    System.out.println("Enter the course ID you want to add student to: ");
                    courseID = scanner.nextLine();
                    courses = Admin.retrieveData(Course.class);
                    course = null;
                    for (Course c  : courses) {
                        if (c.getName().equals(courseName) && c.getID().equals(courseID))
                            course = c;
                    }
                    if (course == null) {
                        System.out.println("There is no course with this data.");
                        break;
                    }
                    if (course.getTeacher() == null) {
                        System.out.println("You are not the teacher of this course.");
                        break;
                    }
                    if (!course.getTeacher().getID().equals(teacher.getID())) {
                        System.out.println("You are not the teacher of this course.");
                        break;
                    }
                    System.out.println("Enter student name: ");
                    String studentName = scanner.nextLine();
                    System.out.println("Enter student ID: ");
                    String studentID = scanner.nextLine();
                    System.out.println();
                    ArrayList<Student> students = Admin.retrieveData(Student.class);
                    Student student = null;
                    for (Student s  : students) {
                        if (s.getStudentName().equals(studentName) && s.getStudentID().equals(studentID))
                            student = s;
                    }
                    if (student == null) {
                        System.out.println("There is no student with this data.");
                        break;
                    }
                    List<Course> sCourses = student.getCourses();
                    if (sCourses.contains(course)) {
                        System.out.println("This student is already in this course");
                        break;
                    }
                    student.addCourse(course);
                    Admin.updateData(student);
                    Admin.updateData(course);
                    System.out.println("Student added to the course successfully");
                    break;
                case 4:
                    clear();
                    scanner.nextLine();
                    System.out.println("Enter the course name you want to remove student from: ");
                    courseName = scanner.nextLine();
                    System.out.println("Enter the course ID you want to remove student from: ");
                    courseID = scanner.nextLine();
                    courses = Admin.retrieveData(Course.class);
                    course = null;
                    for (Course c  : courses) {
                        if (c.getName().equals(courseName) && c.getID().equals(courseID))
                            course = c;
                    }
                    if (course == null) {
                        System.out.println("There is no course with this data.");
                        break;
                    }
                    if (course.getTeacher() == null) {
                        System.out.println("You are not the teacher of this course.");
                        break;
                    }
                    if (!course.getTeacher().getID().equals(teacher.getID())) {
                        System.out.println("You are not the teacher of this course.");
                        break;
                    }
                    System.out.println("Enter student name: ");
                    studentName = scanner.nextLine();
                    System.out.println("Enter student ID: ");
                    studentID = scanner.nextLine();
                    System.out.println();
                    students = Admin.retrieveData(Student.class);
                    student = null;
                    for (Student s  : students) {
                        if (s.getStudentName().equals(studentName) && s.getStudentID().equals(studentID))
                            student = s;
                    }
                    if (student == null) {
                        System.out.println("There is no student with this data.");
                        break;
                    }
                    sCourses = student.getCourses();
                    if (!sCourses.contains(course)) {
                        System.out.println("This student is not in this course");
                        break;
                    }
                    student.removeCourse(course);
                    Admin.updateData(student);
                    Admin.updateData(course);
                    System.out.println("Student removed from the course successfully");
                    break;
                case 5:
                    clear();
                    scanner.nextLine();
                    System.out.println("Enter the course name: ");
                    courseName = scanner.nextLine();
                    System.out.println("Enter the course ID: ");
                    courseID = scanner.nextLine();
                    courses = Admin.retrieveData(Course.class);
                    course = null;
                    for (Course c  : courses) {
                        if (c.getName().equals(courseName) && c.getID().equals(courseID))
                            course = c;
                    }
                    if (course == null) {
                        System.out.println("There is no course with this data.");
                        break;
                    }
                    if (course.getTeacher() == null) {
                        System.out.println("You are not the teacher of this course.");
                        break;
                    }
                    if (!course.getTeacher().getID().equals(teacher.getID())) {
                        System.out.println("You are not the teacher of this course.");
                        break;
                    }
                    List<Student> studentsList = course.getStudents();
                    if (studentsList.isEmpty()) {
                        System.out.println("There is no student in this course yet.");
                        break;
                    }
                    for(Student s: studentsList)
                        System.out.println(s.getStudentName() + "-" + s.getStudentID());
                    break;
                case 6:
                    clear();
                    scanner.nextLine();
                    System.out.println("Enter the course name: ");
                    courseName = scanner.nextLine();
                    System.out.println("Enter the course ID: ");
                    courseID = scanner.nextLine();
                    courses = Admin.retrieveData(Course.class);
                    course = null;
                    for (Course c  : courses) {
                        if (c.getName().equals(courseName) && c.getID().equals(courseID))
                            course = c;
                    }
                    if (course == null) {
                        System.out.println("There is no course with this data.");
                        break;
                    }
                    if (course.getTeacher() == null) {
                        System.out.println("You are not the teacher of this course.");
                        break;
                    }
                    if (!course.getTeacher().getID().equals(teacher.getID())) {
                        System.out.println("You are not the teacher of this course.");
                        break;
                    }
                    List<Assignment> assignmentList = course.getAssignments();
                    if (assignmentList.isEmpty()) {
                        System.out.println("There is no assignment in this course yet.");
                        break;
                    }
                    for(Assignment a: assignmentList)
                        System.out.println(a.getName() + "-" + a.getDescription() + "-" + a.getDeadline());
                    break;
                case 7:
                    return;
                default:
                    clear();
                    System.out.println("Invalid option!");
            }
        }
    }

    static void teacherManager(Scanner scanner) throws IOException {
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

    static void courseManager(Scanner scanner) throws IOException {
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

    static void studentManager(Scanner scanner) throws IOException {
        clear();
        while (true) {
            System.out.println("\nPlease choose: ");
            System.out.print("""
                            
                            1.Add new student
                            2.Remove student
                            3.Show students
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
                    System.out.println("Enter student Image path: ");
                    String path = scanner.nextLine();
                    System.out.println();
                    Student student = new Student(name, Id, Admin.retrieveData(Student.class).size(), Term.بهار۱۴۰۲ـ۱۴۰۳,path);
                    if(Admin.addData(student))
                        System.out.printf("Student %s added successfully!\n", name);
                    break;
                case 2:
                    clear();
                    scanner.nextLine();
                    System.out.print("Enter student name: ");
                    name = scanner.nextLine();
                    System.out.print("Enter SID: ");
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
                    for(Student s: students) {
                        System.out.println(s.getStudentName() + "-" + s.getSID() +  "-" + s.getUsername() + "-" + s.getPassword() + "-" + s.getTasks().size());
                        for (Task t : s.getTasks())
                            System.out.println(t.serialize());
                    }

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


    public static boolean passwordChecking(String password, String username){

        if(password.equals(username)){
            return false;
        }
        if(password.length() < 8){
            return false;
        }
        String pat = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).+$";

        Pattern pt = Pattern.compile(pat);
        Matcher mt = pt.matcher(password);

        if(mt.matches())
            return true;
        else return false;

    }
}