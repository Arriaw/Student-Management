package miniP;
import java.io.*;
import java.util.ArrayList;
import java.util.Scanner;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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

            if (flag){
                option = input.nextLine();
            }

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

            if (!flag){
                break;
            }

        }

        return flag;
    }

    public static boolean addTeacher(Teacher teacher) {
        boolean fileExists = new File("Files/Teachers.txt").exists();

        try (FileOutputStream fileOutputStream = new FileOutputStream("Files/Teachers.txt", true);
             ObjectOutputStream objectOutputStream = fileExists ?
                     new AppendableObjectOutputStream(fileOutputStream) :
                     new ObjectOutputStream(fileOutputStream)) {
            ArrayList<Teacher> teachers = Admin.retrieveTeachers();
            if (teachers.contains(teacher)) {
                System.out.println("Teacher is already added.");
                return false;
            }
            objectOutputStream.writeObject(teacher);
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }

        return true;
    }

    public static boolean removeTeacher(Teacher teacher) {
        ArrayList<Teacher> teachers = Admin.retrieveTeachers();
        boolean flag = false;
        for (Teacher t : teachers) {
            if (t.getTeacherName().equals(teacher.getTeacherName())
                && t.getID().equals(teacher.getID()) && t.getPassword().equals(teacher.getPassword())) {
                flag = true;
                teachers.remove(t);
                break;
            }
        }
        if (!flag) {
            System.out.println("There is no teacher with this data.");
            return false;
        }

        try (FileOutputStream fileOutputStream = new FileOutputStream("Files/Teachers.txt");
             ObjectOutputStream objectOutputStream = new ObjectOutputStream(fileOutputStream)) {
            for (Teacher p : teachers) {
                objectOutputStream.writeObject(p);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return true;
    }
    public static ArrayList<Teacher> retrieveTeachers() {
        ArrayList<Teacher> teachers = new ArrayList<>();
        try (FileInputStream fileInputStream = new FileInputStream("Files/Teachers.txt");
             ObjectInputStream objectInputStream = new ObjectInputStream(fileInputStream)) {
            while (true) {
                try {
                    Teacher t = (Teacher) objectInputStream.readObject();
                    teachers.add(t);
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
        return teachers;
    }

    public static void  clear(){
        System.out.println("\033[H\033[2J");
        System.out.flush();
    }
}