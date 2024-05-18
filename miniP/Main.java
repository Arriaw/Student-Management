
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner; 
import java.util.regex.*;
import java.util.stream.Stream;

public class Main {

    static boolean validPassword(String password, String username){

        if (password.equals(username)){
            return false; 
        }
        
        Pattern pt = Pattern.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$"); 
        Matcher mt = pt.matcher(password);


        if(mt.matches()){
            return true; 
        }else { 
            return false; 
        }
        
        
    }

    static boolean userIsValid(String userName){

        /*check if the username exist in the database */
        return true; 

    }

    void x(){
        
    }

    static ArrayList<Course> RetrieveCourse(){
        
        /* Retrieve courses from the database */

        ArrayList<Course> courses = null; 
        
        return courses; 
    } 



    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        
        
        System.out.println("|----------------Role Selecting----------------|");
        System.out.print("""
                Which one is your role:

                    1.Admin

                    2.Teacher
                    
                    3.Student
                    
                :""");

        
        int privilege = input.nextInt();
        
        Mainsw: switch (privilege) {
            case 1:
                    System.out.println("\033[H\033[2J");
                    System.out.flush();

                    
                    System.out.println("|----------------Welcome Admin----------------|");
                     
                    System.out.println("""

                        1.Add new teacher
                        2.Remove teacher 
                        3.Add new assignments 
                        4.Remove an assignment 
                        5.Add new student
                        6.remove a student
                        """);
                        int userSelect = input.nextInt();

            out : while(true){

                    
                    
                    switch (userSelect) {
                        case 1:


                            System.out.println("\033[H\033[2J");
                            System.out.flush();
                            System.out.println("|----------------Adding new teacher----------------|");

                            System.out.print("First name: ");
                            input.nextLine();
                            String firstName = input.nextLine();
                            System.out.println();

                            System.out.println("\033[H\033[2J");
                            System.out.flush();

                            System.out.print("Last name: "); 
                            String lastName = input.nextLine();

                            System.out.println("\033[H\033[2J");
                            System.out.flush();
                            String username = ""; 
                            String password = ""; 
                            
                            user: while(true){
                                System.out.println("Enter username: ");
                                username = input.nextLine(); 
                                System.out.println("\033[H\033[2J");
                                System.out.flush();

                                if (userIsValid(username)) {

                                    /*check if username doesn't exist */

                                    break user;

                                }else{
                                    System.out.println("\033[H\033[2J");
                                    System.out.flush();

                                    System.out.println("This username already exists !");
                                    continue; 

                                }
                            

                                
                            }

                                


                                
                            pass: while(true){
                                System.out.println("\033[H\033[2J");
                                System.out.flush();

                                System.out.println("Enter a password: ");
                                password = input.nextLine();
                                System.out.println("\033[H\033[2J");
                                System.out.flush();

                                System.out.println("Repeat the password: ");
                                String password2 = input.nextLine(); 
                                System.out.println("\033[H\033[2J");
                                System.out.flush();

                                if (!password.equals(password2)){
                                    
                                    System.out.println("\033[H\033[2J");
                                    System.out.flush();

                                    System.out.println("the password is not the same !");
                                    continue; 
                                }
                                
                                

                              

                                    /*check if username doesn't exist */

                                    if(validPassword(password, username)){

                                        /* save new teacher to the database */
        
                                        System.out.println(username + "As a teacher added !");
                                    }else{
                                        System.out.println("\033[H\033[2J");
                                        System.out.flush();
                                        System.out.println("The password is not valid !");
                                        continue; 
                                    }
                                

                              

                    }
                        



                        case 2:
                            
                            System.out.println("\033[H\033[2J");
                            System.out.flush();

                            System.out.println("|----------------Removing a teacher (from the course)----------------|");


                            ArrayList<Course> courses = new ArrayList<>();
                            
                            courses = RetrieveCourse(); 
                            /* retreive courses from the database */

                            System.out.print("Enter its course's name: ");
                            String nameCourse = input.nextLine();
                            
                            // Stream<Course> spCourse = courses.stream().filter(x -> x.getName().equals(nameCourse));
                            Stream<Course> spCourse = null;  
                            // Stream<Course> spCourse = null; 
                            System.out.println("\033[H\033[2J");
                            System.out.flush();
                            

                            System.out.print("Are you sure to remove the teacher ! ");
                            ((Course) spCourse.toArray()[0]).setTeacher(null); 
                            
                            String sure = input.nextLine(); 

                            if(sure.equals("yes")){
                                System.out.println("teacher removed from the course successfully !");
                            }
                            break; 

                        case 3: 


                            break; 
                        
                        case 4: 
                            break; 
                        
                        case 5:
                            break;

                        case 6: 
                            break out;

                        
                        default:
                            break;
                    }
                }
                   

                
            case 2:
                System.out.println("welcome Teacher: ");
                break; 

            case 3: 
                System.out.println("welcome Student: ");
                break; 

            case 4: 
                break Mainsw; 
                
                
            default:
                System.out.println("\033[H\033[2J");
                System.out.flush();
                break;
        }

    }
}


