import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;


public class Course {
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
    private List<Assignment> activAssignments;

    public Course(String name, int unit, String examDate) {
        this.name = name;
        this.unit = unit;
        this.examDate = LocalDate.parse(examDate);
    }

    void printStudents() {
        for (int i = 0 ; i < students.size(); i++){
            System.out.println(students.get(i).getStudentName());
        }
    }

    void printTopStudents() {
        List<Map.Entry<Student, Double>> sortedEntries = new ArrayList<>(studentScores.entrySet());
        sortedEntries.sort(Map.Entry.comparingByValue(Comparator.reverseOrder()));

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
    }

    void removeStudent(Student student) {
        students.remove(student);
    }

    void addAssignment(Assignment assignment) {
        assignments.add(assignment);
    }

    void removeAssignment(Assignment assignment) {
        assignments.remove(assignment);
    }

    void updateActiveAssignments() {
        for (int i = 0; i < assignments.size(); i++)
            if (assignments.get(i).isActive())
                activAssignments.add(assignments.get(i));
    }

    void updateStudentCount() {
        studentCount = students.size();
    }

    void updateAssignmentCount() {
        assignmentsCount = assignments.size();
    }

    public List<Assignment> getActivAssignments() {
        return activAssignments;
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

    public void setTeacher(Teacher teacher) {
        this.teacher = teacher;
    }
}
