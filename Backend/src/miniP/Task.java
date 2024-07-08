package miniP;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Task implements Serializable {
    private static final long serialVersionUID = 1L;
    private String title;
    private LocalDateTime dueDate;
    private boolean isDone;

    public Task(String title, LocalDateTime dueDate, boolean isDone) {
        this.title = title;
        this.dueDate = dueDate;
        this.isDone = isDone;
    }

    public LocalDateTime getDueDate() {
        return dueDate;
    }

    public String getTitle() {
        return title;
    }

    public String serialize() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
        return title + "," + dueDate.format(formatter) + "," + isDone + '\n';
    }

    public void setDone(boolean isDone) {
        this.isDone = isDone;
    }
}
