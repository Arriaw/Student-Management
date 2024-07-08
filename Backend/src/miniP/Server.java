package miniP;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class Server {
    public static void main(String[] args) throws IOException {
        ServerSocket ss = new ServerSocket(8080);
        while (true) {
            System.out.println("The server is starting ...");
            new ClientHandler(ss.accept()).start();
        }
    }
}

class ClientHandler extends Thread {
    DataOutputStream dos;
    DataInputStream dis;
    Socket socket;
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");

    ClientHandler(Socket socket) throws IOException {
        this.socket = socket;
        dis = new DataInputStream(socket.getInputStream());
        dos = new DataOutputStream(socket.getOutputStream());
    }

    @Override
    public void run() {
        super.run();

        try {
            String query = "";

            int index = dis.read();

            while (index != 0){
                query += (char)index;
                index = dis.read();
            }
//            System.out.println(query);
            String[] queryArr = query.split("~");
            System.out.println("the query is : " + query);

            switch (queryArr[0]) {
                case "LoginChecker":
                    boolean usernameC = false;
                    boolean passwordC = false;

                    ArrayList<Student> students = Admin.retrieveData(Student.class);

                    for(Student student: students){
//                        System.out.println(student.getUsername());
                        if(student.getUsername().equals(queryArr[1])){
                            usernameC = true;
                            if(student.getPassword().equals(queryArr[2])){
                                passwordC = true;
                            }
                        }
                    }

                    if(!usernameC){
                        dos.writeBytes("404");
                        dos.flush();
                        System.out.println("404");
                    }
                    else if(usernameC & !passwordC){
                        dos.writeBytes("401");
                        dos.flush();
                        System.out.println("401");
                    }
                    else if(usernameC & passwordC){
                        dos.writeBytes("200");
                        dos.flush();
                        System.out.println("200");
                    }

                    dos.close();
                    dis.close();

                    break;

                case "getUserInfo" :
                    students = Admin.retrieveData(Student.class);
                    String sid = queryArr[1];
                    String info = "";

                    for(Student st : students){
                        if(st.getSID().equals(sid)){
                            info = st.getStudentName() + "~دانشجو~" + st.getSID() + "~" +st.getCurrentTerm() + '~' + st.getNumberOfUnits() + '~' + st.getAverageScore();
                        }
                    }
//                    System.out.println("the info is : " + info);
                    dos.writeUTF(info);
//                    dos.writeBytes(info);
                    dos.flush();
                    dos.close();
                    dis.close();
                    break;

                case "changePassword":
                    students = Admin.retrieveData(Student.class);
                    sid = queryArr[1];
                    String passwordUserR = queryArr[2];
                    String newPasswordUserR = queryArr[3];
                    System.out.println(sid + "~" + passwordUserR + "~" + newPasswordUserR);

                    for(Student s : students){
                        if(s.getSID().equals(sid)){
                            if(s.getPassword().equals(passwordUserR)){
                                if(Cli.passwordChecking(newPasswordUserR, s.getUsername())){
                                    s.setPassword(newPasswordUserR);
                                    dos.writeBytes("200"); //password changed successfully
                                    dos.flush();
                                    dos.close();
                                    System.out.println("200");
                                }else{
                                    dos.writeBytes("402");// new password is weak
                                    dos.flush();
                                    dos.close();
                                    System.out.println("402");
                                }
                            }else{
                                dos.writeBytes("401");// old password is wrong
                                dos.flush();
                                dos.close();
                                System.out.println("401");
                            }
                        }
                    }
                    dis.close();
                    break;

                case "removeAccount":
                    sid = queryArr[1];
                    students = Admin.retrieveData(Student.class);
                    boolean res = false;

                    for (Student s: students){
                        if(s.getSID().equals(sid)){
                            res = Admin.removeData(s);
                        }
                    }
                    if(res) {
                        dos.writeBytes("200");
                        dos.close();
                        System.out.println("200");
                    }else{
                        dos.writeBytes("401");
                        dos.close();
                        System.out.println("401");
                    }

                    dis.close();
                    break;
                case "getTasks":
                    sid = queryArr[1];
                    students = Admin.retrieveData(Student.class);
                    List<Task> tasks =  new ArrayList<>();

                    try {
                        for (Student s : students) {
                            if (s.getSID().equals(sid)) {
                                System.out.println("Student found");
                                tasks = s.getTasks();
                                break;
                            }
                        }

                        if (tasks.isEmpty()) {
                            dos.writeBytes("404");
                            System.out.println("No tasks available for SID: " + sid);
                        } else {
                            for (Task t : tasks) {
                                dos.writeUTF(t.serialize());
                                System.out.println(t.serialize());
                            }
                        }

                        dos.flush();
                    } catch (IOException e) {
                        System.err.println("Error handling getTasks request: " + e.getMessage());
                    } finally {
                        try {
                            dos.close();
                            dis.close();
                        } catch (IOException e) {
                            System.err.println("Error closing streams: " + e.getMessage());
                        }
                    }
                    break;
                case "addTask":
                    sid = queryArr[1];
                    String taskTitle = queryArr[2];
                    LocalDateTime dueDate = LocalDateTime.parse(queryArr[3], formatter);
                    boolean isDone = Boolean.parseBoolean(queryArr[4]);
                    Task newTask = new Task(taskTitle, dueDate, isDone);
                    System.out.println(newTask.serialize());
                    students = Admin.retrieveData(Student.class);

                    for (Student s : students) {
                        if (s.getSID().equals(sid)) {
                            s.getTasks().add(newTask);
                            Admin.updateData(s);
                            break;
                        }
                    }

                    dos.writeUTF("Task added successfully");
                    dos.flush();
                    break;
                case "toggleTask":
                    sid = queryArr[1];
                    taskTitle = queryArr[2];
                    dueDate = LocalDateTime.parse(queryArr[3], formatter);
                    isDone = Boolean.parseBoolean(queryArr[4]);

                    students = Admin.retrieveData(Student.class);

                    for (Student s : students) {
                        if (s.getSID().equals(sid)) {
                            for (Task t : s.getTasks()) {
                                if (t.getTitle().equals(taskTitle) && t.getDueDate().equals(dueDate)) {
                                    t.setDone(isDone);
                                    Admin.updateData(s);
                                    break;
                                }
                            }
                            break;
                        }
                    }

                    dos.writeUTF("Task toggled successfully");
                    dos.flush();
                    break;
                case "deleteTask":
                    sid = queryArr[1];
                    taskTitle = queryArr[2];
                    dueDate = LocalDateTime.parse(queryArr[3], formatter);

                    students = Admin.retrieveData(Student.class);

                    for (Student s : students) {
                        if (s.getSID().equals(sid)) {
                            s.getTasks().removeIf(t -> t.getTitle().equals(taskTitle) && t.getDueDate().equals(dueDate));
                            Admin.updateData(s);
                            break;
                        }
                    }

                    dos.writeUTF("Task deleted successfully");
                    dos.flush();
                    break;
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {
            try {
                if(dis != null)  dis.close();
                if(dos != null) dos.close();
                if(socket != null) socket.close();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
    }
}