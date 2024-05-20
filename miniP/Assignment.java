package miniP;

import java.time.LocalDate;
import java.time.Period;

public class Assignment {
    private String name;
    private String description;
    private double score;
    private Course course;
    private LocalDate deadline;
    private int remainingDays;
    private boolean isActive;


    public Assignment(Course course, String deadline, String name, String description, double score){
        this.course = course;
        this.deadline = LocalDate.parse(deadline);
        this.name = name;
        this.description = description;
        this.score = score;
    }

    public void setDeadline(String deadline) {
        this.deadline = LocalDate.parse(deadline);
    }

    public LocalDate getDeadline() {
        return deadline;
    }

    private void updateRemainingDays() {
        LocalDate currentDate = LocalDate.now();
        remainingDays = Period.between(currentDate, deadline).getDays();
    }

    public void printRemainingDays() {
        if (isActive() == false){
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

    public int getRemainingDays() {
        updateRemainingDays();
        return remainingDays;
    }
}
