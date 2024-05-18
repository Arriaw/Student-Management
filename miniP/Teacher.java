import java.util.ArrayList;
import java.util.List;

public class Teacher {
    private String teacherName;
    private int numberOfCoursesInTerm;
    private List<Course> coursesInTerm = new ArrayList<>();

    public Teacher(String name) {
        this.teacherName = name;
    }

    void addCourse(Course course) {
        coursesInTerm.add(course);
    }
    
    void addStudent(Student student, Course course) {
        boolean flag = false;
        for (int i = 0; i < coursesInTerm.size(); i++)
            if (course == coursesInTerm.get(i)){
                flag = true;
                break;
            }
        if (flag == false){
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
        if (flag2 == true){
            System.out.println("This student is already in the course.");
            return;
        }

        if (flag == true && flag2 == false) {
            course.addStudent(student);
            student.addCourse(course);
        }
    }

    void removeStudent(Student student, Course course){
        boolean flag = false;
        for (int i = 0; i < coursesInTerm.size(); i++)
            if (course == coursesInTerm.get(i)){
                flag = true;
                break;
            }
        if (flag == false){
            System.out.println("This teacher doesn't have this course.");
            return;
        }

        boolean flag2 = false;
        List<Student> studentsInCourse = course.getStudents();
        for (int i = 0; i < studentsInCourse.size(); i++)
            if (student == studentsInCourse.get(i)){
                flag2 = true;
                break;
            }
        if (flag2 == false){
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
        for (int i = 0; i < coursesInTerm.size(); i++)
            if (course == coursesInTerm.get(i)){
                flag = true;
                break;
            }
        if (flag == false){
            System.out.println("This teacher doesn't have this course.");
            return;
        }

        boolean flag2 = false;
        List<Student> studentsInCourse = course.getStudents();
        for (int i = 0; i < studentsInCourse.size(); i++)
            if (student == studentsInCourse.get(i)){
                flag2 = true;
                break;
            }
        if (flag2 == false){
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

    public int getNumberOfCoursesInTerm() {
        return coursesInTerm.size();
    }

    void printCourses() {
        for (int i = 0; i < coursesInTerm.size(); i++){
            System.out.println(coursesInTerm.get(i).getName());
        }
    }
}
