package miniP;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;

public class Server {
    public static void main(String[] args) throws IOException {
        ServerSocket ss = new ServerSocket(8080);
        while (true) {
            System.out.println("The server is starting ...");
            new ClientHandler(ss.accept()).start();
        }

    }
}




class ClientHandler extends Thread{

    DataOutputStream dos;
    DataInputStream dis;
    Socket socket;

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
            String[] queryArr = query.split("-");
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
                    ArrayList<Student> studentsInfo = Admin.retrieveData(Student.class);
                    String sid = queryArr[1];
                    String info = "";

                    for(Student st : studentsInfo){
                        if(st.getSID().equals(sid)){
                            info = st.getStudentName() + "-دانشجو-" + st.getSID() + "-" +st.getCurrentTerm() + '-' + st.getNumberOfUnits() + '-' + st.getAverageScore();
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
                    ArrayList<Student>  listStudents = Admin.retrieveData(Student.class);
                    sid = queryArr[1];
                    String passwordUserR = queryArr[2];
                    String newPasswordUserR = queryArr[3];
                    System.out.println(sid + "-" + passwordUserR + "-" + newPasswordUserR);


                    for(Student s : listStudents){
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

            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }finally {

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


