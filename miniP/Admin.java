package miniP;
import java.io.*;
import java.util.ArrayList;
import java.util.Scanner;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Admin {
    private static Admin admin;
    private Admin(){}

    public static Admin getInstance(){
        if (admin == null){
            admin  = new Admin();
        }
        return admin;
    }

    public static String  getSha256(String pass){
        try {
            MessageDigest msg =  MessageDigest.getInstance("SHA-256");
            byte[] bytes = msg.digest(pass.getBytes());

            StringBuilder str = new StringBuilder();
            for(byte b : bytes){
                String hex = Integer.toHexString(0xff & b);
                if(hex.length() == 1) str.append('0');
                str.append(hex);
            }

            return str.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }

    }

    public boolean Authentication(String option){
        System.out.println("Please choose: ");
        System.out.println("""
                
                    1. Login
                
                    2. Logout
                
                """);
        boolean flag = false;
        Scanner input = new Scanner(System.in);

        while(true){
            if (flag)
                option = input.nextLine();

            flag = false;

            String password = "b0b43848cd45d81f2fab9252f57408c3b1d10c3028521a65fa16a398b96c18b8";
            switch (option) {

                case "Login":
                    String pass = input.nextLine();
                    if (password.equals(getSha256(pass)) ) return true;
                    return false;
                case "Logout":
                    System.out.println("Are you sure ?");
                    if(input.nextLine().equals("yes") | input.nextLine().equals("Yes") | input.nextLine().equals("YES")) return true;
                    return false;
                default:
                    flag = true;
                    System.out.println("Invalid option!!");
                    System.out.println("Please choose: ");
                    System.out.println("""
                    
                    1. Login
                    2. Logout
                    
                    """);
            }

            if (!flag)
                break;
        }

        return flag;
    }

    public static <T extends Serializable> boolean addData(T data) {
        String filename = "Files/" + data.getClass().getSimpleName() + "s.txt";
        boolean fileExists = new File(filename).exists();

        try (FileOutputStream fileOutputStream = new FileOutputStream(filename, true);
             ObjectOutputStream objectOutputStream = fileExists ?
                     new AppendableObjectOutputStream(fileOutputStream) :
                     new ObjectOutputStream(fileOutputStream)) {
            ArrayList<T> objects = (ArrayList<T>) Admin.retrieveData(data.getClass());
            boolean flag = false;
            if (data instanceof Teacher) {
                ArrayList<Teacher> teachers = (ArrayList<Teacher>) objects;
                Teacher teacher = (Teacher) data;
                for (Teacher t : teachers) {
                    if (t.getTeacherName().equals(teacher.getTeacherName())
                            && t.getID().equals(teacher.getID())) {
                        flag = true;
                        break;
                    }
                    if (t.getID().equals(teacher.getID())) {
                        System.out.println("ID is already taken by another teacher.");
                        return false;
                    }
                }
                if (flag) {
                    System.out.println("Teacher is already added.");
                    return false;
                }
            }
            else if (data instanceof Student) {
                ArrayList<Student> students = (ArrayList<Student>) objects;
                Student student = (Student) data;
                for (Student s : students) {
                    if (s.getStudentName().equals(student.getStudentName())
                            && s.getStudentID().equals(student.getStudentID())) {
                        flag = true;
                        break;
                    }
                    if (s.getStudentID().equals(student.getStudentID())) {
                        System.out.println("ID is already taken by another student.");
                        return false;
                    }
                }
                if (flag) {
                    System.out.println("Student is already added.");
                    return false;
                }
            }
            else if (data instanceof Course) {
                ArrayList<Course> courses = (ArrayList<Course>) objects;
                Course course = (Course) data;
                for (Course c : courses) {
                    if (c.getName().equals(course.getName())
                            && c.getID().equals(course.getID())) {
                        flag = true;
                        break;
                    }
                    if (c.getID().equals(course.getID())) {
                        System.out.println("ID is already taken by another course.");
                        return false;
                    }
                }
                if (flag) {
                    System.out.println("Course is already added.");
                    return false;
                }
            }
            objectOutputStream.writeObject(data);
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }

        return true;
    }

    public static <T extends Serializable> boolean removeData(T data) {
        ArrayList<T> objects = (ArrayList<T>) Admin.retrieveData(data.getClass());
        boolean flag = false;

        if (data instanceof Teacher teacher) {
            for (T obj : objects) {
                Teacher t = (Teacher) obj;
                if (t.getTeacherName().equals(teacher.getTeacherName())
                        && t.getID().equals(teacher.getID())
                        && t.getPassword().equals(teacher.getPassword())) {
                    flag = true;
                    objects.remove(t);
                    break;
                }
            }
        }
        else if (data instanceof Course course) {
            for (T obj : objects) {
                Course c = (Course) obj;
                if (c.getName().equals(course.getName())
                        && c.getID().equals(course.getID())) {
                    flag = true;
                    objects.remove(c);
                    break;
                }
            }
        }
        else if (data instanceof Student student) {
            for (T obj : objects) {
                Student s = (Student) obj;
                if (s.getStudentName().equals(student.getStudentName())
                        && s.getStudentID().equals(student.getStudentID())
                        && s.getPassword().equals(student.getPassword())) {
                    flag = true;
                    objects.remove(s);
                    break;
                }
            }
        }

        if (!flag) {
            System.out.println("There is no " + data.getClass().getSimpleName().toLowerCase() + " with this data.");
            return false;
        }
        String filename = "Files/" + data.getClass().getSimpleName() + "s.txt";

        try (FileOutputStream fileOutputStream = new FileOutputStream(filename);
             ObjectOutputStream objectOutputStream = new ObjectOutputStream(fileOutputStream)) {
            for (T obj : objects) {
                objectOutputStream.writeObject(obj);
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }

        return true;
    }

    public static <T extends Serializable> boolean updateData(T newData) {
        ArrayList<T> objects = (ArrayList<T>) Admin.retrieveData(newData.getClass());
        boolean flag = false;

        switch (newData) {
            case Teacher newTeacher -> {
                for (int i = 0; i < objects.size(); i++) {
                    Teacher t = (Teacher) objects.get(i);
                    if (t.getID().equals(newTeacher.getID())) {
                        objects.set(i, (T) newTeacher);
                        flag = true;
                        break;
                    }
                }
            }
            case Student newStudent -> {
                for (int i = 0; i < objects.size(); i++) {
                    Student s = (Student) objects.get(i);
                    if (s.getStudentID().equals(newStudent.getStudentID())) {
                        objects.set(i, (T) newStudent);
                        flag = true;
                        break;
                    }
                }
            }
            case Course newCourse -> {
                for (int i = 0; i < objects.size(); i++) {
                    Course c = (Course) objects.get(i);
                    if (c.getID().equals(newCourse.getID())) {
                        objects.set(i, (T) newCourse);
                        flag = true;
                        break;
                    }
                }
            }
            default -> {
            }
        }

        if (!flag) {
            System.out.println("There is no " + newData.getClass().getSimpleName().toLowerCase() + " with this data to update.");
            return false;
        }

        String filename = "Files/" + newData.getClass().getSimpleName() + "s.txt";

        try (FileOutputStream fileOutputStream = new FileOutputStream(filename);
             ObjectOutputStream objectOutputStream = new ObjectOutputStream(fileOutputStream)) {
            for (T obj : objects) {
                objectOutputStream.writeObject(obj);
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }

        return true;
    }


    public static <T extends Serializable>ArrayList<T> retrieveData(Class<T> clazz) {
        ArrayList<T> data = new ArrayList<>();
        String filename = "Files/" + clazz.getSimpleName() + "s.txt";
        if (!(new File(filename)).exists())
            return data;
        try (FileInputStream fileInputStream = new FileInputStream(filename);
             ObjectInputStream objectInputStream = new ObjectInputStream(fileInputStream)) {
            while (true) {
                try {
                    T obj = (T) objectInputStream.readObject();
                    data.add(obj);
                } catch (EOFException e) {
                    break;
                } catch (ClassNotFoundException e) {
                    e.printStackTrace();
                    break;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return data;
    }

    public static void  clear(){
        System.out.println("\033[H\033[2J");
        System.out.flush();
    }
}