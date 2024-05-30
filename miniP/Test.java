//package miniP;
//
//public class Test {
//   public static void main(String[] args) {
//       Course c1 = new Course("Advanced Programming", 3, "2024-06-20");
//       Course c2 = new Course("Digital Logic Circuit", 3, "2024-06-21");
//       Course c3 = new Course("Az physic", 1, "2024-06-19");
//
//       Teacher t1 = new Teacher("Vahidi");
//       Teacher t2 = new Teacher("Mahdiani");
//       Teacher t3 = new Teacher("Shiravand");
//
//       Student s1 = new Student("Aria", "1");
//       Student s2 = new Student("Ariaa", "2");
//       Student s3 = new Student("Ariaaa", "3");
//       Student s4 = new Student("Ariaaaaa", "4");
//       s4.printCourses();
//       s4.printRecord();
//
//       Assignment a1 = new Assignment(c1, "2024-04-18", "PSET", "PSET", 0.1);
//       Assignment a2 = new Assignment(c1, "2024-04-19", "PSET", "PSET", 0.1);
//       Assignment a3 = new Assignment(c2, "2024-04-20", "PSET", "PSET", 0.1);
//       Assignment a4 = new Assignment(c2, "2024-04-07", "PSET", "PSET", 0.1);
//       Assignment a5 = new Assignment(c2, "2024-04-29", "PSET", "PSET", 0.1);
//       Assignment a6 = new Assignment(c3, "2024-04-10", "PSET", "PSET", 0.1);
//
//       a1.printRemainingDays();
//       a4.printRemainingDays();
//
//       t1.addCourse(c1);
//       // t1.printCourses();
//       t1.addStudent(s1, c1);
//       t1.addStudent(s2, c1);
//       // t1.removeStudent(s1, c1);
//       // t1.removeStudent(s3, c3);
//       System.out.println(c1.getStudentCount());
//       // c1.printStudents();
//
//       t2.addCourse(c2);
//       t2.addStudent(s1, c2);
//       // t2.addStudent(s2, c2);
//       t2.addStudent(s4, c2);
//       t2.addStudent(s3, c2);
//       System.out.println(c2.getStudentCount());
//
//       t2.setScore(s1, c2, 19.5);
//       t1.setScore(s1, c1, 19);
//
//       System.out.println(s1.getAverageScore());
//       s1.printCourses();
//       System.out.println(s1.getNumberOfUnits());
//
//       s1.printRecord();
//
//       System.out.println(c2.getExamDate());
//
//       t2.setScore(s2, c2, 17);
//       t2.setScore(s3, c2, 18);
//       t2.setScore(s3, c2, 17.7);
//       // c2.removeStudent(s1);
//       // c2.printStudents();
//       c2.printTopStudents();
//       s1.printRecord();
//       System.out.println(s1.worstCourse().getName());
//       // s1.printCourses();
//       // s1.printRecord();
//   }
//}
