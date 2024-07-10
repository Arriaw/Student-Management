package miniP;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.ServerSocket;
import java.net.Socket;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class Server {
    public static void main(String[] args) throws IOException {
        ServerSocket ss8080 = new ServerSocket(8080);
        ServerSocket ss4050 = new ServerSocket(4050);
//        while (true) {
//            System.out.println("The server is starting ...");
//            new ClientHandler(ss8080.accept()).start();
//        }
//        System.out.println("The server is starting ...");

        new Thread(() -> {

            try{
                while (true) {
                    new ClientHandler(ss8080.accept()).start();
                    System.out.println("server on port 8080 is starting ...");
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }).start();


        new Thread(() -> {

            try{
                while (true) {
                    new ClientHandler2(ss4050.accept()).start();
                    System.out.println("server on port 4050 is starting ...");
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }).start();
    }
}




class ClientHandler extends Thread{

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
//            query = dis.readUTF();
            System.out.println(query);
            String[] queryArr = query.split("~");
            System.out.println("the query is : " + query);


            switch (queryArr[0]){
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
                            info = st.getStudentName() + "~دانشجو~" + st.getSID() + "~" +st.getCurrentTerm() + '~' + st.getNumberOfUnits2() + '~' + st.getAverageScore2()  + '~' + st.getImage();
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


                case "changeFields":

                    System.out.println("I'm here ch");

                    students = Admin.retrieveData(Student.class);

                    Student student = null;

                    Class<?> clazz = Student.class;
                    Field[] fields = clazz.getDeclaredFields();



                    String filed = queryArr[1];
                    sid = queryArr[2];
                    String newValue = queryArr[3];

                    for(Student st : students){
                        if(st.getSID().equals(sid)){
                            student = st;
                            break;
                        }
                    }

                    for(Field spField : fields){
                        if(spField.getName().equals(filed)){
                            Admin.removeData(student);
                            String setterName = "set" + Character.toUpperCase(filed.charAt(0)) + filed.substring(1);
                            Method setterMethod  = clazz.getMethod(setterName, spField.getType());
                            setterMethod.invoke(student, newValue);
                            Admin.addData(student);
                        }
                    }

                    dos.writeBytes("200");
                    dos.close();
                    System.out.println("200");
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
                case "getClasses":
                    sid = queryArr[1];
                    students = Admin.retrieveData(Student.class);
                    List<Course> courses = new ArrayList<>();

                    try {
                        for (Student s : students) {
                            if (s.getSID().equals(sid)) {
                                System.out.println("Student found");
                                courses = s.getCourses();
                                break;
                            }
                        }
                        if (courses.isEmpty()) {
                            dos.writeUTF("404");
                            System.out.println("No courses available for SID: " + sid);
                        } else {
                            for (Course c : courses) {
                                dos.writeUTF(c.serialize());
                                System.out.println(c.serialize());
                            }
                        }
                        dos.flush();
                    } catch (IOException e) {
                        System.err.println("Error handling getClass request: " + e.getMessage());
                    } finally {
                        try {
                            dos.flush();
                            dos.close();
                            dis.close();
                        } catch (IOException e) {
                            System.err.println("Error closing streams: " + e.getMessage());
                        }
                    }
                    break;
                case "addClass":
                    sid = queryArr[1];
                    String courseID = queryArr[2];
                    courses = Admin.retrieveData(Course.class);
                    students = Admin.retrieveData(Student.class);
                    boolean courseFound = false;
                    Course course = new Course();
                    for (Course c : courses){
                        if (c.getID().equals(courseID)) {
                            course = c;
                            courseFound = true;
                            break;
                        }
                    }
                    if (!courseFound) {
                        dos.writeBytes("404");
                        dos.flush();
                        dos.close();
                        System.out.println("No course with this ID in database.");
                        System.out.println("404");
                    } else {
                        List<Course> sCourses = new ArrayList<>();
                        for (Student s : students) {
                            if (s.getSID().equals(sid)) {
                                sCourses = s.getCourses();
                                break;
                            }
                        }

                        courseFound = false;
                        for (Course c : sCourses) {
                            if (c.getID().equals(course.getID())) {
                                courseFound = true;
                                break;
                            }
                        }

                        if (courseFound) {
                            System.out.println("Already in this course");
                            dos.writeBytes("400");
                            dos.flush();
                            dos.close();
                            System.out.println("400");
                        }
                        else {
                            for (Student s : students) {
                                if (s.getSID().equals(sid)) {
                                    s.getCourses().add(course);
                                    Admin.updateData(s);
                                    Admin.updateData(course);
                                    break;
                                }
                            }
                            dos.writeBytes("200");
                            dos.flush();
                            dos.close();
                            System.out.println("Course added successfully");
                            System.out.println("200");
                        }
                    }
//                    dos.flush();
//                    dos.close();

                    break;
                case "classInfo" :
                    courseID = queryArr[1];
                    courses = Admin.retrieveData(Course.class);

                    try {
                        for (Course c :courses) {
                            if (c.getID().equals(courseID)) {
                                dos.writeUTF(c.serialize());
                                dos.flush();
                                System.out.println(c.serialize());
                                break;
                            }
                        }
                    } catch (IOException e) {
                        System.err.println("Error handling classInfo request: " + e.getMessage());
                    } finally {
                        try {
                            dos.close();
                            dis.close();
                        } catch (IOException e) {
                            System.err.println("Error closing streams: " + e.getMessage());
                        }
                    }
                    break;
                case "getAllAssignments":
                    sid = queryArr[1];
                    students = Admin.retrieveData(Student.class);
                    List<Assignment> assignments =  new ArrayList<>();

                    try {
                        for (Student s : students) {
                            if (s.getSID().equals(sid)) {
                                System.out.println("Student found");
                                assignments = s.getAssignments();
                                break;
                            }
                        }

                        if (assignments.isEmpty()) {
                            dos.writeBytes("404");
                            System.out.println("No tasks available for SID: " + sid);
                        } else {
                            for (Assignment a : assignments) {
                                dos.writeUTF(a.serializeAll());
                                System.out.println(a.serializeAll());
                            }
                        }

                        dos.flush();
                    } catch (IOException e) {
                        System.err.println("Error handling getAssignments request: " + e.getMessage());
                    } finally {
                        try {
                            dos.close();
                            dis.close();
                        } catch (IOException e) {
                            System.err.println("Error closing streams: " + e.getMessage());
                        }
                    }
                    break;

                case "getNotFinishedAssignments":
                    sid = queryArr[1];
                    students = Admin.retrieveData(Student.class);
                    assignments =  new ArrayList<>();

                    try {
                        for (Student s : students) {
                            if (s.getSID().equals(sid)) {
                                System.out.println("Student found");
                                assignments = s.getNotFinishedAssignments();
                                break;
                            }
                        }

                        if (assignments.isEmpty()) {
                            dos.writeBytes("404");
                            System.out.println("No tasks available for SID: " + sid);
                        } else {
                            for (Assignment a : assignments) {
                                dos.writeUTF(a.serializeNotFinished());
                                System.out.println(a.serializeNotFinished());
                            }
                        }

                        dos.flush();
                    } catch (IOException e) {
                        System.err.println("Error handling getNotFinishedAssignments request: " + e.getMessage());
                    } finally {
                        try {
                            dos.close();
                            dis.close();
                        } catch (IOException e) {
                            System.err.println("Error closing streams: " + e.getMessage());
                        }
                    }
                    break;


                case "getAssignmentsCount":

                    sid = queryArr[1];
                    students = Admin.retrieveData(Student.class);
                    assignments =  new ArrayList<>();
                    int count = 0 ;

                    try {
                        for (Student s : students) {
                            if (s.getSID().equals(sid)) {
                                System.out.println("Student found");
                                assignments = s.getAssignments();
                                break;
                            }
                        }

                        if (assignments.isEmpty()) {
                            dos.writeBytes("0");
                            System.out.println("No tasks available for SID: " + sid);
                        } else {
                            dos.writeBytes(String.valueOf((assignments.size())));
                        }

                        dos.flush();
                    } catch (IOException e) {
                        System.err.println("Error handling getAssignments request: " + e.getMessage());
                    } finally {
                        try {
                            dos.close();
                            dis.close();
                        } catch (IOException e) {
                            System.err.println("Error closing streams: " + e.getMessage());
                        }
                    }
                    break;

                case "getBestScore":
                    students = Admin.retrieveData(Student.class);
                    student = null;
                    sid = queryArr[1];

                    double maxScore = 0;

                    for(Student s : students){
                        if(s.getSID().equals(sid)){
                            student = s;
                        }
                    }

                    Map<Course, Double> cscore = student.getCoursesScore();

                    Set<Course> keys = cscore.keySet();

                    for(Course c: keys){
                        if(cscore.get(c) > maxScore){
                            maxScore = cscore.get(c);
                        }
                    }

                    dos.writeBytes(String.valueOf(maxScore));
                    dos.flush();
                    dos.close();
                    break;

                case "getWorthScore":
                    students = Admin.retrieveData(Student.class);
                    student = null;
                    sid = queryArr[1];

                    double minScore = 0;

                    for(Student s : students){
                        if(s.getSID().equals(sid)){
                            student = s;
                        }
                    }

                    cscore = student.getCoursesScore();

                    keys = cscore.keySet();

                    for(Course c: keys){
                        if(cscore.get(c) < minScore){
                            maxScore = cscore.get(c);
                        }
                    }

                    dos.writeBytes(String.valueOf(minScore));
                    dos.flush();
                    dos.close();
                    break;

                case "getActiveAssignments" :
                    sid = queryArr[1];
                    students = Admin.retrieveData(Student.class);
                    assignments =  new ArrayList<>();

                    try {
                        for (Student s : students) {
                            if (s.getSID().equals(sid)) {
                                System.out.println("Student found");
                                assignments = s.getAssignments();
                                break;
                            }
                        }

                        if (assignments.isEmpty()) {
                            dos.writeBytes("404");
                            System.out.println("No tasks available for SID: " + sid);
                        } else {
                            for (Assignment a : assignments) {
                                if(a.isActive()) {
                                    dos.writeUTF(a.getName());
                                    System.out.println(a.serializeAll());
                                }
                            }
                        }

                        dos.flush();
                    } catch (IOException e) {
                        System.err.println("Error handling getAssignments request: " + e.getMessage());
                    } finally {
                        try {
                            dos.close();
                            dis.close();
                        } catch (IOException e) {
                            System.err.println("Error closing streams: " + e.getMessage());
                        }
                    }
                    break;



            }
        } catch (IOException | InvocationTargetException | NoSuchMethodException | IllegalAccessException e) {
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
class ClientHandler2 extends Thread{

    DataOutputStream dos;
    DataInputStream dis;
    Socket socket;

    ClientHandler2(Socket socket) throws IOException {
        this.socket = socket;
        dis = new DataInputStream(socket.getInputStream());
        dos = new DataOutputStream(socket.getOutputStream());
    }

    @Override
    public void run() {
        super.run();

        try {


//            String query = "";

            byte[] bytes = new byte[1024]; // Adjust the size as needed

            int length = dis.read(bytes);
            String query = new String(bytes, 0, length, "UTF-8");
            query = query.substring(0, query.length()-1);

            System.out.println("Received query: " + query);
            String[] queryArr = query.split("-");

//            int index = dis.read();
//
//            while (index != 0){
//                query += (char)index;
//                index = dis.read();
//            }
//            query = dis.readUTF();
//            System.out.println(query);
//            String[] queryArr = query.split("-");
//            System.out.println("the query is : " + query);


            switch (queryArr[0]){

                case "changeFields":

                    System.out.println("I'm here ch");

                    ArrayList<Student> students = Admin.retrieveData(Student.class);

                    Student student = null;

                    Class<?> clazz = Student.class;
                    Field[] fields = clazz.getDeclaredFields();



                    String filed = queryArr[1];
                    String sid = queryArr[2];
                    String newValue = queryArr[3];

                    for(Student st : students){
                        if(st.getSID().equals(sid)){
                            student = st;
                            break;
                        }
                    }



                    for(Field spField : fields){
                        if(spField.getName().equals(filed)){
                            Admin.removeData(student);
                            String setterName = "set" + Character.toUpperCase(filed.charAt(0)) + filed.substring(1);
                            Method setterMethod  = clazz.getMethod(setterName, spField.getType());
                            if(spField.getType() == int.class){
                                int val = Integer.parseInt(newValue);
                                setterMethod.invoke(student, val);
                            }else if(spField.getType() == double.class){
                                double val = Double.parseDouble(newValue);
                                setterMethod.invoke(student, val);
                            }else{
                                setterMethod.invoke(student, newValue);
                            }
                            Admin.addData(student);
                        }
                    }

                    dos.writeBytes("200");
                    dos.close();
                    System.out.println("200");
                    break;


                case "SignUp":
                    String name = queryArr[2];
                    String studentId = queryArr[1];
                    String path = "unknown";

                    Student studentNew = new Student(name, studentId, Admin.retrieveData(Student.class).size(), Term.بهار۱۴۰۲ـ۱۴۰۳,path);
                    if(Admin.addData(studentNew)) {
                        String stSID = studentNew.getSID();
                        dos.writeBytes(stSID);
                        dos.flush();
                        dos.close();
                        System.out.println(stSID);
                    }else{
                        dos.writeBytes("401");
                        dos.flush();
                        dos.close();
                    }
                    break;




            }
        } catch (IOException | InvocationTargetException | NoSuchMethodException | IllegalAccessException e) {
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
