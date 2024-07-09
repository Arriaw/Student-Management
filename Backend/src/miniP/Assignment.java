package miniP;

import java.io.Serializable;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Assignment implements Serializable {
    private String name;
    private String description;
    private double score;
    private Course course;
    private LocalDateTime deadline;
    private long remainingDays;
    private boolean isActive;

    public Assignment(Course course, String deadline, String name, String description, double score){
        this.course = course;
        this.deadline = LocalDateTime.parse(deadline);
        this.name = name;
        this.description = description;
        this.score = score;
    }

    public String serializeNotFinished() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
        return name + "," + description + "," +  deadline.format(formatter) + "," + "false," + score + '\n';
    }

    public String serializeAll() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
        return name + "," + description + "," +  deadline.format(formatter) + "," + "false," + score + '\n';
    }

    public void setDeadline(String deadline) {
        this.deadline = LocalDateTime.parse(deadline);
    }

    public LocalDateTime getDeadline() {
        return deadline;
    }

    private void updateRemainingDays() {
        LocalDateTime currentDate = LocalDateTime.now();
        remainingDays = Duration.between(currentDate, deadline).toDays();
    }

    public void printRemainingDays() {
        if (!isActive()){
            System.out.println("This assignment is not active yet.");
            return;
        }
        updateRemainingDays();
        if (remainingDays > 0)
            System.out.println("You have " + remainingDays + " days to do the assignment.");
        else if (remainingDays == 0)
            System.out.println("Deadline is today !!");
        else
            System.out.println("deadline has already ended :(");
    }

    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }

    public boolean isActive() {
        return isActive;
    }

    public Course getCourse() {
        return course;
    }

    public String getDescription() {
        return description;
    }

    public String getName() {
        return name;
    }

    public double getScore() {
        return score;
    }

    public long getRemainingDays() {
        updateRemainingDays();
        return remainingDays;
    }
}
