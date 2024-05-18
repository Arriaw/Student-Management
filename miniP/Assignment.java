import java.time.LocalDate;
import java.time.Period;

public class Assignment {
    private Course course;
    private LocalDate deadline;
    private int remainingDays;
    private boolean isActive;


    public Assignment(Course course, String deadline){
        this.course = course;
        this.deadline = LocalDate.parse(deadline);
    }

    public LocalDate getDeadline() {
        return deadline;
    }

    public void setRemainingDays() {
        LocalDate currentDate = LocalDate.now();
        remainingDays = Period.between(currentDate, deadline).getDays();
    }

    public void printRemainingDays() {
        setRemainingDays();
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
}
