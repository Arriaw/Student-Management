package miniP;

import java.io.Serializable;
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

    Student(String name, String ID, int countStudent){
        studentID = ID;
        studentName = name;
        Random random = new Random();
        Password = LocalDate.now().getYear() + "" +  (random.nextInt(900) + 100) + "" + String.format("%02d", countStudent);
    }

    Student(String name, String ID, String password) {
        studentID = ID;
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
        if (flag == true)
            System.out.println("This student is already in this course.");
        else {
            courses.add(course);
            coursesScore.put(course, 0.0);
            System.out.println("Signed Up successfuly.");
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
    }

    void removeCourse(Course course) {
        courses.remove(course);
        coursesScore.remove(course);
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
}