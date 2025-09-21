import java.util.HashMap;
import java.util.Scanner;
import java.util.TreeMap;

public class Main {
    public static void main(String[] args) {

        String[][] stateCapitalPairs = {
                {"Alabama", "Montgomery"}, {"Alaska", "Juneau"},
                {"Arizona", "Phoenix"}, {"Arkansas", "Little Rock"},
                {"California", "Sacramento"}, {"Colorado", "Denver"},
                {"Connecticut", "Hartford"}, {"Delaware", "Dover"},
                {"Florida", "Tallahassee"}, {"Georgia", "Atlanta"},
                {"Hawaii", "Honolulu"}, {"Idaho", "Boise"},
                {"Illinois", "Springfield"}, {"Indiana", "Indianapolis"},
                {"Iowa", "Des Moines"}, {"Kansas", "Topeka"},
                {"Kentucky", "Frankfort"}, {"Louisiana", "Baton Rouge"},
                {"Maine", "Augusta"}, {"Maryland", "Annapolis"},
                {"Massachusetts", "Boston"}, {"Michigan", "Lansing"},
                {"Minnesota", "St. Paul"}, {"Mississippi", "Jackson"},
                {"Missouri", "Jefferson City"}, {"Montana", "Helena"},
                {"Nebraska", "Lincoln"}, {"Nevada", "Carson City"},
                {"New Hampshire", "Concord"}, {"New Jersey", "Trenton"},
                {"New Mexico", "Santa Fe"}, {"New York", "Albany"},
                {"North Carolina", "Raleigh"}, {"North Dakota", "Bismarck"},
                {"Ohio", "Columbus"}, {"Oklahoma", "Oklahoma City"},
                {"Oregon", "Salem"}, {"Pennsylvania", "Harrisburg"},
                {"Rhode Island", "Providence"}, {"South Carolina", "Columbia"},
                {"South Dakota", "Pierre"}, {"Tennessee", "Nashville"},
                {"Texas", "Austin"}, {"Utah", "Salt Lake City"},
                {"Vermont", "Montpelier"}, {"Virginia", "Richmond"},
                {"Washington", "Olympia"}, {"West Virginia", "Charleston"},
                {"Wisconsin", "Madison"}, {"Wyoming", "Cheyenne"}
        };
        Scanner scanner = new Scanner(System.in);

        CapitalQuizApp app = new CapitalQuizApp(stateCapitalPairs, scanner);

        app.runQuiz();

        System.out.println("\nList of US State Capitals (Unsorted:) \n");
        CapitalQuizApp.print2DArray(stateCapitalPairs);

        String[][] sortedByCapital = CapitalQuizApp.clone2D(stateCapitalPairs);
        CapitalQuizApp.bubbleSort(sortedByCapital);
        System.out.println("\nList of US State Capitals (Sorted): \n");
        CapitalQuizApp.print2DArray(sortedByCapital);

        HashMap<String, String> hashMap = CapitalQuizApp.toHashMap(stateCapitalPairs);
        System.out.println("\n US Capital in HashMap: \n");
        CapitalQuizApp.printMap(hashMap);

        TreeMap<String, String> treeMap = CapitalQuizApp.toTreeMap(hashMap);
        CapitalQuizApp.printMap(treeMap);

        app.runQuery(treeMap);
        scanner.close();
    }
}