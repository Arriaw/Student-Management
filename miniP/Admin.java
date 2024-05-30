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

    public static Admin getInstance() {
        if (admin == null){
            admin  = new Admin();
        }
        return admin;
    }

    public static String  getSha256(String pass) {
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
                    return password.equals(getSha256(pass));

                case "Logout":
                    System.out.println("Are you sure ?");
                    return input.nextLine().equals("yes") | input.nextLine().equals("Yes") | input.nextLine().equals("YES");

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

    public boolean addTeacher(String name, String Id){
        boolean exist = false;
        ArrayList<Teacher> teachers = retrieveTeachers();
        int teacherCount = getTeacherCount();
        Teacher teacher = new Teacher(name, Id, teacherCount);

        if(teachers != null)
            exist = teachers.stream().anyMatch(tea -> tea.getId().equals(teacher.getId()));


        if(!exist)
           if(saveTeacher(teacher)) {
               setTeacherCount(teacherCount + 1);
               return true;
           }
        else
            return false;

        return false;
    }

    public static int getTeacherCount(){
        try(RandomAccessFile raf = new RandomAccessFile("./Files/TeacherData.txt", "r");) {

            String line;
            int teacherCount = 0;

            Pattern pt = Pattern.compile("teacherCount :(\\d+)");

            while((line = raf.readLine()) != null){
                Matcher mt = pt.matcher(line);
                if(mt.matches()){
                    teacherCount = Integer.parseInt(line.split(":")[1]);
                }
            }
            return teacherCount;
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }


    public boolean saveTeacher(Teacher teacher){
        if (getTeacherCount() == 0) {
            try (FileOutputStream f = new FileOutputStream("./Files/Teachers.txt");
                 ObjectOutputStream out = new ObjectOutputStream(f)) {

                out.writeObject(teacher);

                return true;
            } catch (IOException e) {
                return false;
            }

        }else{
            try(FileOutputStream f = new FileOutputStream("./Files/Teachers.txt", true);
                AppendableObjectOutputStream out = new AppendableObjectOutputStream(f)) {
                out.writeObject(teacher);
                return true;
            } catch (IOException e) {
                return false;
            }
        }
    }

    public void setTeacherCount(int count){
        try(BufferedReader reader = new BufferedReader(new FileReader("./Files/TeacherData.txt"))){
            String line;
            Pattern pt = Pattern.compile("teacherCount :(\\d+)");
            while((line = reader.readLine()) != null){
                Matcher mt = pt.matcher(line);
                if(mt.matches()){
                    line = line.split(":")[0] + ":" + count;
                }

                FileWriter fileWriter = new FileWriter("./Files/tmp.txt", true);
                fileWriter.write(line + "\n");
                fileWriter.close();

            }

            PrintWriter printWriter = new PrintWriter("./Files/TeacherData.txt");
            printWriter.print("");
            printWriter.close();


            BufferedReader reader2 = new BufferedReader(new FileReader("./Files/tmp.txt"));
            while ((line = reader2.readLine()) != null){
                FileWriter writer = new FileWriter("./Files/TeacherData.txt");
                writer.write(line);
                writer.close();
            }


            FileWriter fileWriter = new FileWriter("./Files/tmp.txt");
            fileWriter.write("");
            fileWriter.close();

        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public ArrayList<Teacher> retrieveTeachers() {
        ArrayList<Teacher> teachers = new ArrayList<>();
        try (FileInputStream f = new FileInputStream("./Files/Teachers.txt");
             ObjectInputStream in = new ObjectInputStream(f)) {

            while (true) {
                try {
                    Teacher t = (Teacher) in.readObject();
                    teachers.add(t);
                } catch (IOException e) {
                    break;
                } catch (ClassNotFoundException e) {
                    e.printStackTrace();
                    break;
                }
            }
        } catch (IOException e) {
            throw new RuntimeException("Error reading teacher data!", e);
        }
        return teachers;
    }

    public static void  clear(){
        System.out.println("\033[H\033[2J");
        System.out.flush();
    }
}
