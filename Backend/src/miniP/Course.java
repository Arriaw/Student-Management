package miniP;

import java.io.Serializable;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;


public class Course implements Serializable {
    private String ID;
    private int unit;
    private String name;
    private Teacher teacher;
    private boolean isActive;
    private List<Student> students = new ArrayList<>(); 
    private int studentCount;
    private Map<Student, Double> studentScores = new HashMap<>();
    private List<Assignment> assignments;
    private int assignmentsCount;
    private LocalDate examDate;
    private List<Assignment> activeAssignments;
    private Student topStudent;
    private static final long serialVersionUID = -2218181545098944410L;
    public Course(String name, int unit, String examDate, String ID) {
        this.name = name;
        this.unit = unit;
        this.examDate = LocalDate.parse(examDate);
        this.ID = ID;
        assignments = new ArrayList<>();
        activeAssignments = new ArrayList<>();
    }

    public Course(String name, String id) {
        this.name = name;
        ID = id;
        assignments = new ArrayList<>();
        activeAssignments = new ArrayList<>();
    }

    public Course(){}

    public String serialize() {
        return getName() + "," + getTeacher().getTeacherName() + "," + getUnit() + "," + getTopStudent().getStudentName() + "," + getActiveAssignments().size() + '\n';
    }

    void printStudents() {
        for (int i = 0 ; i < students.size(); i++){
            System.out.println(students.get(i).getStudentName());
        }
    }

    void printTopStudents() {
        List<Map.Entry<Student, Double>> sortedEntries = new ArrayList<>(studentScores.entrySet());
        sortedEntries.sort(Map.Entry.comparingByValue(Comparator.reverseOrder()));
        this.topStudent = sortedEntries.getFirst().getKey();
        System.out.println("Top Students in " + name + ":");
        for (int i = 0; i < sortedEntries.size(); i++){
            Map.Entry<Student, Double> entry = sortedEntries.get(i);
            System.out.println("    " + (i+1) + ": Name: " + entry.getKey().getStudentName() + ", Score: " + entry.getValue());
        }
    }

    void addScore(Student student, double score) {
        studentScores.put(student, score);
    }

    public String getName() {
        return name;
    }

    public int getUnit() {
        return unit;
    }

    public List<Student> getStudents() {
        return students;
    }

    void addStudent(Student student) {
        students.add(student);
        studentScores.put(student, 0.0);
//        student.addCourse(this);
    }

    void removeStudent(Student student) {
        students.remove(student);
        studentScores.remove(student);
//        student.removeCourse(this);
    }

    void addAssignment(Assignment assignment) {
        if (assignments == null)
            assignments = new ArrayList<>();
        assignments.add(assignment);
        for (Student s : students) {
            s.addAssignment(assignment);
        }
    }

    void removeAssignment(Assignment assignment) {
        if (assignments == null)
            assignments = new ArrayList<>();
        assignments.remove(assignment);
        for (Student s : students) {
            s.removeAssignment(assignment);
        }
    }

    void updateActiveAssignments() {
        for (int i = 0; i < assignments.size(); i++)
            if (assignments.get(i).isActive())
                activeAssignments.add(assignments.get(i));
    }

    void updateStudentCount() {
        studentCount = students.size();
    }

    void updateAssignmentCount() {
        assignmentsCount = assignments.size();
    }

    public List<Assignment> getActiveAssignments() {
        return activeAssignments;
    }

    public List<Assignment> getAssignments() {
        return assignments;
    }

    public int getAssignmentsCount() {
        return assignmentsCount;
    }

    public LocalDate getExamDate() {
        return examDate;
    }

    public Teacher getTeacher() {
        return teacher;
    }

    public int getStudentCount() {
        updateStudentCount();
        return studentCount;
    }

    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }

    public boolean isActive() {
        return isActive;
    }

    public String getID() {
        return ID;
    }

    public void setTeacher(Teacher teacher) {
        this.teacher = teacher;
    }

    public Student getTopStudent() {
        List<Map.Entry<Student, Double>> sortedEntries = new ArrayList<>(studentScores.entrySet());
        sortedEntries.sort(Map.Entry.comparingByValue(Comparator.reverseOrder()));
        if(sortedEntries.getFirst().getKey() == null){
            System.out.println("it is null!");
            this.topStudent = new Student("هیچ کس", "0", 0,Term.Spring1402_1403);
        }else
            this.topStudent = sortedEntries.getFirst().getKey();
        return topStudent;
    }
}
