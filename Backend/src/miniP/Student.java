package miniP;

import java.io.File;
import java.io.IOException;
import java.io.Serial;
import java.io.Serializable;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.*;

public class Student implements Serializable{
    private String studentName;
    private String studentID;
    private String Password;
    private int numberOfCourses;
    private int numberOfUnits;
    private List<Course> courses = new ArrayList<>();
    private Map<Course, Double> coursesScore = new HashMap<>();
    private double averageScore;
    @Serial
    private static final long serialVersionUID = -6167696272662230747L;
    private String username = "";
    private Term currentTerm;
    private String SID;
    private String Image;
    private List<Task> tasks = new ArrayList<>();
    private List<Assignment> assignments = new ArrayList<>();
    private List<Assignment> notFinishedAssignments = new ArrayList<>();

    Student(String name, String ID, int countStudent, Term currentTerm, String path){
        studentID = ID;
        studentName = name;
        Random random = new Random();
        SID = LocalDate.now().getYear() + "" +  (random.nextInt(900) + 100) + "" + String.format("%02d", countStudent);
        Password = studentID;
        this.username = SID;
        this.currentTerm = currentTerm;

        if(new File(path).exists()){
            String[] dir = path.split("/");
            String typeFile = dir[dir.length -1].split("\\.")[1];
            try {
                Files.copy(Paths.get(path), Paths.get("Images/" + SID + "." + typeFile));
                Image = "/Images/" + SID + "." + typeFile;
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }else{
            System.out.println("the Image does not exist");
            Image = "/Images/IconPerson.jpg";

        }
    }


    Student(String name, String ID, int countStudent, Term currentTerm){
        studentID = ID;
        studentName = name;
        Random random = new Random();
        SID = LocalDate.now().getYear() + "" +  (random.nextInt(900) + 100) + "" + String.format("%02d", countStudent);
        Password = studentID;
        this.username = SID;
        this.currentTerm = currentTerm;
        Image = "/Images/IconPerson.jpg";
    }

    Student(String name, String SID, String password) {
        this.SID = SID;
        studentName = name;
        Password = password;
    }


    Student() {}
    void printRecord() {
        System.out.println("Student Record:");
        System.out.println("    Number of courses: " + getNumberOfCourses());
        System.out.println("    Number of Units: " + getNumberOfUnits());
        System.out.println("    Courses Taken:");
        for (Map.Entry<Course, Double> entry : coursesScore.entrySet())
            System.out.println("        " + entry.getKey().getName() + ": " + entry.getValue());

        System.out.println("    Average Score: " + getAverageScore());
    }

    void printCourses() {
        for (int i = 0; i < courses.size(); i++)
            System.out.println(courses.get(i).getName());
    }

    void signUpInCourse(Course course){
        boolean flag = false;
        for (int i = 0; i < courses.size(); i++)
            if (courses.get(i) == course){
                flag = true;
                break;
            }
        if (flag)
            System.out.println("This student is already in this course.");
        else {
            courses.add(course);
            coursesScore.put(course, 0.0);
            System.out.println("Signed Up successfully.");
        }
    }

    private void updateNumberOfCourses() {
        numberOfCourses = courses.size();
    }

    private void updateNumberOfUnits() {
        int sum = 0;
        for (int i = 0; i < courses.size(); i++)
            sum += courses.get(i).getUnit();

        numberOfUnits = sum;
    }

    Course topCourse() {
        if (getNumberOfCourses() == 0)
            return null;

        Map.Entry<Course, Double> maxEntry = null;
        for (Map.Entry<Course, Double> entry : coursesScore.entrySet())
            if (maxEntry == null || entry.getValue().compareTo(maxEntry.getValue()) > 0)
                maxEntry = entry;

        return maxEntry.getKey();
    }

    Course worstCourse() {
        if (getNumberOfCourses() == 0)
            return null;

        Map.Entry<Course, Double> minEntry = null;
        for (Map.Entry<Course, Double> entry : coursesScore.entrySet())
            if (minEntry == null || entry.getValue().compareTo(minEntry.getValue()) < 0)
                minEntry = entry;

        return minEntry.getKey();
    }

    void addCourse(Course course) {
        courses.add(course);
        coursesScore.put(course, 0.0);
        course.addStudent(this);
    }

    void removeCourse(Course course) {
        courses.remove(course);
        coursesScore.remove(course);
        course.removeStudent(this);
    }

    void addScore(Course course, double score) {
        coursesScore.put(course, score);
    }

    private void updateAverage() {
        if (coursesScore.isEmpty()){
            averageScore = 0.0;
            return;
        }

        double sum = 0.0;
        for (Map.Entry<Course, Double> entry : coursesScore.entrySet()) {
            sum += entry.getValue() * entry.getKey().getUnit();
        }

        averageScore = sum / getNumberOfUnits();
    }

    public List<Course> getCourses() {
        return courses;
    }

    public double getAverageScore() {
        updateAverage();
        return averageScore;
    }

    public String getStudentName() {
        return studentName;
    }

    public String getStudentID() {
        return studentID;
    }

    public int getNumberOfUnits() {
        updateNumberOfUnits();
        return numberOfUnits;
    }

    public int getNumberOfCourses() {
        updateNumberOfCourses();
        return numberOfCourses;
    }

    public String getPassword() {
        return Password;
    }

    public void setPassword(String newPassword){
        Admin.removeData(this);
        Password = newPassword;
        Admin.addData(this);
    }

    public Term getCurrentTerm(){return currentTerm;}

    public String getUsername(){return username;}

    public String getSID(){return SID;}

    public String getImage(){return Image;}

    public void setStudentName(String name){studentName =  name;}

    public void setSID(String sid_sp){
        SID = sid_sp;
        username = sid_sp;
    }

    public void setUsername(String us){
        username = us;
        setSID(us);
    }

    public void setNumberOfUnits(int nunit){numberOfUnits = nunit;}
    public int getNumberOfUnits2(){return numberOfUnits;}

    public void setAverageScore(double avgs){averageScore = avgs;}
    public double getAverageScore2(){return averageScore;}


    public List<Task> getTasks() {
        return tasks;
    }

    public void addTask(Task task) {
        this.tasks.add(task);
    }

    public List<Assignment> getAssignments() {
//        for (Course c : getCourses()) {
//            if (!c.getAssignments().isEmpty()) {
//                assignments.addAll(c.getAssignments());
//            }
//        }
        return assignments;
    }

    void addAssignment(Assignment assignment) {
        assignments.add(assignment);
    }
    public List<Assignment> getNotFinishedAssignments() {
        return notFinishedAssignments;
    }
}