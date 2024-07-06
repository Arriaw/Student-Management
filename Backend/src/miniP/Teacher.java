package miniP;

import java.io.Serial;
import java.io.Serializable;
import java.util.*;
import java.time.LocalDate;

public class Teacher implements Serializable{

    private String teacherName;
    private String ID;
    private String Password;
    private int numberOfCoursesInTerm;
    private List<Course> coursesInTerm = new ArrayList<>();
    @Serial
    private static final long serialVersionUID = 3333408718653615933L;


    public Teacher(String name, String id, int countTeacher) {
        this.teacherName = name;
        this.ID = id;
        Random random = new Random();
        Password = LocalDate.now().getYear() + "" +  (random.nextInt(900) + 100) + "" + String.format("%02d",countTeacher);
    }

    public Teacher(String name, String id, String password) {
        this.teacherName = name;
        this.ID = id;
        this.Password = password;
    }

    public Teacher() {}

    public String getPasswordHash(){
        return Admin.getSha256(Password);
    }

    void addCourse(Course course) {
        coursesInTerm.add(course);
    }
    
    void addStudent(Student student, Course course) {
        boolean flag = false;
        for (Course value : coursesInTerm)
            if (course == value) {
                flag = true;
                break;
            }
        if (!flag){
            System.out.println("This teacher doesn't have this course.");
            return;
        }
        boolean flag2 = false;
        List<Student> studentsInCourse = course.getStudents();
        for (int i = 0; i < course.getStudentCount(); i++)
            if (student == studentsInCourse.get(i)){
                flag = true;
                break;
            }
        if (flag2){
            System.out.println("This student is already in the course.");
            return;
        }

        if (flag && !flag2) {
            course.addStudent(student);
            student.addCourse(course);
        }
    }

    void removeStudent(Student student, Course course){
        boolean flag = false;
        for (Course c : coursesInTerm)
            if (course == c) {
                flag = true;
                break;
            }
        if (!flag){
            System.out.println("This teacher doesn't have this course.");
            return;
        }

        boolean flag2 = false;
        List<Student> studentsInCourse = course.getStudents();
        for (Student s : studentsInCourse)
            if (student == s) {
                flag2 = true;
                break;
            }
        if (!flag2){
            System.out.println("This student is not in the course.");
            return;
        }

        if (flag == true && flag2 == true){
            student.removeCourse(course);
            course.removeStudent(student);
        }
    }

    void setScore(Student student, Course course, double score){
        boolean flag = false;
        for (Course item : coursesInTerm)
            if (course == item) {
                flag = true;
                break;
            }
        if (!flag){
            System.out.println("This teacher doesn't have this course.");
            return;
        }

        boolean flag2 = false;
        List<Student> studentsInCourse = course.getStudents();
        for (Student value : studentsInCourse)
            if (student == value) {
                flag2 = true;
                break;
            }
        if (!flag2){
            System.out.println("This student is not in the course.");
            return;
        }
        
        student.addScore(course, score);
        course.addScore(student, score);
    }

    void addAssignment(Assignment assignment, Course course) {
        course.addAssignment(assignment);
    }

    void activityOfAssignment(Assignment assignment, boolean activity) {
        assignment.setActive(activity);
    }

    void removeAssignment(Assignment assignment, Course course) {
        course.removeAssignment(assignment);
    }

    public List<Course> getCoursesInTerm() {
        return coursesInTerm;
    }

    void updateNumberOfCourses() {
        numberOfCoursesInTerm = coursesInTerm.size();
    }

    public int getNumberOfCoursesInTerm() {
        updateNumberOfCourses();
        return numberOfCoursesInTerm;
    }

    void printCourses() {
        for (Course course : coursesInTerm)
            System.out.println(course.getName());
    }

    public String getTeacherName() {
        return teacherName;
    }

    public String getPassword() {
        return Password;
    }

    public String getID() {
        return ID;
    }

    @Override
    public String toString() {
        return String.format("Teacher{%s, %s, %s}", teacherName, ID, Password);
    }
}
